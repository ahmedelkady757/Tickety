import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/paginated_events.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_remote_data_source.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource remoteDataSource;

  EventsRepositoryImpl({required this.remoteDataSource});

  @override
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
  }) async {
    try {
      final result = await remoteDataSource.searchEvents(
        keyword: keyword,
        classificationName: classificationName,
        city: city,
        lat: lat,
        lng: lng,
        radiusKm: radiusKm,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        countryCode: countryCode,
        page: page,
        size: size,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final result = await remoteDataSource.getAllEvents(
        city: city,
        lat: lat,
        lng: lng,
        classificationName: classificationName,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        page: page,
        size: size,
        sort: sort,
        radiusKm: radiusKm,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> getEventById(String id) async {
    try {
      final event = await remoteDataSource.getEventById(id);
      return Right(event);
    } on ServerException catch (e) {
      if (e.statusCode == 404) return const Left(NotFoundFailure('Event not found'));
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
