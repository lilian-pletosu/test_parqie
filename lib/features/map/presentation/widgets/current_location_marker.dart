import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class CurrentLocationMarker extends StatelessWidget {
  const CurrentLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.currentLocationMarkerSize,
      height: AppSizes.currentLocationMarkerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Aura pulsantă exterioară
          Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.15, 1.15),
                duration: 1200.ms,
                curve: Curves.easeInOut,
              )
              .fade(begin: 0.7, end: 0.2, duration: 1200.ms),

          // Punctul central albastru cu bordură albă (stil GPS)
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 3.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
