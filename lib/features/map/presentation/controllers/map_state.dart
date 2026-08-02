import 'package:geolocator/geolocator.dart';
import 'package:test_parqie/features/map/data/models/location_model.dart';

class MapState {
  const MapState({
    required this.locations,
    this.currentPosition,
    this.selectedLocation,
    this.searchQuery = '',
  });

  final List<LocationModel> locations;
  final Position? currentPosition;
  final LocationModel? selectedLocation;
  final String searchQuery;

  List<LocationModel> get filteredLocations {
    if (searchQuery.trim().isEmpty) return locations;
    final query = searchQuery.trim().toLowerCase();
    return locations.where((loc) {
      return loc.title.toLowerCase().contains(query) ||
          loc.description.toLowerCase().contains(query);
    }).toList();
  }

  MapState copyWith({
    List<LocationModel>? locations,
    Position? currentPosition,
    LocationModel? selectedLocation,
    String? searchQuery,
  }) {
    return MapState(
      locations: locations ?? this.locations,
      currentPosition: currentPosition ?? this.currentPosition,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
