import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_parqie/features/map/data/models/location_model.dart';
import 'package:test_parqie/features/map/data/repositories/location_repository.dart';
import 'package:test_parqie/features/map/presentation/controllers/map_state.dart';

import '../../services/location_service.dart';

part 'map_controller.g.dart';

@riverpod
class MapNotifier extends _$MapNotifier {
  final _repository = const LocationRepository();
  final _locationService = LocationService();

  @override
  FutureOr<MapState> build() async {
    final locations = await _repository.getLocations();
    final position = await _locationService.getCurrentPosition();

    return MapState(locations: locations, currentPosition: position);
  }

  void selectLocation(LocationModel location) {
    state = AsyncData(state.requireValue.copyWith(selectedLocation: location));
  }

  void clearSelection() {
    state = AsyncData(state.requireValue.copyWith(selectedLocation: null));
  }

  void setSearchQuery(String query) {
    state = AsyncData(state.requireValue.copyWith(searchQuery: query));
  }
}
