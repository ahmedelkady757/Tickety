import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/category_mapper.dart';
import '../../domain/entities/search_filters.dart';
import '../../domain/entities/see_all_config.dart';
import '../../domain/utils/search_relevance.dart';
import '../../domain/usecases/get_all_events_usecase.dart';
import '../../domain/usecases/get_event_details_usecase.dart';
import '../../domain/usecases/search_events_usecase.dart';
import 'events_state.dart';

enum _ListMode { search, upcoming, nearby }

class EventsCubit extends Cubit<EventsState> {
  final SearchEventsUseCase searchEventsUseCase;
  final GetEventDetailsUseCase getEventDetailsUseCase;
  final GetAllEventsUseCase getAllEventsUseCase;

  _ListMode _mode = _ListMode.search;
  SearchFilters _filters = const SearchFilters.empty();
  SeeAllConfig? _seeAllConfig;
  String _lastKeyword = '';

  EventsCubit({
    required this.searchEventsUseCase,
    required this.getEventDetailsUseCase,
    required this.getAllEventsUseCase,
  }) : super(const EventsInitial());

  SearchFilters get activeFilters => _filters;

  /// Load default events when search opens (Postman 3.1 — upcoming by city).
  Future<void> loadDefaultEvents() async {
    _mode = _ListMode.search;
    _lastKeyword = '';
    if (!isClosed) emit(const EventsLoading());

    final result = await getAllEventsUseCase(GetAllEventsParams(
      city: _filters.city ?? AppConstants.defaultCity,
      classificationName: CategoryMapper.toApi(_filters.category),
      startDateTime: _filters.dateRange.start,
      endDateTime: _filters.dateRange.end,
      size: AppConstants.defaultPageSize,
    ));

    _emitPaginated(result);
  }

  Future<void> search(String keyword, {int page = 0}) async {
    _mode = _ListMode.search;
    _lastKeyword = keyword.trim();

    if (_lastKeyword.isEmpty) {
      await loadDefaultEvents();
      return;
    }

    if (!isClosed) emit(const EventsLoading());

    final result = await searchEventsUseCase(SearchEventsParams(
      keyword: _lastKeyword,
      classificationName: CategoryMapper.toApi(_filters.category),
      city: _filters.city,
      countryCode: _filters.city == null ? AppConstants.defaultCountryCode : null,
      startDateTime: _filters.dateRange.start,
      endDateTime: _filters.dateRange.end,
      page: page,
      size: AppConstants.defaultPageSize,
    ));

    _emitPaginated(result, keyword: _lastKeyword);
  }

  Future<void> applyFilters(SearchFilters filters) async {
    _filters = filters;
    if (_lastKeyword.isEmpty) {
      await loadDefaultEvents();
    } else {
      await search(_lastKeyword);
    }
  }

  Future<void> loadSeeAll(SeeAllConfig config, {int page = 0, bool append = false}) async {
    _seeAllConfig = config;
    _mode = config.type == SeeAllType.nearby ? _ListMode.nearby : _ListMode.upcoming;

    if (!append) emit(const EventsLoading());

    final apiCategory = CategoryMapper.toApi(config.category);
    final lat = config.lat;
    final lng = config.lng;

    final result = await getAllEventsUseCase(GetAllEventsParams(
      city: config.type == SeeAllType.upcoming && lat == null
          ? (config.city ?? AppConstants.defaultCity)
          : null,
      lat: lat,
      lng: lng,
      classificationName: apiCategory,
      page: page,
      size: AppConstants.defaultPageSize,
      sort: config.type == SeeAllType.nearby ? 'distance,asc' : 'date,asc',
      radiusKm: config.type == SeeAllType.nearby ? 50 : 50,
    ));

    result.fold(
      (failure) => emit(EventsError(failure.message)),
      (data) {
        if (data.events.isEmpty && !append) {
          emit(const EventsEmpty());
          return;
        }

        final current = state;
        var events = data.events;
        if (append && current is EventsLoaded) {
          events = [...current.events, ...data.events];
        }

        emit(EventsLoaded(
          events: events,
          totalPages: data.totalPages,
          currentPage: data.currentPage,
        ));
      },
    );
  }

  Future<void> loadMoreSeeAll() async {
    final config = _seeAllConfig;
    final current = state;
    if (config == null || current is! EventsLoaded) return;
    if (current.currentPage >= current.totalPages - 1) return;

    await loadSeeAll(config, page: current.currentPage + 1, append: true);
  }

  Future<void> loadEventDetails(String id) async {
    emit(const EventDetailsLoading());
    final result = await getEventDetailsUseCase(id);
    result.fold(
      (failure) => emit(EventDetailsError(failure.message)),
      (event) => emit(EventDetailsLoaded(event)),
    );
  }

  void _emitPaginated(dynamic result, {String? keyword}) {
    result.fold(
      (failure) => emit(EventsError(failure.message)),
      (data) {
        if (data.events.isEmpty) {
          emit(const EventsEmpty());
        } else {
          final events = keyword != null
              ? rankSearchResults(data.events, keyword)
              : data.events;
          emit(EventsLoaded(
            events: events,
            totalPages: data.totalPages,
            currentPage: data.currentPage,
          ));
        }
      },
    );
  }

  void reset() => emit(const EventsInitial());
}
