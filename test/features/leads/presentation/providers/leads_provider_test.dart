import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dubaihikers_app/features/leads/domain/repositories/leads_repository.dart';
import 'package:dubaihikers_app/features/leads/presentation/providers/leads_provider.dart';

class MockLeadsRepository extends Mock implements LeadsRepository {}

void main() {
  late MockLeadsRepository mockRepository;

  final sampleEvents = [
    const EventModel(id: 'event-1', name: 'Shawka Dam'),
    const EventModel(id: 'event-2', name: 'Sheri Village'),
  ];

  final sampleLeads = [
    const LeadModel(
      id: 'lead-1',
      eventId: 'event-1',
      contactName: 'Alice Smith',
      contactEmail: 'alice@example.com',
      contactPhone: '+971500000001',
      customerNotes: 'Need transport',
      event: EventModel(id: 'event-1', name: 'Shawka Dam'),
    ),
    const LeadModel(
      id: 'lead-2',
      eventId: 'event-2',
      contactName: 'Bob Jones',
      contactEmail: 'bob@example.com',
      contactPhone: '+971500000002',
      event: EventModel(id: 'event-2', name: 'Sheri Village'),
    ),
  ];

  setUp(() {
    mockRepository = MockLeadsRepository();
    when(() => mockRepository.getLeads())
        .thenAnswer((_) async => sampleLeads);
    when(() => mockRepository.getEvents())
        .thenAnswer((_) async => sampleEvents);
  });

  test('LeadsNotifier loads leads and events successfully', () async {
    final container = ProviderContainer(
      overrides: [
        leadsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    // Initial fetch happens on instantiation
    final notifier = container.read(leadsNotifierProvider.notifier);
    await notifier.fetchLeads();

    final state = container.read(leadsNotifierProvider);
    expect(state.isLoading, isFalse);
    expect(state.leads.length, equals(2));
    expect(state.events.length, equals(2));
    expect(state.errorMessage, isNull);
  });

  test('LeadsNotifier search query filters leads correctly', () async {
    final container = ProviderContainer(
      overrides: [
        leadsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(leadsNotifierProvider.notifier);
    await notifier.fetchLeads();

    notifier.setSearchQuery('Alice');

    final state = container.read(leadsNotifierProvider);
    expect(state.filteredLeads.length, equals(1));
    expect(state.filteredLeads.first.contactName, equals('Alice Smith'));
  });

  test('LeadsNotifier filtering by event works correctly', () async {
    final container = ProviderContainer(
      overrides: [
        leadsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(leadsNotifierProvider.notifier);
    await notifier.fetchLeads();

    notifier.setSelectedEvent('event-2');

    final state = container.read(leadsNotifierProvider);
    expect(state.filteredLeads.length, equals(1));
    expect(state.filteredLeads.first.contactName, equals('Bob Jones'));
  });
}
