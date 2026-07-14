import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/category_mapper.dart';
import '../../../home/domain/entities/event_entity.dart';
import '../../../home/domain/usecases/get_nearby_events_usecase.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final GetNearbyEventsUseCase getNearbyEventsUseCase;
  final LocationService locationService;

  MapCubit({
    required this.getNearbyEventsUseCase,
    required this.locationService,
  }) : super(const MapInitial());

  /// Ticketmaster 1.3 Nearby Events (geo):
  /// latlong + radius=20 + unit=km + sort=distance,asc
  Future<void> init({EventEntity? focusEvent}) async {
    emit(const MapLoading());

    double lat = focusEvent?.lat ?? AppConstants.defaultLat;
    double lng = focusEvent?.lng ?? AppConstants.defaultLng;

    if (focusEvent?.lat == null) {
      try {
        final locationData = await locationService.getCurrentLocation();
        final loc = locationData.result;
        if (loc != null) {
          lat = loc.lat;
          lng = loc.lng;
        }
      } catch (_) {}
    }

    await _fetchEvents(lat: lat, lng: lng, focusEvent: focusEvent);
  }

  Future<void> filterByCategory(String? category) async {
    final current = state;
    if (current is! MapLoaded) return;

    final label = category ?? 'All';
    final apiCategory =
        CategoryMapper.useKeywordInsteadOfClassification(label) ? null : CategoryMapper.toApi(label);
    final keyword = CategoryMapper.keywordFor(label);

    emit(current.copyWith(selectedCategory: category, clearCategory: category == null));

    await _fetchEvents(
      lat: current.lat,
      lng: current.lng,
      classificationName: apiCategory,
      keyword: keyword,
      selectedCategory: category,
      focusEvent: current.focusEvent,
    );
  }

  Future<void> _fetchEvents({
    required double lat,
    required double lng,
    String? classificationName,
    String? keyword,
    String? selectedCategory,
    EventEntity? focusEvent,
  }) async {
    final result = await getNearbyEventsUseCase(
      lat: lat,
      lng: lng,
      radiusKm: 20,
      size: 20,
      sort: 'distance,asc',
      classificationName: classificationName,
      keyword: keyword,
    );

    result.fold(
      (failure) => emit(MapError(failure.message)),
      (events) => emit(MapLoaded(
        events: events,
        lat: lat,
        lng: lng,
        selectedCategory: selectedCategory,
        focusEvent: focusEvent,
      )),
    );
  }
}
