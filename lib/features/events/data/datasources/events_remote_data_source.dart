import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../home/data/models/event_model.dart';
import '../../domain/entities/paginated_events.dart';

abstract class EventsRemoteDataSource {
  Future<PaginatedEvents> searchEvents({
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

  Future<PaginatedEvents> getAllEvents({
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

  Future<EventModel> getEventById(String id);
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final Dio dio;

  EventsRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaginatedEvents> searchEvents({
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
      final hasKeyword = keyword != null && keyword.isNotEmpty;
      final params = _buildParams(
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
        sort: hasKeyword ? 'relevance,desc' : 'date,asc',
      );
      final response = await dio.get('/events.json', queryParameters: params);
      return _parsePaginated(response.data, page);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to search events');
    }
  }

  @override
  Future<PaginatedEvents> getAllEvents({
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
      final params = _buildParams(
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
      final response = await dio.get('/events.json', queryParameters: params);
      return _parsePaginated(response.data, page);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch events');
    }
  }

  @override
  Future<EventModel> getEventById(String id) async {
    try {
      final response = await dio.get('/events/$id.json');
      final data = response.data as Map<String, dynamic>;
      return EventModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ServerException('Event not found', statusCode: 404);
      }
      throw ServerException(e.message ?? 'Failed to fetch event details');
    }
  }

  Map<String, dynamic> _buildParams({
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
    String sort = 'date,asc',
  }) {
    final params = <String, dynamic>{
      'sort': sort,
      'size': size,
      'page': page,
    };
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    if (classificationName != null && classificationName.isNotEmpty) {
      params['classificationName'] = classificationName;
    }
    if (city != null && city.isNotEmpty) params['city'] = city;
    if (countryCode != null && countryCode.isNotEmpty) {
      params['countryCode'] = countryCode;
    }
    if (lat != null && lng != null) {
      params['latlong'] = '$lat,$lng';
      params['radius'] = radiusKm;
      params['unit'] = 'km';
    }
    if (startDateTime != null) params['startDateTime'] = startDateTime;
    if (endDateTime != null) params['endDateTime'] = endDateTime;
    return params;
  }

  PaginatedEvents _parsePaginated(dynamic data, int page) {
    try {
      final embedded = data['_embedded'] as Map<String, dynamic>?;
      final eventsList = embedded?['events'] as List<dynamic>?;
      final events = eventsList == null
          ? <EventModel>[]
          : eventsList
              .cast<Map<String, dynamic>>()
              .map(EventModel.fromJson)
              .toList();

      final pageInfo = data['page'] as Map<String, dynamic>?;
      final totalPages = pageInfo?['totalPages'] as int? ?? 1;

      return PaginatedEvents(
        events: events,
        totalPages: totalPages,
        currentPage: page,
      );
    } catch (e) {
      throw ServerException('Failed to parse events: $e');
    }
  }
}
