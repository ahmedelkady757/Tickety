import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AppDatabase {
  static const _dbName = 'tickety.db';
  static const _dbVersion = 2;

  Database? _db;

  Future<Database> get database async {
    final existing = _db;
    if (existing != null) return existing;

    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    final db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, _) async {
        await _createFavoritesTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Migrate to per-user favorites with composite primary key.
          await db.execute('''
CREATE TABLE favorites_new (
  userId TEXT NOT NULL,
  id TEXT NOT NULL,
  name TEXT NOT NULL,
  date TEXT,
  time TEXT,
  imageUrl TEXT,
  venueName TEXT,
  city TEXT,
  country TEXT,
  lat REAL,
  lng REAL,
  priceMin REAL,
  priceMax REAL,
  url TEXT,
  classification TEXT,
  description TEXT,
  organizer TEXT,
  address TEXT,
  createdAt INTEGER NOT NULL,
  PRIMARY KEY (userId, id)
)
''');
          await db.execute('''
INSERT INTO favorites_new (
  userId, id, name, date, time, imageUrl, venueName, city, country, lat, lng,
  priceMin, priceMax, url, classification, description, organizer, address, createdAt
)
SELECT
  'legacy', id, name, date, time, imageUrl, venueName, city, country, lat, lng,
  priceMin, priceMax, url, classification, description, organizer, address, createdAt
FROM favorites
''');
          await db.execute('DROP TABLE favorites');
          await db.execute('ALTER TABLE favorites_new RENAME TO favorites');
        }
      },
    );

    _db = db;
    return db;
  }

  Future<void> _createFavoritesTable(Database db) async {
    await db.execute('''
CREATE TABLE favorites (
  userId TEXT NOT NULL,
  id TEXT NOT NULL,
  name TEXT NOT NULL,
  date TEXT,
  time TEXT,
  imageUrl TEXT,
  venueName TEXT,
  city TEXT,
  country TEXT,
  lat REAL,
  lng REAL,
  priceMin REAL,
  priceMax REAL,
  url TEXT,
  classification TEXT,
  description TEXT,
  organizer TEXT,
  address TEXT,
  createdAt INTEGER NOT NULL,
  PRIMARY KEY (userId, id)
)
''');
  }
}

