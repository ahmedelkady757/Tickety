import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/event_entity.dart';
import '../repositories/events_repository.dart';

class GetEventDetailsUseCase {
  final EventsRepository repository;
  GetEventDetailsUseCase(this.repository);

  Future<Either<Failure, EventEntity>> call(String id) {
    return repository.getEventById(id);
  }
}
