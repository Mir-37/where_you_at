import 'dart:convert' show base64Encode, base64Decode;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageStorage {
  /// Saves bytes to app's private directory, returns the saved path.
  /// No permissions needed — this is app-sandboxed storage.
  static Future<String> save(String fileName, Uint8List bytes) async {
    if (kIsWeb) {
      // Web has no file system — encode bytes as a data URL string
      // This can be stored in SQLite as-is and loaded back later
      final base64 = base64Encode(bytes);
      return 'data:image/jpeg;base64,$base64';
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Loads an image back from a saved path.
  static ImageProvider load(String path) {
    if (kIsWeb || path.startsWith('data:')) {
      // Extract the base64 part after the comma
      final base64Str = path.split(',').last;
      return MemoryImage(base64Decode(base64Str));
    }
    return FileImage(File(path));
  }

  /// Deletes an image (e.g. when user removes a place).
  static Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}
