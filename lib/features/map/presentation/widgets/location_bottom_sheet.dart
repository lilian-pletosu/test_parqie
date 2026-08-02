import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../profile/presentation/profile_page.dart';
import '../../data/models/location_model.dart';
import '../controllers/map_controller.dart';

class LocationBottomSheet extends ConsumerWidget {
  const LocationBottomSheet({
    super.key,
    required this.scrollController,
    this.onMyLocationPressed,
  });

  final ScrollController scrollController;
  final VoidCallback? onMyLocationPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mapProvider);

    return state.when(
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
      data: (mapState) {
        final location = mapState.selectedLocation;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSizes.r28),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSizes.r28),
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _HeaderDelegate(
                    location: location,
                    onMyLocationPressed: onMyLocationPressed,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.p20,
                    AppSizes.p16,
                    AppSizes.p20,
                    AppSizes.p24,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: location != null
                        ? _buildSelectedLocationView(context, ref, location)
                        : _buildCurrentLocationView(context, ref, mapState.locations),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedLocationView(
    BuildContext context,
    WidgetRef ref,
    LocationModel location,
  ) {
    final ratio = location.availableSpots / location.totalSpots;
    final statusColor = ratio >= 0.5
        ? AppColors.success
        : (ratio >= 0.2 ? AppColors.warning : AppColors.danger);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.r10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSizes.p6),
                  Text(
                    ratio >= 0.5
                        ? 'Disponibilitate mare'
                        : (ratio >= 0.2 ? 'Aproape plin' : 'Aglomerat'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 20),
              visualDensity: VisualDensity.compact,
              onPressed: () {
                ref.read(mapProvider.notifier).clearSelection();
              },
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p12),

        // Indicator grad de ocupare
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.p6),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
          ),
        ),
        const SizedBox(height: AppSizes.p8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${location.availableSpots} din ${location.totalSpots} locuri libere',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${((1 - ratio) * 100).toInt()}% ocupat',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p16),

        Text(
          location.description,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppSizes.p16),

        // Chips detalii
        Row(
          children: [
            _buildDetailChip(
              icon: Icons.payments_outlined,
              label: '10 MDL / oră',
            ),
            const SizedBox(width: AppSizes.p8),
            _buildDetailChip(
              icon: Icons.directions_walk_rounded,
              label: '~350 m distanță',
            ),
            const SizedBox(width: AppSizes.p8),
            _buildDetailChip(icon: Icons.security_rounded, label: 'Pază 24/7'),
          ],
        ),
        const SizedBox(height: AppSizes.p20),

        // Butoane de acțiune
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Navigare pornită către ${location.title}'),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.navigation_rounded,
                  size: AppSizes.iconMd,
                ),
                label: const Text('Navighează'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentLocationView(
    BuildContext context,
    WidgetRef ref,
    List<LocationModel> locations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Parcări disponibile în apropiere',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.p10),

        // Listă scurtă parcări
        ...locations
            .take(5)
            .map(
              (loc) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.p8),
                child: Material(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.r14),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p14,
                      vertical: 2,
                    ),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_parking_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      loc.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      '${loc.availableSpots} locuri libere',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    onTap: () {
                      ref.read(mapProvider.notifier).selectLocation(loc);
                    },
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.p10,
        vertical: AppSizes.p6,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.r10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.iconSm, color: AppColors.primary),
          const SizedBox(width: AppSizes.p6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({
    required this.location,
    required this.onMyLocationPressed,
  });

  final LocationModel? location;
  final VoidCallback? onMyLocationPressed;

  @override
  double get minExtent => 90.0;

  @override
  double get maxExtent => 90.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final loc = location;

    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.p20,
              AppSizes.p12,
              AppSizes.p20,
              AppSizes.p12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // drag handle
                Center(
                  child: Container(
                    width: AppSizes.dragHandleWidth,
                    height: AppSizes.dragHandleHeight,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.p12),

                // antet cu butonul de profil si recentrare
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppSizes.r12),
                          onTap: () {
                            if (loc == null) {
                              onMyLocationPressed?.call();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.p4,
                              vertical: AppSizes.p4,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppSizes.p8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.my_location_rounded,
                                    color: AppColors.primary,
                                    size: AppSizes.iconMd,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.p10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc != null
                                            ? loc.title
                                            : 'Locația ta curentă',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        loc != null
                                            ? '${loc.availableSpots} locuri libere'
                                            : 'Apasă pentru recentrare pe hartă',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: loc != null
                                              ? AppColors.textSecondary
                                              : AppColors.primary,
                                          fontWeight: FontWeight.w500,
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
                    ),
                    const SizedBox(width: AppSizes.p8),

                    // butonul de profil
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppSizes.r24),
                        onTap: () {
                          context.push(ProfilePage.route);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              'AP',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return oldDelegate.location != location;
  }
}
