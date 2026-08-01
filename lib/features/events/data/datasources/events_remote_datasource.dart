import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../leads/data/models/event_model.dart';

abstract class EventsRemoteDataSource {
  Future<List<EventModel>> fetchEvents();
  Future<void> updateEvent(EventModel event);
  Future<void> deleteEvent(String eventId);
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final SupabaseClient supabaseClient;

  EventsRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<EventModel>> fetchEvents() async {
    final response = await supabaseClient
        .from(SupabaseConstants.eventsTable)
        .select('*')
        .order('starts_at', ascending: true);

    final dataList = response as List<dynamic>;
    return dataList
        .map((json) => EventModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    final payload = event.toJson();
    payload.removeWhere((key, value) => value == null);

    await supabaseClient
        .from(SupabaseConstants.eventsTable)
        .update(payload)
        .eq('id', event.id);
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await supabaseClient
        .from(SupabaseConstants.eventsTable)
        .delete()
        .eq('id', eventId);
  }
}
