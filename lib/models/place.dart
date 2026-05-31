import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  final String id;
  final String title;
  final Uint8List imageBytes;

  Place({required this.title, required this.imageBytes}) : id = uuid.v4();
}
