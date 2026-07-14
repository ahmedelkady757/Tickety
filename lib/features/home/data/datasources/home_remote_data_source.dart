import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/event_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<EventModel>> getUpcomingEvents({
    double? lat,
    double? lng,
    String? keyword,
    String? classificationName,
    int page = 0,
    int size = 10,
  });

  Future<List<EventModel>> getNearbyEvents({
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

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<EventModel>> getUpcomingEvents({
    double? lat,
    double? lng,
    String? keyword,
    String? classificationName,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final params = <String, dynamic>{
        'sort': 'date,asc',
        'size': size,
        'page': page,
      };
      if (lat != null && lng != null) {
        params['latlong'] = '$lat,$lng';
        params['radius'] = 100;
        params['unit'] = 'km';
      }
      if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
      if (classificationName != null && classificationName.isNotEmpty) {
        params['classificationName'] = classificationName;
      }

      final response = await dio.get('/events.json', queryParameters: params);
      return _parseEvents(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch upcoming events');
    }
  }

  @override
  Future<List<EventModel>> getNearbyEvents({
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
      final params = <String, dynamic>{
        'latlong': '$lat,$lng',
        'radius': radiusKm,
        'unit': 'km',
        'sort': sort,
        'size': size,
        'page': page,
      };
      if (classificationName != null && classificationName.isNotEmpty) {
        params['classificationName'] = classificationName;
      }
      if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;

      final response = await dio.get('/events.json', queryParameters: params);
      return _parseEvents(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch nearby events');
    }
  }

  List<EventModel> _parseEvents(dynamic data) {
    try {
      final embedded = data['_embedded'] as Map<String, dynamic>?;
      final events = embedded?['events'] as List<dynamic>?;
      if (events == null) return [];
      return events
          .cast<Map<String, dynamic>>()
          .map(EventModel.fromJson)
          .toList();
    } catch (e) {
      throw ServerException('Failed to parse events: $e');
    }
  }
}
