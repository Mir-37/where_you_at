import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wya/providers/user_places.dart';
import 'package:wya/screens/add_place_screen.dart';
import 'package:wya/widgets/places_list.dart';

class PlacesListingScreen extends ConsumerStatefulWidget {
  const PlacesListingScreen({super.key});

  @override
  ConsumerState<PlacesListingScreen> createState() {
    return _PlacesListingScreenState();
  }
}

class _PlacesListingScreenState extends ConsumerState<PlacesListingScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, asyncSnapshot) =>
              asyncSnapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : PlacesList(
                  places: userPlaces,
                ),
        ),
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
