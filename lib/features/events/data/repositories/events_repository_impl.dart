import '../../../leads/data/models/event_model.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_remote_datasource.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource remoteDataSource;

  EventsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<EventModel>> getEvents() async {
    return await remoteDataSource.fetchEvents();
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    await remoteDataSource.updateEvent(event);
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await remoteDataSource.deleteEvent(eventId);
  }
}
