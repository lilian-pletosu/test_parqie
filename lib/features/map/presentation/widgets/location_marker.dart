import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/location_model.dart';

class LocationMarker extends StatelessWidget {
  const LocationMarker({
    super.key,
    required this.location,
    this.onTap,
  });

  final LocationModel location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.location_on_rounded,
        size: 42,
        color: AppColors.primary,
      ),
    );
  }
}
