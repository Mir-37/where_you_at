import 'package:flutter/material.dart';
import 'package:wya/models/place.dart';
import 'package:wya/widgets/partials/center_empty_list_message.dart';

class PlacesList extends StatelessWidget {
  final List<Place> places;

  const PlacesList({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return CenterEmptyListMessage(
        message: 'No Places Added Yet..',
      );
    }
    return ListView.builder(
      itemBuilder: (ctx, index) {
        ListTile(
          title: Text(
            places[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
        return null;
      },
      itemCount: places.length,
    );
  }
}
