import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wya/models/place_location.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final Uint8List imageBytes;
  final PlaceLocation placeLocation;

  Place({
    required this.title,
    required this.imageBytes,
    required this.placeLocation,
  }) : id = uuid.v4();
}
