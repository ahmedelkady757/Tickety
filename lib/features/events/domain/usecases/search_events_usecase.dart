import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/paginated_events.dart';
import '../repositories/events_repository.dart';

class SearchEventsParams {
  final String? keyword;
  final String? classificationName;
  final String? city;
  final double? lat;
  final double? lng;
  final int radiusKm;
  final String? startDateTime;
  final String? endDateTime;
  final String? countryCode;
  final int page;
  final int size;

  const SearchEventsParams({
    this.keyword,
    this.classificationName,
    this.city,
    this.lat,
    this.lng,
    this.radiusKm = 50,
    this.startDateTime,
    this.endDateTime,
    this.countryCode,
    this.page = 0,
    this.size = 20,
  });
}

class SearchEventsUseCase {
  final EventsRepository repository;
  SearchEventsUseCase(this.repository);

  Future<Either<Failure, PaginatedEvents>> call(SearchEventsParams params) {
    return repository.searchEvents(
      keyword: params.keyword,
      classificationName: params.classificationName,
      city: params.city,
      lat: params.lat,
      lng: params.lng,
      radiusKm: params.radiusKm,
      startDateTime: params.startDateTime,
      endDateTime: params.endDateTime,
      countryCode: params.countryCode,
      page: params.page,
      size: params.size,
    );
  }
}
