import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
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

  const EventEntity({
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
  });

  String get shortDate {
    if (date == null) return 'TBD';
    try {
      final parts = date!.split('-');
      final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${parts[2]} ${months[int.parse(parts[1])]}';
    } catch (_) {
      return date!;
    }
  }

  String get day {
    if (date == null) return '--';
    try { return date!.split('-')[2]; } catch (_) { return '--'; }
  }

  String get month {
    if (date == null) return '---';
    try {
      final idx = int.parse(date!.split('-')[1]);
      const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return months[idx];
    } catch (_) { return '---'; }
  }

  String get locationLabel {
    if (venueName != null && city != null) return '$venueName, $city';
    if (city != null) return city!;
    if (venueName != null) return venueName!;
    return 'Location TBD';
  }

  String get formattedDate {
    if (date == null) return 'Date TBD';
    try {
      final parts = date!.split('-');
      const months = ['', 'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'];
      final month = months[int.parse(parts[1])];
      return '${parts[2]} $month, ${parts[0]}';
    } catch (_) {
      return date!;
    }
  }

  String get formattedTime {
    if (time == null) return '';
    try {
      final parts = time!.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$h:$minute $period';
    } catch (_) {
      return time!;
    }
  }

  String get priceLabel {
    if (priceMin != null) return 'BUY TICKET \$${priceMin!.toStringAsFixed(0)}';
    return 'BUY TICKET';
  }

  @override
  List<Object?> get props => [id, name, date, time, imageUrl, venueName, city, country, lat, lng, priceMin, priceMax, url, classification, description, organizer, address];
}
