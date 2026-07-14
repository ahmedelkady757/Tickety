import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';

abstract class EventsState  {
  const EventsState();
}

class EventsInitial extends EventsState {
  const EventsInitial();
}

class EventsLoading extends EventsState {
  final bool isLoadMore;
  const EventsLoading({this.isLoadMore = false});
  @override
  List<Object?> get props => [isLoadMore];
}

class EventsLoaded extends EventsState {
  final List<EventEntity> events;
  final int totalPages;
  final int currentPage;

  const EventsLoaded({
    required this.events,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [events, totalPages, currentPage];
}

class EventsEmpty extends EventsState {
  const EventsEmpty();
}

class EventsError extends EventsState {
  final String message;
  const EventsError(this.message);
  @override
  List<Object?> get props => [message];
}

class EventDetailsLoading extends EventsState {
  const EventDetailsLoading();
}

class EventDetailsLoaded extends EventsState {
  final EventEntity event;
  const EventDetailsLoaded(this.event);
  @override
  List<Object?> get props => [event];
}

class EventDetailsError extends EventsState {
  final String message;
  const EventDetailsError(this.message);
  @override
  List<Object?> get props => [message];
}
