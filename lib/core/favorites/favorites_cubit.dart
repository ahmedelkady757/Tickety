import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/domain/entities/event_entity.dart';
import 'favorites_service.dart';

class FavoritesState  {
  final List<EventEntity> favorites;
  final bool isLoading;
  final String? error;
  final Set<String> favoriteIds;

  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.error,
    this.favoriteIds = const {},
  });

  FavoritesState copyWith({
    List<EventEntity>? favorites,
    bool? isLoading,
    String? error,
    Set<String>? favoriteIds,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }

}

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesService service;
  StreamSubscription? _sub;

  FavoritesCubit({required this.service}) : super(const FavoritesState()) {
    _sub = service.watchFavorites().listen((list) {
      emit(state.copyWith(
        favorites: list,
        favoriteIds: list.map((e) => e.id).toSet(),
        isLoading: false,
        error: null,
      ));
    });
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final list = await service.loadFavorites();
      emit(state.copyWith(
        favorites: list,
        favoriteIds: list.map((e) => e.id).toSet(),
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<bool> check(String id) => service.isFavorite(id);

  Future<void> add(EventEntity event) => service.add(event);

  Future<void> remove(String id) => service.remove(id);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

