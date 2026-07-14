import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<EventEntity>>> getUpcomingEvents({
    double? lat,
    double? lng,
    String? keyword,
    String? classificationName,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final events = await remoteDataSource.getUpcomingEvents(
        lat: lat,
        lng: lng,
        keyword: keyword,
        classificationName: classificationName,
        page: page,
        size: size,
      );
      return Right(events);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getNearbyEvents({
    required double lat,
    required double lng,
    int radiusKm = 50,
    int page = 0,
    int size = 10,
    String sort = 'date,asc',
    String? classificationName,
    String? keyword,
  }) async {
    try {
      final events = await remoteDataSource.getNearbyEvents(
        lat: lat,
        lng: lng,
        radiusKm: radiusKm,
        page: page,
        size: size,
        sort: sort,
        classificationName: classificationName,
        keyword: keyword,
      );
      return Right(events);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
