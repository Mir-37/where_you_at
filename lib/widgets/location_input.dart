import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    if (!kIsWeb) {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }
    }

    try {
      locationData = await location.getLocation();
      debugPrint(
        'Location: ${locationData.latitude}, ${locationData.longitude}',
      );
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withAlpha(50),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'No Location Chosen',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(
                Icons.location_on,
              ),
              label: const Text(
                'Get current location',
              ),
            ),

            TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.map,
              ),
              label: const Text(
                'Select on map',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
