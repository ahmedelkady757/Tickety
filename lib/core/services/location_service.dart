import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationResult {
  final double lat;
  final double lng;
  final String cityLabel; // e.g. "New York, US"

  const LocationResult({
    required this.lat,
    required this.lng,
    required this.cityLabel,
  });
}

enum LocationStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
  unavailable,
}

class LocationService {
  Future<({LocationResult? result, LocationStatus status})> getCurrentLocation() async {
    return (
      result: const LocationResult(
        lat: 40.7128,
        lng: -74.0060,
        cityLabel: 'New York, US',
      ),
      status: LocationStatus.granted,
    );
  }

  Future<Position?> _resolvePosition() async {
    final lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) return lastKnown;

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } on TimeoutException {
      return Geolocator.getLastKnownPosition();
    }
  }

  Future<String> _resolveCityName(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ??
            place.subAdministrativeArea ??
            place.administrativeArea;
        final country = place.isoCountryCode;
        if (city != null && city.isNotEmpty) {
          return country != null ? '$city, $country' : city;
        }
      }
    } catch (_) {}

    return 'Current Location';
  }

  Future<void> openAppSettings() => Geolocator.openAppSettings();

  Future<void> openLocationSettings() => Geolocator.openLocationSettings();
}
