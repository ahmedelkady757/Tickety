import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';

abstract class HomeState  {
  const HomeState();

}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  final String cityLabel;
  final String selectedCategory;
  final List<EventEntity>? staleUpcoming;
  final List<EventEntity>? staleNearby;

  const HomeLoading({
    required this.cityLabel,
    this.selectedCategory = 'All',
    this.staleUpcoming,
    this.staleNearby,
  });

  bool get hasStaleData => staleUpcoming != null;

}

class HomeLoaded extends HomeState {
  final List<EventEntity> upcomingEvents;
  final List<EventEntity> nearbyEvents;
  final String cityLabel;
  final double? lat;
  final double? lng;
  final String selectedCategory;

  const HomeLoaded({
    required this.upcomingEvents,
    required this.nearbyEvents,
    required this.cityLabel,
    this.lat,
    this.lng,
    this.selectedCategory = 'All',
  });

}

class HomeError extends HomeState {
  final String message;
  final String cityLabel;
  final String selectedCategory;

  const HomeError(this.message, {this.cityLabel = 'New York', this.selectedCategory = 'All'});
}

class HomeLocationDenied extends HomeState {
  final bool isPermanent;
  final List<EventEntity> upcomingEvents;
  final String selectedCategory;
  final String cityLabel;

  const HomeLocationDenied({
    required this.isPermanent,
    required this.upcomingEvents,
    this.selectedCategory = 'All',
    this.cityLabel = 'New York',
  });

}
