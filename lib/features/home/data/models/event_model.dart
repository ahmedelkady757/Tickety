import '../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.name,
    super.date,
    super.time,
    super.imageUrl,
    super.venueName,
    super.city,
    super.country,
    super.lat,
    super.lng,
    super.priceMin,
    super.priceMax,
    super.url,
    super.classification,
    super.description,
    super.organizer,
    super.address,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl;
    final images = json['images'] as List<dynamic>?;
    if (images != null && images.isNotEmpty) {
      final preferred = images.cast<Map<String, dynamic>>().where(
        (img) => (img['ratio'] as String?) == '16_9' && (img['width'] as int? ?? 0) >= 640,
      );
      imageUrl = (preferred.isNotEmpty ? preferred.first : images.first)['url'] as String?;
    }

    final dates = json['dates'] as Map<String, dynamic>?;
    final start = dates?['start'] as Map<String, dynamic>?;
    final dateStr = start?['localDate'] as String?;
    final timeStr = start?['localTime'] as String?;

    String? venueName, city, country, address;
    double? lat, lng;
    final embedded = json['_embedded'] as Map<String, dynamic>?;
    final venues = embedded?['venues'] as List<dynamic>?;
    if (venues != null && venues.isNotEmpty) {
      final v = venues.first as Map<String, dynamic>;
      venueName = v['name'] as String?;
      city = (v['city'] as Map<String, dynamic>?)?['name'] as String?;
      country = (v['country'] as Map<String, dynamic>?)?['countryCode'] as String?;
      final line1 = v['address'] as Map<String, dynamic>?;
      final line1Str = line1?['line1'] as String?;
      final state = (v['state'] as Map<String, dynamic>?)?['stateCode'] as String?;
      if (line1Str != null) {
        address = state != null ? '$line1Str, $state' : line1Str;
      }
      final locMap = v['location'] as Map<String, dynamic>?;
      if (locMap != null) {
        lat = double.tryParse(locMap['latitude']?.toString() ?? '');
        lng = double.tryParse(locMap['longitude']?.toString() ?? '');
      }
    }

    String? organizer;
    final attractions = embedded?['attractions'] as List<dynamic>?;
    if (attractions != null && attractions.isNotEmpty) {
      organizer = (attractions.first as Map<String, dynamic>)['name'] as String?;
    }

    double? priceMin, priceMax;
    final priceRanges = json['priceRanges'] as List<dynamic>?;
    if (priceRanges != null && priceRanges.isNotEmpty) {
      final pr = priceRanges.first as Map<String, dynamic>;
      priceMin = (pr['min'] as num?)?.toDouble();
      priceMax = (pr['max'] as num?)?.toDouble();
    }

    String? classification;
    final classifications = json['classifications'] as List<dynamic>?;
    if (classifications != null && classifications.isNotEmpty) {
      final segment = (classifications.first as Map<String, dynamic>)['segment'] as Map<String, dynamic>?;
      classification = segment?['name'] as String?;
    }

    final description = json['info'] as String? ?? json['pleaseNote'] as String?;

    return EventModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unnamed Event',
      date: dateStr,
      time: timeStr,
      imageUrl: imageUrl,
      venueName: venueName,
      city: city,
      country: country,
      lat: lat,
      lng: lng,
      priceMin: priceMin,
      priceMax: priceMax,
      url: json['url'] as String?,
      classification: classification,
      description: description,
      organizer: organizer,
      address: address,
    );
  }
}
