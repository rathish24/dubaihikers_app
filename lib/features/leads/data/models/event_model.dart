class EventModel {
  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String? locationName;
  final String? meetingPointLabel;
  final DateTime? startsAt;
  final DateTime? registrationClosesAt;
  final int? durationMinutes;
  final String? difficulty;
  final double? distanceKm;
  final double? elevationGainM;
  final double? price;
  final String? currency;
  final int? capacity;
  final int? availableSlots;
  final String? availability;
  final String? imageUrl;
  final List<String>? highlights;
  final List<String>? includedItems;
  final List<String>? tags;
  final String? status;
  final bool? isFeatured;

  const EventModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.locationName,
    this.meetingPointLabel,
    this.startsAt,
    this.registrationClosesAt,
    this.durationMinutes,
    this.difficulty,
    this.distanceKm,
    this.elevationGainM,
    this.price,
    this.currency,
    this.capacity,
    this.availableSlots,
    this.availability,
    this.imageUrl,
    this.highlights,
    this.includedItems,
    this.tags,
    this.status,
    this.isFeatured,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    List<String>? parseStringList(dynamic val) {
      if (val is List) {
        return val.map((e) => e.toString()).toList();
      }
      return null;
    }

    return EventModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Untitled Event',
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      locationName: json['location_name'] as String?,
      meetingPointLabel: json['meeting_point_label'] as String?,
      startsAt: json['starts_at'] != null
          ? DateTime.tryParse(json['starts_at'] as String)
          : null,
      registrationClosesAt: json['registration_closes_at'] != null
          ? DateTime.tryParse(json['registration_closes_at'] as String)
          : null,
      durationMinutes: json['duration_minutes'] as int?,
      difficulty: json['difficulty'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      elevationGainM: (json['elevation_gain_m'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'AED',
      capacity: json['capacity'] as int?,
      availableSlots: json['available_slots'] as int?,
      availability: json['availability'] as String?,
      imageUrl: json['image_url'] as String?,
      highlights: parseStringList(json['highlights']),
      includedItems: parseStringList(json['included_items']),
      tags: parseStringList(json['tags']),
      status: json['status'] as String?,
      isFeatured: json['is_featured'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'location_name': locationName,
      'meeting_point_label': meetingPointLabel,
      'starts_at': startsAt?.toIso8601String(),
      'registration_closes_at': registrationClosesAt?.toIso8601String(),
      'duration_minutes': durationMinutes,
      'difficulty': difficulty,
      'distance_km': distanceKm,
      'elevation_gain_m': elevationGainM,
      'price': price,
      'currency': currency,
      'capacity': capacity,
      'available_slots': availableSlots,
      'availability': availability,
      'image_url': imageUrl,
      'highlights': highlights,
      'included_items': includedItems,
      'tags': tags,
      'status': status,
      'is_featured': isFeatured,
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
