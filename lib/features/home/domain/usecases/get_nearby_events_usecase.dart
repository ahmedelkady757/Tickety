import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/event_entity.dart';
import '../repositories/home_repository.dart';

class GetNearbyEventsUseCase {
  final HomeRepository repository;
  GetNearbyEventsUseCase(this.repository);

  Future<Either<Failure, List<EventEntity>>> call({
    required double lat,
    required double lng,
    int radiusKm = 50,
    int page = 0,
    int size = 10,
    String sort = 'date,asc',
    String? classificationName,
    String? keyword,
  }) {
    return repository.getNearbyEvents(
      lat: lat,
      lng: lng,
      radiusKm: radiusKm,
      page: page,
      size: size,
      sort: sort,
      classificationName: classificationName,
      keyword: keyword,
    );
  }
}
