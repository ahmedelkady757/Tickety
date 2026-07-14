import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/home/domain/entities/event_entity.dart';
import 'favorite_event_record.dart';
import 'favorites_dao.dart';

class FavoritesService {
  final FavoritesDao dao;
  final FirebaseAuth auth;
  final _controller = StreamController<List<EventEntity>>.broadcast();

  FavoritesService({required this.dao, required this.auth});

  Stream<List<EventEntity>> watchFavorites() => _controller.stream;

  Future<List<EventEntity>> loadFavorites() async {
    final records = await dao.getAll(_userId);
    final list = records.map((r) => r.toEntity()).toList();
    _controller.add(list);
    return list;
  }

  Future<bool> isFavorite(String id) => dao.exists(_userId, id);

  Future<void> add(EventEntity event) async {
    await dao.upsert(FavoriteEventRecord.fromEntity(event, _userId));
    await loadFavorites();
  }

  Future<void> remove(String id) async {
    await dao.delete(_userId, id);
    await loadFavorites();
  }

  String get _userId => auth.currentUser?.uid ?? 'guest';
}

