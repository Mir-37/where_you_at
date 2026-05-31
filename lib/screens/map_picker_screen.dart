import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as dst;
import 'package:flutter_nominatim/flutter_nominatim.dart';
import 'package:wya/models/place_location.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  dst.LatLng? _pickedLocation;
  bool _isLoadingAddress = false;

  void _onTap(TapPosition tapPosition, dst.LatLng point) {
    setState(() {
      _pickedLocation = point;
    });
  }

  void _confirmLocation() async {
    if (_pickedLocation == null) return;

    setState(() => _isLoadingAddress = true);

    final result = await Nominatim.instance.getAddressFromLatLng(
      _pickedLocation!.latitude,
      _pickedLocation!.longitude,
    );

    if (!mounted) return;

    Navigator.of(context).pop(
      PlaceLocation(
        latitude: _pickedLocation!.latitude,
        longitude: _pickedLocation!.longitude,
        address: result.displayName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick your location',
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: [
          if (_pickedLocation != null)
            _isLoadingAddress
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  )
                : IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: _confirmLocation,
                  ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const dst.LatLng(23.8103, 90.4125), // fallback center
          initialZoom: 13.0,
          onTap: _onTap,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.yourdomain.favoriteplaces',
          ),
          if (_pickedLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _pickedLocation!,
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
      ),
    );
  }
}
