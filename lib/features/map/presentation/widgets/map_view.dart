import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_parqie/features/map/presentation/widgets/parking_marker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/location_model.dart';
import 'current_location_marker.dart';

class MapView extends StatelessWidget {
  const MapView({
    super.key,
    required this.initialPosition,
    required this.locations,
    required this.mapController,
    this.currentPosition,
    this.onLocationTap,
    this.onMyLocationPressed,
  });

  final LatLng initialPosition;
  final LatLng? currentPosition;
  final List<LocationModel> locations;
  final MapController mapController;
  final ValueChanged<LocationModel>? onLocationTap;
  final Future<void> Function()? onMyLocationPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: initialPosition,
            initialZoom: 15,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.test_parqie',
            ),
            MarkerLayer(
              markers: [
                ...locations.map(
                  (location) => Marker(
                    point: LatLng(location.latitude, location.longitude),
                    width: 170,
                    height: 80,
                    alignment: Alignment.topCenter,
                    child: ParkingMarker(
                      title: location.title,
                      availableSpots: location.availableSpots,
                      totalSpots: location.totalSpots,
                      onTap: () => onLocationTap?.call(location),
                    ),
                  ),
                ),
                if (currentPosition != null)
                  Marker(
                    point: currentPosition!,
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: const CurrentLocationMarker(),
                  ),
              ],
            ),
          ],
        ),
        Positioned(
          right: 24,
          bottom: 48,
          child: FloatingActionButton(
            heroTag: 'my_location',
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            onPressed: onMyLocationPressed,
            child: const Icon(Icons.my_location_rounded),
          ),
        ),
      ],
    );
  }
}
