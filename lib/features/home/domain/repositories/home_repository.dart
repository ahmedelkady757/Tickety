import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/event_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<EventEntity>>> getUpcomingEvents({
    double? lat,
    double? lng,
    String? keyword,
    String? classificationName,
    int page = 0,
    int size = 10,
  });

  Future<Either<Failure, List<EventEntity>>> getNearbyEvents({
    required double lat,
    required double lng,
    int radiusKm = 50,
    int page = 0,
    int size = 10,
    String sort = 'date,asc',
    String? classificationName,
    String? keyword,
  });
}
