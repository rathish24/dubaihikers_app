import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/leads_remote_datasource.dart';
import '../../data/repositories/leads_repository_impl.dart';
import '../../domain/repositories/leads_repository.dart';

/// Provider for [LeadsRepository]
final leadsRepositoryProvider = Provider<LeadsRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final remoteDataSource =
      LeadsRemoteDataSourceImpl(supabaseClient: supabaseClient);
  return LeadsRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Holds state for the Leads screen
class LeadsState {
  final bool isLoading;
  final List<LeadModel> leads;
  final List<EventModel> events;
  final String searchQuery;
  final String? selectedEventId;
  final String? errorMessage;

  const LeadsState({
    this.isLoading = false,
    this.leads = const [],
    this.events = const [],
    this.searchQuery = '',
    this.selectedEventId,
    this.errorMessage,
  });

  LeadsState copyWith({
    bool? isLoading,
    List<LeadModel>? leads,
    List<EventModel>? events,
    String? searchQuery,
    String? selectedEventId,
    String? errorMessage,
  }) {
    return LeadsState(
      isLoading: isLoading ?? this.isLoading,
      leads: leads ?? this.leads,
      events: events ?? this.events,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedEventId: selectedEventId ?? this.selectedEventId,
      errorMessage: errorMessage,
    );
  }

  /// Returns leads filtered by search query and selected event ID.
  List<LeadModel> get filteredLeads {
    return leads.where((lead) {
      final matchesEvent = selectedEventId == null ||
          selectedEventId == 'all' ||
          lead.eventId == selectedEventId;

      final query = searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          lead.contactName.toLowerCase().contains(query) ||
          lead.contactEmail.toLowerCase().contains(query) ||
          lead.contactPhone.toLowerCase().contains(query) ||
          (lead.referenceNumber?.toLowerCase().contains(query) ?? false) ||
          (lead.event?.name.toLowerCase().contains(query) ?? false);

      return matchesEvent && matchesSearch;
    }).toList();
  }

  /// Groups filtered leads by Event Name.
  Map<String, List<LeadModel>> get leadsGroupedByEvent {
    final Map<String, List<LeadModel>> map = {};
    for (final lead in filteredLeads) {
      final eventName = lead.event?.name ?? 'General Registrations';
      if (!map.containsKey(eventName)) {
        map[eventName] = [];
      }
      map[eventName]!.add(lead);
    }
    return map;
  }
}

/// Notifier to manage Leads state
class LeadsNotifier extends StateNotifier<LeadsState> {
  final LeadsRepository repository;

  LeadsNotifier({required this.repository}) : super(const LeadsState()) {
    fetchLeads();
  }

  Future<void> fetchLeads() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final results = await Future.wait([
        repository.getLeads(),
        repository.getEvents(),
      ]);

      final leads = results[0] as List<LeadModel>;
      final events = results[1] as List<EventModel>;

      state = state.copyWith(
        isLoading: false,
        leads: leads,
        events: events,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load leads: ${e.toString()}',
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSelectedEvent(String? eventId) {
    state = state.copyWith(selectedEventId: eventId);
  }
}

/// Main provider for Leads state management
final leadsNotifierProvider =
    StateNotifierProvider<LeadsNotifier, LeadsState>((ref) {
  final repository = ref.watch(leadsRepositoryProvider);
  return LeadsNotifier(repository: repository);
});
