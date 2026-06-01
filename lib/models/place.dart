import 'package:uuid/uuid.dart';
import 'package:wya/models/place_location.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final String imagePath;
  final PlaceLocation placeLocation;

  Place({
    required this.title,
    required this.imagePath,
    required this.placeLocation,
    String? id,
  }) : id = id ?? uuid.v4();
}
