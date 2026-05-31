import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wya/providers/user_places.dart';
import 'package:wya/screens/add_place_screen.dart';
import 'package:wya/widgets/places_list.dart';

class PlacesListingScreen extends ConsumerWidget {
  const PlacesListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPlaces = ref.watch(userPlacesProvider);
    // print(userPlaces.first.title);
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
      body: PlacesList(
        places: userPlaces,
      ),
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
