import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dubaihikers_app/main.dart';
import 'package:dubaihikers_app/features/leads/domain/repositories/leads_repository.dart';
import 'package:dubaihikers_app/features/leads/presentation/providers/leads_provider.dart';
import 'package:dubaihikers_app/features/events/domain/repositories/events_repository.dart';
import 'package:dubaihikers_app/features/events/presentation/providers/events_provider.dart';

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

  testWidgets('DubaiHikersApp initializes and renders MainNavigationScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          leadsRepositoryProvider.overrideWithValue(mockLeadsRepository),
          eventsRepositoryProvider.overrideWithValue(mockEventsRepository),
        ],
        child: const DubaiHikersApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Event Leads'), findsOneWidget);
  });
}
