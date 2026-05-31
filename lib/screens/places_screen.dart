import 'package:flutter/material.dart';
import 'package:wya/screens/add_place_screen.dart';
import 'package:wya/widgets/places_list.dart';

class PlacesListingScreen extends StatelessWidget {
  const PlacesListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Places',
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,

        actions: [
          IconButton(
            onPressed: () {
              _navigateToAddPlaceScreen(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PlacesList(places: []),
    );
  }

  void _navigateToAddPlaceScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return const AddPlaceScreen();
        },
      ),
    );
  }
}
