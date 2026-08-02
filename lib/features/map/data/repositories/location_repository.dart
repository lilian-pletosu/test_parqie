import 'package:test_parqie/features/map/data/models/location_model.dart';
import 'package:test_parqie/features/map/data/sources/mock_locations.dart';

class LocationRepository {
  const LocationRepository();

  Future<List<LocationModel>> getLocations() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return MockLocations.all;
  }
}
