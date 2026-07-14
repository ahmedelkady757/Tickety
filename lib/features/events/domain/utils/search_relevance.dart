import '../../../home/domain/entities/event_entity.dart';

List<EventEntity> rankSearchResults(List<EventEntity> events, String keyword) {
  if (keyword.trim().isEmpty) return events;

  final terms = keyword.toLowerCase().split(RegExp(r'\s+')).where((t) => t.length > 1).toList();
  if (terms.isEmpty) return events;

  int score(EventEntity e) {
    final haystack = [
      e.name,
      e.venueName,
      e.classification,
      e.city,
      e.organizer,
    ].whereType<String>().join(' ').toLowerCase();

    var s = 0;
    for (final term in terms) {
      if (e.name.toLowerCase().contains(term)) s += 10;
      if (haystack.contains(term)) s += 3;
    }
    return s;
  }

  final sorted = [...events]..sort((a, b) => score(b).compareTo(score(a)));
  return sorted;
}
