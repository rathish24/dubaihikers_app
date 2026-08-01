import 'event_model.dart';

class LeadModel {
  final String id;
  final String? referenceNumber;
  final String eventId;
  final String contactName;
  final String contactEmail;
  final String contactPhone;
  final int? numberOfHikers;
  final String? customerNotes;
  final double? unitPrice;
  final double? totalAmount;
  final String? currency;
  final String? status;
  final String? paymentStatus;
  final DateTime? createdAt;
  final EventModel? event;

  const LeadModel({
    required this.id,
    this.referenceNumber,
    required this.eventId,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    this.numberOfHikers,
    this.customerNotes,
    this.unitPrice,
    this.totalAmount,
    this.currency,
    this.status,
    this.paymentStatus,
    this.createdAt,
    this.event,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    EventModel? parsedEvent;
    if (json['events'] != null && json['events'] is Map<String, dynamic>) {
      parsedEvent = EventModel.fromJson(json['events'] as Map<String, dynamic>);
    }

    return LeadModel(
      id: json['id'] as String? ?? '',
      referenceNumber: json['reference_number'] as String?,
      eventId: json['event_id'] as String? ?? '',
      contactName: json['contact_name'] as String? ?? 'N/A',
      contactEmail: json['contact_email'] as String? ?? 'N/A',
      contactPhone: json['contact_phone'] as String? ?? 'N/A',
      numberOfHikers: json['number_of_hikers'] as int?,
      customerNotes: json['customer_notes'] as String?,
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'AED',
      status: json['status'] as String?,
      paymentStatus: json['payment_status'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      event: parsedEvent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference_number': referenceNumber,
      'event_id': eventId,
      'contact_name': contactName,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'number_of_hikers': numberOfHikers,
      'customer_notes': customerNotes,
      'unit_price': unitPrice,
      'total_amount': totalAmount,
      'currency': currency,
      'status': status,
      'payment_status': paymentStatus,
      'created_at': createdAt?.toIso8601String(),
      if (event != null) 'events': event!.toJson(),
    };
  }

  LeadModel copyWith({
    String? id,
    String? referenceNumber,
    String? eventId,
    String? contactName,
    String? contactEmail,
    String? contactPhone,
    int? numberOfHikers,
    String? customerNotes,
    double? unitPrice,
    double? totalAmount,
    String? currency,
    String? status,
    String? paymentStatus,
    DateTime? createdAt,
    EventModel? event,
  }) {
    return LeadModel(
      id: id ?? this.id,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      eventId: eventId ?? this.eventId,
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      numberOfHikers: numberOfHikers ?? this.numberOfHikers,
      customerNotes: customerNotes ?? this.customerNotes,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      event: event ?? this.event,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeadModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
