import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_parqie/features/map/presentation/controllers/map_controller.dart';
import 'package:test_parqie/features/map/presentation/widgets/location_bottom_sheet.dart';
import 'package:test_parqie/features/map/presentation/widgets/map_view.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  static const name = 'map';
  static const route = '/map';

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final fmap.MapController _flutterMapController = fmap.MapController();

  @override
  void dispose() {
    _flutterMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapProvider);

    ref.listen(mapProvider, (previous, next) {
      final selected = next.value?.selectedLocation;
      if (selected != null) {
        _flutterMapController.move(
          LatLng(selected.latitude, selected.longitude),
          15.5,
        );
      }
    });

    return Scaffold(
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (mapState) {
          final userLocation = mapState.currentPosition != null
              ? LatLng(
                  mapState.currentPosition!.latitude,
                  mapState.currentPosition!.longitude,
                )
              : null;

          final initialPos = userLocation ?? const LatLng(47.0105, 28.8638);

          return Stack(
            children: [
              MapView(
                initialPosition: initialPos,
                currentPosition: userLocation,
                locations: mapState.locations,
                mapController: _flutterMapController,
                onLocationTap: ref.read(mapProvider.notifier).selectLocation,
                onMyLocationPressed: () async {
                  if (userLocation != null) {
                    _flutterMapController.move(userLocation, 15.0);
                  }
                },
              ),

              DraggableScrollableSheet(
                initialChildSize: 0.22,
                minChildSize: 0.18,
                maxChildSize: 0.5,
                builder: (context, controller) {
                  return LocationBottomSheet(scrollController: controller);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
