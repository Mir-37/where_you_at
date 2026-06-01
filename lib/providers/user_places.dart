import 'package:flutter_riverpod/legacy.dart';
import 'package:wya/models/place.dart';
import 'package:wya/models/place_location.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(
    String title,
    String imagePath,
    PlaceLocation placeLocation,
  ) {
    final newPlace = Place(
      title: title,
      imagePath: imagePath,
      placeLocation: placeLocation,
    );
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );
