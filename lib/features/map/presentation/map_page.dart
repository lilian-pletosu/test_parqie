import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
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
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void dispose() {
    _flutterMapController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _expandSheet() {
    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        AppSizes.sheetMaxChildSize,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _collapseSheet() {
    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        AppSizes.sheetMinChildSize,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInCubic,
      );
    }
  }

  void _dismissAndCollapse() {
    FocusScope.of(context).unfocus();
    ref.read(mapProvider.notifier).clearSelection();
    _collapseSheet();
  }

  void _handleRecenter(LatLng? userLocation) {
    FocusScope.of(context).unfocus();
    if (userLocation != null) {
      _flutterMapController.move(
        userLocation,
        AppSizes.mapDefaultZoom,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Permisiunea de locație este dezactivată. Poți activa accesul din setări.',
          ),
          action: SnackBarAction(
            label: 'Setări',
            onPressed: () {
              Geolocator.openAppSettings();
            },
          ),
        ),
      );
    }
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
        _expandSheet();
      } else if (previous?.value?.selectedLocation != null && selected == null) {
        _collapseSheet();
      }
    });

    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            onTap: _dismissAndCollapse,
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
                  onMapTap: _dismissAndCollapse,
                  onMyLocationPressed: () async => _handleRecenter(userLocation),
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

                AnimatedSlide(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  offset: isKeyboardOpen ? const Offset(0, 1) : Offset.zero,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isKeyboardOpen ? 0.0 : 1.0,
                    child: IgnorePointer(
                      ignoring: isKeyboardOpen,
                      child: DraggableScrollableSheet(
                        controller: _sheetController,
                        initialChildSize: AppSizes.sheetMinChildSize,
                        minChildSize: AppSizes.sheetMinChildSize,
                        maxChildSize: AppSizes.sheetMaxChildSize,
                        snap: true,
                        snapSizes: const [
                          AppSizes.sheetMinChildSize,
                          AppSizes.sheetMaxChildSize,
                        ],
                        snapAnimationDuration:
                            const Duration(milliseconds: 250),
                        builder: (context, controller) {
                          return LocationBottomSheet(
                            scrollController: controller,
                            onMyLocationPressed: () =>
                                _handleRecenter(userLocation),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
