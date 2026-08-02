---
name: flutter-setup-declarative-routing
description: Configure `MaterialApp.router` using `go_router` with a decoupled `AppNavigator` abstraction layer for type-safe navigation, deep linking, push notification payload routing, and seamless unit testing.
metadata:
  model: models/gemini-3.6-flash
  last_modified: Wed, 22 Jul 2026 23:55:00 GMT
---
# Declarative Routing, Deep Linking, & AppNavigator Abstraction

## Contents
- [Core Architecture & Concepts](#core-architecture--concepts)
- [Workflow: Initializing Router & AppNavigator Abstraction](#workflow-initializing-router--appnavigator-abstraction)
- [Workflow: Deep Links & Push Notification Payload Handling](#workflow-deep-links--push-notification-payload-handling)
- [Workflow: Configuring Platform Deep Linking](#workflow-configuring-platform-deep-linking)
- [Workflow: Implementing Stateful Shell & Nested Navigation](#workflow-implementing-stateful-shell--nested-navigation)
- [Workflow: Unit Testing Navigation](#workflow-unit-testing-navigation)

---

## Core Architecture & Concepts

Use `go_router` as the routing engine, wrapped inside a decoupled `AppNavigator` interface layer (Facade/Navigation Gateway pattern).

- **AppRouter**: Holds the central `GoRouter` instance, route tree constants, `onException` fallback redirects, and branch definitions.
- **AppNavigator Interface**: Abstract facade used by UI widgets and BLoCs/Controllers instead of invoking `context.go()` string paths directly.
- **StatefulShellRoute**: Maintains persistent navigation state across parallel bottom navigation branches.
- **Path URL Strategy**: Calls `usePathUrlStrategy()` at app startup (`main.dart`) to remove `#` fragments from Web URLs.
- **Payload & Link Resolvers**: Handles incoming platform deep link `Uri` objects and FCM/APNs push notification JSON payloads.

---

## Workflow: Initializing Router & AppNavigator Abstraction

### 1. Define AppRouter with Named & Parameterized Routes
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/home';
  static const String teacher = '/teacher';
  static const String teacherDetail = '/teacher/:id';
  static const String addTeacher = '/add-teacher';

  static const String homeName = 'home';
  static const String teacherName = 'teacher';
  static const String teacherDetailName = 'teacherDetail';
  static const String addTeacherName = 'addTeacher';

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                name: homeName,
                builder: (context, state) => const HomeTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: teacher,
                name: teacherName,
                builder: (context, state) => const TeachersTab(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: teacherDetailName,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return TeacherDetailPage(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: navigatorKey,
        path: addTeacher,
        name: addTeacherName,
        builder: (context, state) => const AddTeacherPage(),
      ),
    ],
    onException: (context, state, router) {
      router.go(home);
    },
  );
}
```

### 2. Define AppNavigator Interface & Implementation
```dart
abstract class AppNavigator {
  void goToHome();
  void goToTeacher();
  void goToTeacherDetail(String id);
  void goToAddTeacher();
  void handleDeepLink(Uri uri);
  void handleNotificationPayload(Map<String, dynamic> payload);
  void goBack();
}

class AppNavigatorImpl implements AppNavigator {
  final AppRouter appRouter;

  AppNavigatorImpl(this.appRouter);

  @override
  void goToHome() => appRouter.router.go(AppRouter.home);

  @override
  void goToTeacher() => appRouter.router.go(AppRouter.teacher);

  @override
  void goToTeacherDetail(String id) {
    appRouter.router.goNamed(
      AppRouter.teacherDetailName,
      pathParameters: {'id': id},
    );
  }

  @override
  void goToAddTeacher() => appRouter.router.go(AppRouter.addTeacher);

  @override
  void handleDeepLink(Uri uri) {
    String path;
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      path = uri.path;
    } else {
      final hostStr = uri.host.isNotEmpty ? '/${uri.host}' : '';
      path = '$hostStr${uri.path}';
    }
    if (path.isEmpty) path = AppRouter.home;
    final fullPath = uri.hasQuery ? '$path?${uri.query}' : path;
    final formattedPath = fullPath.startsWith('/') ? fullPath : '/$fullPath';
    appRouter.router.go(formattedPath);
  }

  @override
  void handleNotificationPayload(Map<String, dynamic> payload) {
    if (payload.containsKey('uri') && payload['uri'] != null) {
      handleDeepLink(Uri.parse(payload['uri'].toString()));
    } else if (payload.containsKey('route') && payload['route'] != null) {
      final route = payload['route'].toString();
      final formattedRoute = route.startsWith('/') ? route : '/$route';
      appRouter.router.go(formattedRoute);
    } else if (payload.containsKey('target') && payload['target'] != null) {
      final target = payload['target'].toString();
      final id = payload['id']?.toString();
      switch (target) {
        case 'teacher':
          if (id != null && id.isNotEmpty) {
            goToTeacherDetail(id);
          } else {
            goToTeacher();
          }
          break;
        case 'addTeacher':
          goToAddTeacher();
          break;
        default:
          goToHome();
      }
    }
  }

  @override
  void goBack() => appRouter.router.pop();
}
```

### 3. Initialize in main.dart & DI
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AppNavigator>.value(
      value: sl<AppNavigator>(),
      child: MaterialApp.router(
        routerConfig: sl<AppRouter>().router,
      ),
    );
  }
}
```

---

## Workflow: Configuring Platform Deep Linking

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<activity android:name=".MainActivity" ...>
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="http" android:host="yourdomain.com" />
        <data android:scheme="https" />
        <data android:scheme="myapp" />
    </intent-filter>
</activity>
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>FlutterDeepLinkingEnabled</key>
<true/>
```

---

## Workflow: Unit Testing Navigation

Using `AppNavigator` enables testing route transitions cleanly using widget tests:

```dart
testWidgets('handleNotificationPayload navigates to teacher detail', (tester) async {
  await tester.pumpWidget(
    RepositoryProvider<AppNavigator>.value(
      value: navigator,
      child: MaterialApp.router(routerConfig: appRouter.router),
    ),
  );
  await tester.pump(const Duration(milliseconds: 300));

  navigator.handleNotificationPayload({'target': 'teacher', 'id': '42'});
  await tester.pump(const Duration(milliseconds: 300));

  expect(
    appRouter.router.routerDelegate.currentConfiguration.uri.toString(),
    equals('/teacher/42'),
  );
});
```
