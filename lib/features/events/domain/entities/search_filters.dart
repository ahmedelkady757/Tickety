import 'package:equatable/equatable.dart';

class SearchFilters extends Equatable {
  final String? category;
  final String? city;
  final DateFilter dateFilter;

  const SearchFilters({
    this.category,
    this.city,
    this.dateFilter = DateFilter.any,
  });

  const SearchFilters.empty() : this();

  SearchFilters copyWith({
    String? category,
    String? city,
    DateFilter? dateFilter,
    bool clearCategory = false,
    bool clearCity = false,
  }) {
    return SearchFilters(
      category: clearCategory ? null : (category ?? this.category),
      city: clearCity ? null : (city ?? this.city),
      dateFilter: dateFilter ?? this.dateFilter,
    );
  }

  bool get hasActiveFilters =>
      (category != null && category != 'All') ||
      (city != null && city!.isNotEmpty) ||
      dateFilter != DateFilter.any;

  ({String? start, String? end}) get dateRange => dateFilter.toApiRange();

  @override
  List<Object?> get props => [category, city, dateFilter];
}

enum DateFilter { any, today, thisWeek, thisMonth }

extension DateFilterExt on DateFilter {
  String get label => switch (this) {
        DateFilter.any => 'Any time',
        DateFilter.today => 'Today',
        DateFilter.thisWeek => 'This week',
        DateFilter.thisMonth => 'This month',
      };

  ({String? start, String? end}) toApiRange() {
    final now = DateTime.now().toUtc();
    String fmt(DateTime d) =>
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}T'
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}Z';

    return switch (this) {
      DateFilter.any => (start: null, end: null),
      DateFilter.today => (
          start: fmt(DateTime.utc(now.year, now.month, now.day)),
          end: fmt(DateTime.utc(now.year, now.month, now.day, 23, 59, 59)),
        ),
      DateFilter.thisWeek => (
          start: fmt(now),
          end: fmt(now.add(const Duration(days: 7))),
        ),
      DateFilter.thisMonth => (
          start: fmt(now),
          end: fmt(DateTime.utc(now.year, now.month + 1, 0, 23, 59, 59)),
        ),
    };
  }
}
