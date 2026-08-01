import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dubaihikers_app/features/leads/domain/repositories/leads_repository.dart';
import 'package:dubaihikers_app/features/leads/presentation/screens/lead_detail_screen.dart';

void main() {
  const testLead = LeadModel(
    id: 'lead-999',
    referenceNumber: 'REF9999',
    eventId: 'event-1',
    contactName: 'John Doe',
    contactEmail: 'john@example.com',
    contactPhone: '+971551234567',
    numberOfHikers: 3,
    customerNotes: 'Is there parking available near the trail head?',
    totalAmount: 450.0,
    paymentStatus: 'paid',
    event: EventModel(id: 'event-1', name: 'Shawka Dam Trail'),
  );

  testWidgets('LeadDetailScreen displays name, email, contact, and enquiry notes',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LeadDetailScreen(lead: testLead),
      ),
    );

    await tester.pumpAndSettle();

    // Verify contact name, email, phone
    expect(find.text('John Doe'), findsNWidgets(2)); // Header & Contact Info
    expect(find.text('john@example.com'), findsOneWidget);
    expect(find.text('+971551234567'), findsOneWidget);

    // Verify event details
    expect(find.text('Shawka Dam Trail'), findsOneWidget);
    expect(find.text('3 hiker(s)'), findsOneWidget);

    // Verify customer enquiry notes
    expect(find.text('Is there parking available near the trail head?'),
        findsOneWidget);

    // Verify call and email buttons
    expect(find.text('Call'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
  });
}
