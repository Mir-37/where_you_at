import 'dart:typed_data';

import 'package:flutter_riverpod/legacy.dart';
import 'package:wya/models/place.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(String title, Uint8List imageBytes) {
    final newPlace = Place(title: title, imageBytes: imageBytes);
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );
