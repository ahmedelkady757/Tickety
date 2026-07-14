import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/event_entity.dart';
import '../entities/paginated_events.dart';

abstract class EventsRepository {
  Future<Either<Failure, PaginatedEvents>> searchEvents({
    String? keyword,
    String? classificationName,
    String? city,
    double? lat,
    double? lng,
    int radiusKm = 50,
    String? startDateTime,
    String? endDateTime,
    String? countryCode,
    int page = 0,
    int size = 20,
  });

  Future<Either<Failure, PaginatedEvents>> getAllEvents({
    String? city,
    double? lat,
    double? lng,
    String? classificationName,
    String? startDateTime,
    String? endDateTime,
    int page = 0,
    int size = 20,
    String sort = 'date,asc',
    int radiusKm = 50,
  });

  Future<Either<Failure, EventEntity>> getEventById(String id);
}
