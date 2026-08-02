import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_navigator.dart';
import 'app_router.dart';

/// Provider for global [AppRouter] instance.
final appRouterProvider = Provider<AppRouter>((ref) {
  return AppRouter();
});

/// Provider for [AppNavigator] facade.
final appNavigatorProvider = Provider<AppNavigator>((ref) {
  final appRouter = ref.watch(appRouterProvider);
  return AppNavigatorImpl(appRouter);
});
