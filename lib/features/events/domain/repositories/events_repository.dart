import '../../../leads/data/models/event_model.dart';

abstract class EventsRepository {
  Future<List<EventModel>> getEvents();
}
