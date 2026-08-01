import '../../data/models/lead_model.dart';
import '../../data/models/event_model.dart';

export '../../data/models/lead_model.dart';
export '../../data/models/event_model.dart';

abstract class LeadsRepository {
  /// Fetches all event registrations (leads), joined with event details.
  Future<List<LeadModel>> getLeads();

  /// Fetches list of all published/available events.
  Future<List<EventModel>> getEvents();
}
