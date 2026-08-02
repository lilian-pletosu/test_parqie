import 'package:flutter/material.dart';
import 'package:test_parqie/core/constants/app_colors.dart';

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

    if (ratio >= .6) return Colors.green;
    if (ratio >= .3) return Colors.orange;

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicWidth(
            child: Material(
              color: AppColors.surface,
              elevation: 6,
              borderRadius: BorderRadius.circular(18),
              shadowColor: AppColors.textSecondary,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
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
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
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
          Transform.rotate(
            angle: 0.785398,
            child: Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(top: 2),
              decoration: const BoxDecoration(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
