import 'package:flutter/material.dart';
import 'package:flutter_nominatim/flutter_nominatim.dart';
import 'package:location/location.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as dst;
import 'package:wya/models/place_location.dart';
import 'package:wya/screens/map_picker_screen.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});
  final void Function(PlaceLocation placeLocation) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  final Nominatim _nominatim = Nominatim.instance;

  var _isGettingLocation = false;

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
      setState(() {
        _isGettingLocation = true;
      });
      locationData = await location.getLocation();

      if (locationData.latitude != null && locationData.longitude != null) {
        final reverseGeocoding = await _nominatim.getAddressFromLatLng(
          locationData.latitude!,
          locationData.longitude!,
        );

        setState(() {
          _isGettingLocation = false;
          _pickedLocation = PlaceLocation(
            latitude: locationData.latitude!,
            longitude: locationData.longitude!,
            address: reverseGeocoding.displayName,
          );
        });

        if (_pickedLocation != null) {
          widget.onSelectLocation(_pickedLocation!);
        }
      } else {
        setState(() {
          _isGettingLocation = false;
        });
      }

      debugPrint(
        'Location: ${locationData.latitude}, ${locationData.longitude} ${_pickedLocation?.address}',
      );
    } catch (e) {
      setState(() {
        _isGettingLocation = false;
      });
      debugPrint('Location error: $e');
    }
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<PlaceLocation>(
      MaterialPageRoute(builder: (ctx) => const MapPickerScreen()),
    );

    if (pickedLocation == null) return;

    setState(() {
      _pickedLocation = pickedLocation;
    });

    widget.onSelectLocation(pickedLocation);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No Location Chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    if (_pickedLocation != null && !_isGettingLocation) {
      previewContent = FlutterMap(
        key: ValueKey(_pickedLocation),
        options: MapOptions(
          initialCenter: dst.LatLng(
            _pickedLocation!.latitude,
            _pickedLocation!.longitude,
          ),
          initialZoom: 15.0,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.yourdomain.favoriteplaces',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: dst.LatLng(
                  _pickedLocation!.latitude,
                  _pickedLocation!.longitude,
                ),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withAlpha(50),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(
                Icons.location_on,
              ),
              label: const Text(
                'Get current location',
              ),
              onPressed: _getCurrentLocation,
            ),

            TextButton.icon(
              onPressed: _selectOnMap,
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
