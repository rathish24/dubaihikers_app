import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../models/event_model.dart';
import '../models/lead_model.dart';

abstract class LeadsRemoteDataSource {
  Future<List<LeadModel>> fetchLeads();
  Future<List<EventModel>> fetchEvents();
}

class LeadsRemoteDataSourceImpl implements LeadsRemoteDataSource {
  final SupabaseClient supabaseClient;

  LeadsRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<LeadModel>> fetchLeads() async {
    final response = await supabaseClient
        .from(SupabaseConstants.eventRegistrationsTable)
        .select('*, events(id, name, starts_at, location_name, status, price, currency, available_slots)')
        .order('created_at', ascending: false);

    final dataList = response as List<dynamic>;
    return dataList
        .map((json) => LeadModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

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
}
