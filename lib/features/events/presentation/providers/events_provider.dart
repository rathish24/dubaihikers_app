import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../leads/data/models/event_model.dart';
import '../../data/datasources/events_remote_datasource.dart';
import '../../data/repositories/events_repository_impl.dart';
import '../../domain/repositories/events_repository.dart';

/// Provider for [EventsRepository]
final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final remoteDataSource =
      EventsRemoteDataSourceImpl(supabaseClient: supabaseClient);
  return EventsRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Holds state for Events Screen
class EventsState {
  final bool isLoading;
  final List<EventModel> events;
  final String searchQuery;
  final String? selectedDifficulty;
  final String? errorMessage;

  const EventsState({
    this.isLoading = false,
    this.events = const [],
    this.searchQuery = '',
    this.selectedDifficulty,
    this.errorMessage,
  });

  EventsState copyWith({
    bool? isLoading,
    List<EventModel>? events,
    String? searchQuery,
    String? selectedDifficulty,
    String? errorMessage,
  }) {
    return EventsState(
      isLoading: isLoading ?? this.isLoading,
      events: events ?? this.events,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      errorMessage: errorMessage,
    );
  }

  /// Returns events filtered by search query and difficulty.
  List<EventModel> get filteredEvents {
    return events.where((event) {
      final matchesDifficulty = selectedDifficulty == null ||
          selectedDifficulty == 'all' ||
          (event.difficulty?.toLowerCase() ==
              selectedDifficulty?.toLowerCase());

      final query = searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          event.name.toLowerCase().contains(query) ||
          (event.locationName?.toLowerCase().contains(query) ?? false) ||
          (event.description?.toLowerCase().contains(query) ?? false);

      return matchesDifficulty && matchesSearch;
    }).toList();
  }
}

/// Notifier to manage Events state
class EventsNotifier extends StateNotifier<EventsState> {
  final EventsRepository repository;

  EventsNotifier({required this.repository}) : super(const EventsState()) {
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await repository.getEvents();
      state = state.copyWith(
        isLoading: false,
        events: list,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load events: ${e.toString()}',
      );
    }
  }

  Future<bool> updateEvent(EventModel updatedEvent) async {
    try {
      await repository.updateEvent(updatedEvent);
      state = state.copyWith(
        events: state.events
            .map((e) => e.id == updatedEvent.id ? updatedEvent : e)
            .toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update event: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    try {
      await repository.deleteEvent(eventId);
      state = state.copyWith(
        events: state.events.where((e) => e.id != eventId).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to delete event: ${e.toString()}',
      );
      return false;
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSelectedDifficulty(String? difficulty) {
    state = state.copyWith(selectedDifficulty: difficulty);
  }
}

/// Main provider for Events state management
final eventsNotifierProvider =
    StateNotifierProvider<EventsNotifier, EventsState>((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return EventsNotifier(repository: repository);
});
