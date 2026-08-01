import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dubaihikers_app/features/events/domain/repositories/events_repository.dart';
import 'package:dubaihikers_app/features/events/presentation/providers/events_provider.dart';
import 'package:dubaihikers_app/features/leads/data/models/event_model.dart';

class MockEventsRepository extends Mock implements EventsRepository {}

void main() {
  late MockEventsRepository mockRepository;

  final sampleEvents = [
    const EventModel(
      id: 'event-1',
      name: 'Shawka Dam Trail',
      difficulty: 'moderate',
      locationName: 'Wadi Shawka',
      price: 155.0,
    ),
    const EventModel(
      id: 'event-2',
      name: 'Sheri Village Trail',
      difficulty: 'advanced',
      locationName: 'Northern RAK',
      price: 195.0,
    ),
  ];

  setUp(() {
    mockRepository = MockEventsRepository();
    when(() => mockRepository.getEvents())
        .thenAnswer((_) async => sampleEvents);
  });

  test('EventsNotifier loads events successfully', () async {
    final container = ProviderContainer(
      overrides: [
        eventsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(eventsNotifierProvider.notifier);
    await notifier.fetchEvents();

    final state = container.read(eventsNotifierProvider);
    expect(state.isLoading, isFalse);
    expect(state.events.length, equals(2));
    expect(state.errorMessage, isNull);
  });

  test('EventsNotifier search query filters events correctly', () async {
    final container = ProviderContainer(
      overrides: [
        eventsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(eventsNotifierProvider.notifier);
    await notifier.fetchEvents();

    notifier.setSearchQuery('Shawka');

    final state = container.read(eventsNotifierProvider);
    expect(state.filteredEvents.length, equals(1));
    expect(state.filteredEvents.first.name, equals('Shawka Dam Trail'));
  });

  test('EventsNotifier difficulty filter works correctly', () async {
    final container = ProviderContainer(
      overrides: [
        eventsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(eventsNotifierProvider.notifier);
    await notifier.fetchEvents();

    notifier.setSelectedDifficulty('advanced');

    final state = container.read(eventsNotifierProvider);
    expect(state.filteredEvents.length, equals(1));
    expect(state.filteredEvents.first.name, equals('Sheri Village Trail'));
  });
}
