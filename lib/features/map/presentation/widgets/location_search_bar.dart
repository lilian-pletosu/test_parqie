import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/models/location_model.dart';
import '../controllers/map_controller.dart';

class LocationSearchBar extends ConsumerStatefulWidget {
  const LocationSearchBar({
    super.key,
    required this.onLocationSelected,
  });

  final ValueChanged<LocationModel> onLocationSelected;

  @override
  ConsumerState<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends ConsumerState<LocationSearchBar> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapProvider);

    return state.when(
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
      data: (mapState) {
        final filteredList = mapState.filteredLocations;
        final showResults = _isFocused && _textController.text.isNotEmpty;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Container Bară Căutare
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                onChanged: (query) {
                  ref.read(mapProvider.notifier).setSearchQuery(query);
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Caută o parcare sau o locație...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                    size: AppSizes.iconLg,
                  ),
                  suffixIcon: _textController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: AppSizes.iconMd),
                          onPressed: () {
                            _textController.clear();
                            ref.read(mapProvider.notifier).setSearchQuery('');
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p16,
                    vertical: AppSizes.p14,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),

            // Rezultate căutare dropdown
            if (showResults)
              Padding(
                padding: const EdgeInsets.only(top: AppSizes.p8),
                child: Material(
                  color: AppColors.surface,
                  elevation: 6,
                  shadowColor: AppColors.shadow,
                  borderRadius: BorderRadius.circular(AppSizes.r18),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: AppSizes.searchDropdownMaxHeight,
                    ),
                    child: filteredList.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(AppSizes.p16),
                            child: Text(
                              'Nicio parcare găsită pentru căutarea introdusă.',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: filteredList.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1, color: AppColors.divider),
                            itemBuilder: (context, index) {
                              final loc = filteredList[index];
                              return ListTile(
                                dense: true,
                                leading: Container(
                                  padding: const EdgeInsets.all(AppSizes.p6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.local_parking_rounded,
                                    color: AppColors.primary,
                                    size: AppSizes.iconMd,
                                  ),
                                ),
                                title: Text(
                                  loc.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  '${loc.availableSpots} locuri libere',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onTap: () {
                                  _focusNode.unfocus();
                                  widget.onLocationSelected(loc);
                                },
                              );
                            },
                          ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
