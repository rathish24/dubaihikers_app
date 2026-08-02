import '../features/leads/data/models/event_model.dart';
import '../features/leads/data/models/lead_model.dart';
import 'app_router.dart';

abstract class AppNavigator {
  void goToLeads();
  void goToLeadDetail(LeadModel lead);
  void goToEvents();
  void goToEventDetail(EventModel event);
  void goToProfile();
  void goBack();
}

class AppNavigatorImpl implements AppNavigator {
  final AppRouter appRouter;

  AppNavigatorImpl(this.appRouter);

  @override
  void goToLeads() => appRouter.router.go(AppRouter.leadsPath);

  @override
  void goToLeadDetail(LeadModel lead) {
    appRouter.router.pushNamed(AppRouter.leadDetailName, extra: lead);
  }

  @override
  void goToEvents() => appRouter.router.go(AppRouter.eventsPath);

  @override
  void goToEventDetail(EventModel event) {
    appRouter.router.pushNamed(AppRouter.eventDetailName, extra: event);
  }

  @override
  void goToProfile() => appRouter.router.go(AppRouter.profilePath);

  @override
  void goBack() => appRouter.router.pop();
}
