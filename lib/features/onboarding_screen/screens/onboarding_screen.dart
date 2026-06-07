import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pb_vault/core/utils/screen_size.dart';
import 'package:pb_vault/domain/entities/on_boarding/on_boarding_item.dart';
import 'package:pb_vault/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../provider/onboarding_view_model.dart';
import '../widget/dots_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingViewModel provider = context.watch<OnboardingViewModel>();
    final int currentIndex = provider.currentIndex;
    final List<OnBoardingItem> onboardingDataList =
        AppConstants.onBoardingPages;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(),
        body: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(
            context.width * 0.04,
            0,
            context.width * 0.04,
            context.width * 0.04,
          ),
          child: Column(
            spacing: context.height * 0.015,
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Image.asset(
                    key: ValueKey(onboardingDataList[currentIndex].image),
                    onboardingDataList[currentIndex].image,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              DotsWidget(currentIndex: currentIndex),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  onboardingDataList[currentIndex].title.tr(),
                  textAlign: TextAlign.center,
                  style: AppStyles.interRegular20White,
                ),
              ),
              Text(
                onboardingDataList[currentIndex].subtitle.tr(),
                textAlign: TextAlign.center,
                style: AppStyles.interExtraLight14BackgroundLight,
              ),

              CustomElevatedButton(
                onPressed: () {
                  provider.onFirstButtonClick(context);
                },
                backgroundColor: AppColors.primary,
                child: Text(
                  onboardingDataList[currentIndex].firstButton.tr(),
                  style: AppStyles.interMedium14BackgroundDark,
                ),
              ),

              CustomElevatedButton(
                onPressed: () {
                  provider.onSecondButtonClick(context);
                },
                backgroundColor: AppColors.backgroundLight,
                borderSideColor: AppColors.primary,
                child: Text(
                  onboardingDataList[currentIndex].secondButton.tr(),
                  style: AppStyles.interMedium14BackgroundDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
