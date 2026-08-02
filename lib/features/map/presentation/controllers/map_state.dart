import 'package:geolocator/geolocator.dart';
import 'package:test_parqie/features/map/data/models/location_model.dart';

class MapState {
  const MapState({
    required this.locations,
    this.currentPosition,
    this.selectedLocation,
  });

  final List<LocationModel> locations;
  final Position? currentPosition;
  final LocationModel? selectedLocation;

  MapState copyWith({
    List<LocationModel>? locations,
    Position? currentPosition,
    LocationModel? selectedLocation,
  }) {
    return MapState(
      locations: locations ?? this.locations,
      currentPosition: currentPosition ?? this.currentPosition,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
}
