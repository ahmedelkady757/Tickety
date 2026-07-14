import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/category_mapper.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/usecases/get_nearby_events_usecase.dart';
import '../../domain/usecases/get_upcoming_events_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetUpcomingEventsUseCase getUpcomingEventsUseCase;
  final GetNearbyEventsUseCase getNearbyEventsUseCase;
  final LocationService locationService;

  double _lat = AppConstants.defaultLat;
  double _lng = AppConstants.defaultLng;
  String _cityLabel = AppConstants.defaultCity;
  bool _locationGranted = false;
  LocationStatus _locStatus = LocationStatus.unavailable;
  bool _locationResolved = false;

  HomeCubit({
    required this.getUpcomingEventsUseCase,
    required this.getNearbyEventsUseCase,
    required this.locationService,
  }) : super(const HomeInitial());

  Future<void> init() async {
    emit(HomeLoading(cityLabel: _cityLabel));
    await _resolveLocationOnce();
    await _loadEvents(category: 'All');
  }

  Future<void> filterByCategory(String category) async {
    final prev = state;
    emit(HomeLoading(
      cityLabel: _cityLabel,
      selectedCategory: category,
      staleUpcoming: prev is HomeLoaded ? prev.upcomingEvents : null,
      staleNearby: prev is HomeLoaded ? prev.nearbyEvents : null,
    ));
    await _loadEvents(category: category);
  }

  Future<void> _resolveLocationOnce() async {
    if (_locationResolved) return;

    try {
      final locationData = await locationService.getCurrentLocation();
      _locStatus = locationData.status;
      final locResult = locationData.result;

      if (locResult != null) {
        _lat = locResult.lat;
        _lng = locResult.lng;
        _cityLabel = locResult.cityLabel;
        _locationGranted = true;
      }
    } catch (_) {}

    _locationResolved = true;
  }

  Future<void> _loadEvents({required String category}) async {
    final apiCategory =
        CategoryMapper.useKeywordInsteadOfClassification(category) ? null : CategoryMapper.toApi(category);
    final keyword = CategoryMapper.keywordFor(category);

    try {
      final upcomingEvents = await _fetchUpcoming(
        classificationName: apiCategory,
        keyword: keyword,
      );

      if (state is HomeError) return;

      final isExplicitDenial =
          _locStatus == LocationStatus.denied || _locStatus == LocationStatus.deniedForever;

      if (!_locationGranted && isExplicitDenial) {
        emit(HomeLocationDenied(
          isPermanent: _locStatus == LocationStatus.deniedForever,
          upcomingEvents: upcomingEvents,
          selectedCategory: category,
          cityLabel: _cityLabel,
        ));
        return;
      }

      final nearbyEvents = await _fetchNearby(
        classificationName: apiCategory,
        keyword: keyword,
      );

      _updateCityLabelFromEvents(upcomingEvents, nearbyEvents);

      emit(HomeLoaded(
        upcomingEvents: upcomingEvents,
        nearbyEvents: nearbyEvents,
        cityLabel: _cityLabel,
        lat: _lat,
        lng: _lng,
        selectedCategory: category,
      ));
    } catch (_) {
      emit(HomeError(
        'Failed to load events. Please try again.',
        cityLabel: _cityLabel,
        selectedCategory: category,
      ));
    }
  }

  Future<List<EventEntity>> _fetchUpcoming({
    String? classificationName,
    String? keyword,
  }) async {
    final result = await getUpcomingEventsUseCase(
      lat: _lat,
      lng: _lng,
      classificationName: classificationName,
      keyword: keyword,
      size: 10,
    );

    return result.fold(
      (failure) {
        emit(HomeError(failure.message, cityLabel: _cityLabel));
        return <EventEntity>[];
      },
      (events) => events,
    );
  }

  Future<List<EventEntity>> _fetchNearby({
    String? classificationName,
    String? keyword,
  }) async {
    if (!_locationGranted && _locStatus == LocationStatus.deniedForever) {
      return [];
    }

    final result = await getNearbyEventsUseCase(
      lat: _lat,
      lng: _lng,
      classificationName: classificationName,
      keyword: keyword,
      size: 10,
    );

    return result.fold((_) => <EventEntity>[], (list) => list);
  }

  void _updateCityLabelFromEvents(
    List<EventEntity> upcoming,
    List<EventEntity> nearby,
  ) {
    if (_hasDisplayableCity(_cityLabel)) return;

    final resolved = _resolveCityFromEvents([...upcoming, ...nearby]);
    if (resolved != null) _cityLabel = resolved;
  }

  bool _hasDisplayableCity(String label) {
    if (label.isEmpty) return false;
    if (label.contains('°')) return false;
    if (label == 'Current Location') return false;
    return true;
  }

  String? _resolveCityFromEvents(List<EventEntity> events) {
    for (final e in events) {
      if (e.city != null) {
        return e.country != null ? '${e.city}, ${e.country}' : e.city;
      }
    }
    return null;
  }
}
