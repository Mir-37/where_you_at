import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wya/models/place_location.dart';
import 'package:wya/providers/user_places.dart';
import 'package:wya/services/image_storage.dart';
import 'package:wya/widgets/image_input.dart';
import 'package:wya/widgets/location_input.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => AddPlaceScreenState();
}

class AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  Uint8List? _selectedImage;
  String? _fileName;
  PlaceLocation? _selectedLocation;

  void _savePlace() async {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }

    final String path = await ImageStorage.save(_fileName!, _selectedImage!);

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(
          enteredTitle,
          path,
          _selectedLocation!,
        );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add new Place',
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                controller: _titleController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ImageInput(
                onPickImage: (name, image) {
                  _fileName = name;
                  _selectedImage = image;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              LocationInput(
                onSelectLocation: (location) {
                  _selectedLocation = location;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                onPressed: _savePlace,
                label: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
