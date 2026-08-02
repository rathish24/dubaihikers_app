import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/events/presentation/screens/event_detail_screen.dart';
import '../features/events/presentation/screens/events_screen.dart';
import '../features/leads/data/models/event_model.dart';
import '../features/leads/data/models/lead_model.dart';
import '../features/leads/presentation/screens/lead_detail_screen.dart';
import '../features/leads/presentation/screens/leads_screen.dart';
import '../features/navigation/presentation/screens/main_navigation_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';

class AppRouter {
  static const String leadsPath = '/leads';
  static const String leadsName = 'leads';

  static const String leadDetailPath = '/leads/detail';
  static const String leadDetailName = 'leadDetail';

  static const String eventsPath = '/events';
  static const String eventsName = 'events';

  static const String eventDetailPath = '/events/detail';
  static const String eventDetailName = 'eventDetail';

  static const String profilePath = '/profile';
  static const String profileName = 'profile';

  final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'rootKey',
  );

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: leadsPath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Leads
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: leadsPath,
                name: leadsName,
                builder: (context, state) => const LeadsScreen(),
              ),
            ],
          ),
          // Branch 2: Events
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: eventsPath,
                name: eventsName,
                builder: (context, state) => const EventsScreen(),
              ),
            ],
          ),
          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profilePath,
                name: profileName,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Full screen modal route for Lead Detail
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: leadDetailPath,
        name: leadDetailName,
        builder: (context, state) {
          final lead = state.extra as LeadModel;
          return LeadDetailScreen(lead: lead);
        },
      ),
      // Full screen modal route for Event Detail
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: eventDetailPath,
        name: eventDetailName,
        builder: (context, state) {
          final event = state.extra as EventModel;
          return EventDetailScreen(event: event);
        },
      ),
    ],
    onException: (context, state, router) {
      router.go(leadsPath);
    },
  );
}
