import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dubaihikers_app/routes/app_router.dart';
import 'package:dubaihikers_app/features/leads/domain/repositories/leads_repository.dart';
import 'package:dubaihikers_app/features/leads/providers/leads_provider.dart';
import 'package:dubaihikers_app/features/events/domain/repositories/events_repository.dart';
import 'package:dubaihikers_app/features/events/providers/events_provider.dart';

class MockLeadsRepository extends Mock implements LeadsRepository {}

class MockEventsRepository extends Mock implements EventsRepository {}

void main() {
  late MockLeadsRepository mockLeadsRepository;
  late MockEventsRepository mockEventsRepository;

  setUp(() {
    mockLeadsRepository = MockLeadsRepository();
    mockEventsRepository = MockEventsRepository();

    when(() => mockLeadsRepository.getLeads()).thenAnswer((_) async => []);
    when(() => mockLeadsRepository.getEvents()).thenAnswer((_) async => []);
    when(() => mockEventsRepository.getEvents()).thenAnswer((_) async => []);
  });

  testWidgets(
    'MainNavigationScreen displays 3 bottom tabs (Lead, Event, Profile)',
    (WidgetTester tester) async {
      final appRouter = AppRouter();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            leadsRepositoryProvider.overrideWithValue(mockLeadsRepository),
            eventsRepositoryProvider.overrideWithValue(mockEventsRepository),
          ],
          child: MaterialApp.router(routerConfig: appRouter.router),
        ),
      );

      await tester.pumpAndSettle();

      // Verify 3 bottom navigation tabs exist
      expect(find.text('Lead'), findsOneWidget);
      expect(find.text('Event'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Default tab is Lead
      expect(find.text('Event Leads'), findsOneWidget);

      // Tap Event tab
      await tester.tap(find.text('Event'));
      await tester.pumpAndSettle();

      expect(find.text('Published Events'), findsOneWidget);

      // Tap Profile tab
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Admin Profile'), findsOneWidget);
    },
  );
}
