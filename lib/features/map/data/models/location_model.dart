import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';

@freezed
abstract class LocationModel with _$LocationModel {
  const factory LocationModel({
    required String id,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required int availableSpots,
    required int totalSpots,
  }) = _LocationModel;
}
