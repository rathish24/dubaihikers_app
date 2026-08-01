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
    when(() => mockRepository.updateEvent(any()))
        .thenAnswer((_) async => {});
    when(() => mockRepository.deleteEvent(any()))
        .thenAnswer((_) async => {});
  });

  setUpAll(() {
    registerFallbackValue(
      const EventModel(id: 'fallback-id', name: 'Fallback Event'),
    );
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

  test('EventsNotifier updateEvent updates existing event in state', () async {
    final container = ProviderContainer(
      overrides: [
        eventsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(eventsNotifierProvider.notifier);
    await notifier.fetchEvents();

    const updatedEvent = EventModel(
      id: 'event-1',
      name: 'Updated Shawka Dam Trail',
      difficulty: 'easy',
      price: 180.0,
    );

    final success = await notifier.updateEvent(updatedEvent);
    expect(success, isTrue);

    final state = container.read(eventsNotifierProvider);
    final found = state.events.firstWhere((e) => e.id == 'event-1');
    expect(found.name, equals('Updated Shawka Dam Trail'));
    expect(found.price, equals(180.0));
  });

  test('EventsNotifier deleteEvent removes event from state', () async {
    final container = ProviderContainer(
      overrides: [
        eventsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(eventsNotifierProvider.notifier);
    await notifier.fetchEvents();

    final success = await notifier.deleteEvent('event-1');
    expect(success, isTrue);

    final state = container.read(eventsNotifierProvider);
    expect(state.events.length, equals(1));
    expect(state.events.any((e) => e.id == 'event-1'), isFalse);
  });
}
