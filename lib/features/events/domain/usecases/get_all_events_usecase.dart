import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/paginated_events.dart';
import '../repositories/events_repository.dart';

class GetAllEventsParams {
  final String? city;
  final double? lat;
  final double? lng;
  final String? classificationName;
  final String? startDateTime;
  final String? endDateTime;
  final int page;
  final int size;
  final String sort;
  final int radiusKm;

  const GetAllEventsParams({
    this.city,
    this.lat,
    this.lng,
    this.classificationName,
    this.startDateTime,
    this.endDateTime,
    this.page = 0,
    this.size = 20,
    this.sort = 'date,asc',
    this.radiusKm = 50,
  });
}

class GetAllEventsUseCase {
  final EventsRepository repository;
  GetAllEventsUseCase(this.repository);

  Future<Either<Failure, PaginatedEvents>> call(GetAllEventsParams params) {
    return repository.getAllEvents(
      city: params.city,
      lat: params.lat,
      lng: params.lng,
      classificationName: params.classificationName,
      startDateTime: params.startDateTime,
      endDateTime: params.endDateTime,
      page: params.page,
      size: params.size,
      sort: params.sort,
      radiusKm: params.radiusKm,
    );
  }
}
