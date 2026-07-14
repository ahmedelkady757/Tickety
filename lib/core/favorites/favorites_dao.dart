import 'package:sqflite/sqflite.dart';
import '../db/app_database.dart';
import 'favorite_event_record.dart';

class FavoritesDao {
  final AppDatabase db;
  FavoritesDao({required this.db});

  Future<bool> exists(String userId, String id) async {
    final database = await db.database;
    final res = await database.query(
      'favorites',
      columns: ['id'],
      where: 'userId = ? AND id = ?',
      whereArgs: [userId, id],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  Future<void> upsert(FavoriteEventRecord record) async {
    final database = await db.database;
    await database.insert(
      'favorites',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String userId, String id) async {
    final database = await db.database;
    await database.delete(
      'favorites',
      where: 'userId = ? AND id = ?',
      whereArgs: [userId, id],
    );
  }

  Future<List<FavoriteEventRecord>> getAll(String userId) async {
    final database = await db.database;
    final rows = await database.query(
      'favorites',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    return rows.map(FavoriteEventRecord.fromMap).toList();
  }
}

