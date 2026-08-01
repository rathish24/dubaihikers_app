import '../../../leads/data/models/event_model.dart';

abstract class EventsRepository {
  Future<List<EventModel>> getEvents();
  Future<void> updateEvent(EventModel event);
  Future<void> deleteEvent(String eventId);
}
