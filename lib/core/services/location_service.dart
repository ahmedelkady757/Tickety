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
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return (result: null, status: LocationStatus.serviceDisabled);
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return (result: null, status: LocationStatus.denied);
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return (result: null, status: LocationStatus.deniedForever);
      }

      final position = await _resolvePosition();
      if (position == null) {
        return (result: null, status: LocationStatus.unavailable);
      }

      final cityLabel = await _resolveCityName(position.latitude, position.longitude);

      return (
        result: LocationResult(
          lat: position.latitude,
          lng: position.longitude,
          cityLabel: cityLabel,
        ),
        status: LocationStatus.granted,
      );
    } catch (_) {
      return (result: null, status: LocationStatus.unavailable);
    }
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
