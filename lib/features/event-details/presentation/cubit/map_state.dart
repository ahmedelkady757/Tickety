import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../home/domain/entities/event_entity.dart';

abstract class MapState extends Equatable {
  const MapState();
  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {
  const MapInitial();
}

class MapLoading extends MapState {
  const MapLoading();
}

class MapLoaded extends MapState {
  final List<EventEntity> events;
  final double lat;
  final double lng;
  final String? selectedCategory;
  final EventEntity? focusEvent;

  const MapLoaded({
    required this.events,
    required this.lat,
    required this.lng,
    this.selectedCategory,
    this.focusEvent,
  });

  List<EventEntity> get mappableEvents =>
      events.where((e) => e.lat != null && e.lng != null).toList();

  CameraPosition get cameraPosition {
    if (focusEvent?.lat != null && focusEvent?.lng != null) {
      return CameraPosition(
        target: LatLng(focusEvent!.lat!, focusEvent!.lng!),
        zoom: 14,
      );
    }
    return CameraPosition(target: LatLng(lat, lng), zoom: 12);
  }

  MapLoaded copyWith({
    List<EventEntity>? events,
    double? lat,
    double? lng,
    String? selectedCategory,
    EventEntity? focusEvent,
    bool clearCategory = false,
  }) {
    return MapLoaded(
      events: events ?? this.events,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      focusEvent: focusEvent ?? this.focusEvent,
    );
  }

  @override
  List<Object?> get props => [events, lat, lng, selectedCategory, focusEvent];
}

class MapError extends MapState {
  final String message;
  const MapError(this.message);
  @override
  List<Object?> get props => [message];
}
