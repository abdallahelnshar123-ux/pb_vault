import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:pb_vault/widgets/search_text_field_widget.dart';

import '../../../core/constants/platforms_constants.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../../../domain/entities/response/platform_account/platform_data.dart';

class PlatformsBottomSheet extends StatefulWidget {
  final ValueChanged<PlatformData> newPlatform;
  final PlatformData? currentPlatform;

  const PlatformsBottomSheet({
    super.key,
    this.currentPlatform,
    required this.newPlatform,
  });

  @override
  State<PlatformsBottomSheet> createState() => _PlatformsBottomSheetState();
}

class _PlatformsBottomSheetState extends State<PlatformsBottomSheet> {
  final ValueNotifier<List<PlatformData>> _filteredPlatforms = ValueNotifier(
    popularPlatforms,
  );
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _filteredPlatforms.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.04),
      child: Column(
        spacing: context.width * 0.04,
        children: [
          SearchTextFieldWidget(onChanged: _searchPlatform),
          Expanded(child: _builtGridView()),
        ],
      ),
    );
  }

  void _searchPlatform(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filteredPlatforms.value = popularPlatforms
          .where(
            (platform) => platform.name.toLowerCase().contains(
              value.toLowerCase().trim(),
            ),
          )
          .toList();
    });
  }

  Widget _builtGridView() {
    return ValueListenableBuilder<List<PlatformData>>(
      valueListenable: _filteredPlatforms,
      builder: (context, filteredList, _) {
        return GridView.builder(
          itemCount: filteredList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1 / 1.2,
            crossAxisSpacing: context.width * 0.04,
            mainAxisSpacing: context.width * 0.04,
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            final platform = filteredList[index];
            return InkWell(
              onTap: () {
                if (widget.currentPlatform == platform) return;
                widget.newPlatform(platform);

                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(context.width * 0.03),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: BoxBorder.all(
                    color: context.easyColor(
                      dColor: AppColors.backgroundLight,
                      lColor: AppColors.backgroundDark,
                    ),
                  ),
                  color: widget.currentPlatform == platform
                      ? context.easyColor(
                          lColor: AppColors.backgroundDark,
                          dColor: AppColors.white,
                        )
                      : context.easyColor(
                          lColor: AppColors.primary,
                          dColor: AppColors.backgroundDark,
                        ),
                ),
                child: Column(
                  mainAxisSize: .min,
                  spacing: context.width * 0.02,
                  children: [
                    Image.network(
                      platform.icon,
                      width: context.width * 0.08,
                      errorBuilder: (_, _, _) => const Icon(Icons.public),
                    ),
                    FittedBox(
                      fit: .scaleDown,
                      child: Text(
                        platform.name,
                        style: widget.currentPlatform == platform
                            ? AppStyles.robotoRegular14(
                                context,
                                lColor: AppColors.white,
                                dColor: AppColors.surfaceDark,
                              )
                            : AppStyles.robotoRegular14(
                                context,
                                lColor: AppColors.surfaceDark,
                                dColor: AppColors.white,
                              ),

                        // widget.currentPlatform == platform
                        //     ? AppStyles.robotoBold14SurfaceDark(context)
                        //     : AppStyles.robotoRegular14White(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
