import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/event_entity.dart';
import '../repositories/home_repository.dart';

class GetUpcomingEventsUseCase {
  final HomeRepository repository;
  GetUpcomingEventsUseCase(this.repository);

  Future<Either<Failure, List<EventEntity>>> call({
    double? lat,
    double? lng,
    String? keyword,
    String? classificationName,
    int page = 0,
    int size = 10,
  }) {
    return repository.getUpcomingEvents(
      lat: lat,
      lng: lng,
      keyword: keyword,
      classificationName: classificationName,
      page: page,
      size: size,
    );
  }
}
