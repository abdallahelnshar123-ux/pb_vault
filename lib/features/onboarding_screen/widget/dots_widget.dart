import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:pb_vault/core/constants/app_constants.dart';
import 'package:pb_vault/core/utils/app_colors.dart';

class DotsWidget extends StatelessWidget {
  final int currentIndex;

  const DotsWidget({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        spacing: 7,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          AppConstants.onBoardingPages.length,
          (index) => _builtDots(dotIndex: index, context: context),
        ),
      ),
    );
  }

  Widget _builtDots({required int dotIndex, required BuildContext context}) {
    return Container(
      width: 15,
      height: 5,
      decoration: BoxDecoration(
        color: dotIndex == currentIndex
            ? context.easyColor(
                lColor: AppColors.backgroundDark,
                dColor: AppColors.primary,
              )
            : context.easyColor(
                lColor: AppColors.gray,
                dColor: AppColors.backgroundLight,
              ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
