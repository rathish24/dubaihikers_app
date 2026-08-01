import '../../domain/repositories/leads_repository.dart';
import '../datasources/leads_remote_datasource.dart';

class LeadsRepositoryImpl implements LeadsRepository {
  final LeadsRemoteDataSource remoteDataSource;

  LeadsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<LeadModel>> getLeads() async {
    return await remoteDataSource.fetchLeads();
  }

  @override
  Future<List<EventModel>> getEvents() async {
    return await remoteDataSource.fetchEvents();
  }
}
