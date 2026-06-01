import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wya/models/place.dart';
import 'package:wya/models/place_location.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

Future<Database?> _getDatabase() async {
  if (kIsWeb) return null; // ← no SQLite on web
  final dbPath = await sql.getDatabasesPath();
  return sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places (id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
      );
    },
    version: 1,
  );
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    if (db == null) return; // web — state already in memory, nothing to load

    final data = await db.query('user_places');
    state = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            imagePath: row['image'] as String,
            placeLocation: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String, // ← fixed typo: 'addresss'
            ),
          ),
        )
        .toList();
  }

  Future<void> addPlace(
    String title,
    String imagePath,
    PlaceLocation placeLocation,
  ) async {
    final newPlace = Place(
      title: title,
      imagePath: imagePath,
      placeLocation: placeLocation,
    );

    final db = await _getDatabase();

    if (db != null) {
      await db.insert(
        'user_places',
        {
          'id': newPlace.id,
          'title': newPlace.title,
          'image': newPlace.imagePath,
          'lat': newPlace.placeLocation.latitude,
          'lng': newPlace.placeLocation.longitude,
          'address': newPlace.placeLocation.address,
        },
      );
    }
    // whether db exists or not, always update state
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );
