import 'package:flutter_test/flutter_test.dart';
import 'package:dubaihikers_app/features/leads/data/models/lead_model.dart';
import 'package:dubaihikers_app/features/leads/data/models/event_model.dart';

void main() {
  group('LeadModel & EventModel JSON Deserialization', () {
    test('EventModel.fromJson creates valid object', () {
      final json = {
        'id': 'event-123',
        'name': 'Shawka Dam Mountain Trail',
        'starts_at': '2026-08-22T01:30:00+00:00',
        'location_name': 'Ras Al Khaimah',
        'status': 'published',
        'price': 150.0,
        'currency': 'AED',
        'available_slots': 20,
      };

      final event = EventModel.fromJson(json);

      expect(event.id, equals('event-123'));
      expect(event.name, equals('Shawka Dam Mountain Trail'));
      expect(event.startsAt, isNotNull);
      expect(event.price, equals(150.0));
      expect(event.currency, equals('AED'));
    });

    test('LeadModel.fromJson creates valid object with nested Event', () {
      final json = {
        'id': 'registration-456',
        'reference_number': 'REF1001',
        'event_id': 'event-123',
        'contact_name': 'Rathish',
        'contact_email': 'rathishk24@gmail.com',
        'contact_phone': '+919176008276',
        'number_of_hikers': 2,
        'customer_notes': 'Is insurance included?',
        'unit_price': 150.0,
        'total_amount': 300.0,
        'currency': 'AED',
        'status': 'confirmed',
        'payment_status': 'paid',
        'created_at': '2026-07-29T18:26:37.806115+00:00',
        'events': {
          'id': 'event-123',
          'name': 'Shawka Dam Mountain Trail',
          'starts_at': '2026-08-22T01:30:00+00:00',
          'location_name': 'Ras Al Khaimah',
          'status': 'published',
          'price': 150.0,
          'currency': 'AED',
          'available_slots': 20,
        }
      };

      final lead = LeadModel.fromJson(json);

      expect(lead.id, equals('registration-456'));
      expect(lead.referenceNumber, equals('REF1001'));
      expect(lead.contactName, equals('Rathish'));
      expect(lead.contactEmail, equals('rathishk24@gmail.com'));
      expect(lead.contactPhone, equals('+919176008276'));
      expect(lead.numberOfHikers, equals(2));
      expect(lead.customerNotes, equals('Is insurance included?'));
      expect(lead.event, isNotNull);
      expect(lead.event?.name, equals('Shawka Dam Mountain Trail'));
    });
  });
}
