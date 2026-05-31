import 'package:flutter/material.dart';
import 'package:wya/models/place.dart';
import 'package:wya/screens/place_detail_screen.dart';
import 'package:wya/widgets/partials/center_empty_list_message.dart';

class PlacesList extends StatelessWidget {
  final List<Place> places;
  const PlacesList({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    if (places.isNotEmpty) {
      return ListView.builder(
        itemCount: places.length,
        itemBuilder: (ctx, index) => ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: MemoryImage((places[index].imageBytes)),
          ),
          title: Text(
            places[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            places[index].placeLocation.address,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
            ),
          ),
          onTap: () {
            _navigateToPlaceDetailScreen(context, places[index]);
          },
        ),
      );
    }
    return CenterEmptyListMessage(
      message: 'No Places Added Yet..',
    );
  }

  void _navigateToPlaceDetailScreen(BuildContext context, Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PlaceDetailScreen(
          place: place,
        ),
      ),
    );
  }
}
