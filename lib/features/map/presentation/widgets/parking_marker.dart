import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class ParkingMarker extends StatelessWidget {
  const ParkingMarker({
    super.key,
    required this.title,
    required this.availableSpots,
    required this.totalSpots,
    this.onTap,
  });

  final String title;
  final int availableSpots;
  final int totalSpots;
  final VoidCallback? onTap;

  Color get statusColor {
    final ratio = availableSpots / totalSpots;

    if (ratio >= 0.6) return AppColors.success;
    if (ratio >= 0.3) return AppColors.warning;

    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: -4,
                child: Transform.rotate(
                  angle: 0.785398,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
              IntrinsicWidth(
                child: Material(
                  color: AppColors.surface,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(AppSizes.r18),
                  shadowColor: AppColors.shadow,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p10,
                      vertical: AppSizes.p8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_parking_rounded,
                            color: AppColors.white,
                            size: AppSizes.iconMd,
                          ),
                        ),
                        const SizedBox(width: AppSizes.p8),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '$availableSpots libere',
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
