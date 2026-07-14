enum SeeAllType { upcoming, nearby }

class SeeAllConfig {
  final SeeAllType type;
  final double? lat;
  final double? lng;
  final String? category;
  final String? city;

  const SeeAllConfig({
    required this.type,
    this.lat,
    this.lng,
    this.category,
    this.city,
  });

  factory SeeAllConfig.fromQuery(Map<String, String> query) {
    final type = query['type'] == 'nearby' ? SeeAllType.nearby : SeeAllType.upcoming;
    return SeeAllConfig(
      type: type,
      lat: double.tryParse(query['lat'] ?? ''),
      lng: double.tryParse(query['lng'] ?? ''),
      category: query['category'],
      city: query['city'],
    );
  }

  String get title => type == SeeAllType.nearby ? 'Nearby Events' : 'Upcoming Events';
}
