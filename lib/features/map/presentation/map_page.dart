import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/app_sizes.dart';
import 'controllers/map_controller.dart';
import 'widgets/location_bottom_sheet.dart';
import 'widgets/location_search_bar.dart';
import 'widgets/map_view.dart';

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
          AppSizes.mapFocusZoom,
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

          final initialPos = userLocation ??
              const LatLng(
                AppSizes.mapDefaultLatitude,
                AppSizes.mapDefaultLongitude,
              );

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                MapView(
                  initialPosition: initialPos,
                  currentPosition: userLocation,
                  locations: mapState.filteredLocations,
                  mapController: _flutterMapController,
                  onLocationTap: (location) {
                    FocusScope.of(context).unfocus();
                    ref.read(mapProvider.notifier).selectLocation(location);
                  },
                  onMyLocationPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (userLocation != null) {
                      _flutterMapController.move(
                        userLocation,
                        AppSizes.mapDefaultZoom,
                      );
                    }
                  },
                ),

                Positioned(
                  top: MediaQuery.of(context).padding.top + AppSizes.p12,
                  left: AppSizes.p16,
                  right: AppSizes.p16,
                  child: LocationSearchBar(
                    onLocationSelected: (location) {
                      FocusScope.of(context).unfocus();
                      ref.read(mapProvider.notifier).selectLocation(location);
                      _flutterMapController.move(
                        LatLng(location.latitude, location.longitude),
                        AppSizes.mapFocusZoom,
                      );
                    },
                  ),
                ),

                DraggableScrollableSheet(
                  initialChildSize: AppSizes.sheetInitialChildSize,
                  minChildSize: AppSizes.sheetMinChildSize,
                  maxChildSize: AppSizes.sheetMaxChildSize,
                  builder: (context, controller) {
                    return LocationBottomSheet(scrollController: controller);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
