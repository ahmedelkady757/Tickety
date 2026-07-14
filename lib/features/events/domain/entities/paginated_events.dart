import 'event_entity.dart';

class PaginatedEvents {
  final List<EventEntity> events;
  final int totalPages;
  final int currentPage;

  const PaginatedEvents({
    required this.events,
    required this.totalPages,
    required this.currentPage,
  });
}
