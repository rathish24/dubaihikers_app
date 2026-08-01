class EventModel {
  final String id;
  final String name;
  final DateTime? startsAt;
  final String? locationName;
  final String? status;
  final double? price;
  final String? currency;
  final int? availableSlots;

  const EventModel({
    required this.id,
    required this.name,
    this.startsAt,
    this.locationName,
    this.status,
    this.price,
    this.currency,
    this.availableSlots,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Untitled Event',
      startsAt: json['starts_at'] != null
          ? DateTime.tryParse(json['starts_at'] as String)
          : null,
      locationName: json['location_name'] as String?,
      status: json['status'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'AED',
      availableSlots: json['available_slots'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'starts_at': startsAt?.toIso8601String(),
      'location_name': locationName,
      'status': status,
      'price': price,
      'currency': currency,
      'available_slots': availableSlots,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
