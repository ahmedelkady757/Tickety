import '../../features/home/domain/entities/event_entity.dart';

class FavoriteEventRecord {
  final String userId;
  final String id;
  final String name;
  final String? date;
  final String? time;
  final String? imageUrl;
  final String? venueName;
  final String? city;
  final String? country;
  final double? lat;
  final double? lng;
  final double? priceMin;
  final double? priceMax;
  final String? url;
  final String? classification;
  final String? description;
  final String? organizer;
  final String? address;
  final int createdAt;

  const FavoriteEventRecord({
    required this.userId,
    required this.id,
    required this.name,
    this.date,
    this.time,
    this.imageUrl,
    this.venueName,
    this.city,
    this.country,
    this.lat,
    this.lng,
    this.priceMin,
    this.priceMax,
    this.url,
    this.classification,
    this.description,
    this.organizer,
    this.address,
    required this.createdAt,
  });

  factory FavoriteEventRecord.fromEntity(EventEntity e, String userId) {
    return FavoriteEventRecord(
      userId: userId,
      id: e.id,
      name: e.name,
      date: e.date,
      time: e.time,
      imageUrl: e.imageUrl,
      venueName: e.venueName,
      city: e.city,
      country: e.country,
      lat: e.lat,
      lng: e.lng,
      priceMin: e.priceMin,
      priceMax: e.priceMax,
      url: e.url,
      classification: e.classification,
      description: e.description,
      organizer: e.organizer,
      address: e.address,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, Object?> toMap() => {
        'userId': userId,
        'id': id,
        'name': name,
        'date': date,
        'time': time,
        'imageUrl': imageUrl,
        'venueName': venueName,
        'city': city,
        'country': country,
        'lat': lat,
        'lng': lng,
        'priceMin': priceMin,
        'priceMax': priceMax,
        'url': url,
        'classification': classification,
        'description': description,
        'organizer': organizer,
        'address': address,
        'createdAt': createdAt,
      };

  EventEntity toEntity() => EventEntity(
        id: id,
        name: name,
        date: date,
        time: time,
        imageUrl: imageUrl,
        venueName: venueName,
        city: city,
        country: country,
        lat: lat,
        lng: lng,
        priceMin: priceMin,
        priceMax: priceMax,
        url: url,
        classification: classification,
        description: description,
        organizer: organizer,
        address: address,
      );

  static FavoriteEventRecord fromMap(Map<String, Object?> map) {
    return FavoriteEventRecord(
      userId: map['userId'] as String? ?? 'legacy',
      id: map['id'] as String,
      name: map['name'] as String,
      date: map['date'] as String?,
      time: map['time'] as String?,
      imageUrl: map['imageUrl'] as String?,
      venueName: map['venueName'] as String?,
      city: map['city'] as String?,
      country: map['country'] as String?,
      lat: (map['lat'] as num?)?.toDouble(),
      lng: (map['lng'] as num?)?.toDouble(),
      priceMin: (map['priceMin'] as num?)?.toDouble(),
      priceMax: (map['priceMax'] as num?)?.toDouble(),
      url: map['url'] as String?,
      classification: map['classification'] as String?,
      description: map['description'] as String?,
      organizer: map['organizer'] as String?,
      address: map['address'] as String?,
      createdAt: (map['createdAt'] as int?) ?? 0,
    );
  }
}

