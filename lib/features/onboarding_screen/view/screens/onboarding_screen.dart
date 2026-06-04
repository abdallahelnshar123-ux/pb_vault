import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pb_vault/core/utils/app_assets.dart';
import 'package:pb_vault/core/utils/screen_size.dart';
import 'package:pb_vault/domain/entities/on_boarding/on_boarding_item.dart';
import 'package:pb_vault/features/onboarding_screen/view/widget/dots_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../provider/onboarding_view_model.dart';

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
        appBar: AppBar(
          toolbarHeight: context.height *0.125,
          centerTitle: true,
          title: SvgPicture.asset(
            AppAssets.appLogo,
            alignment: Alignment.center,
          ),
        ),
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

  // Widget builtBottomSheet(BuildContext context) {
  //
  //   return BottomSheet(
  //     backgroundColor: provider.currentIndex == 0
  //         ? AppColors.primary
  //         : AppColors.primary,
  //     showDragHandle: false,
  //     onClosing: () {},
  //     builder: (context) {
  //       return Padding(
  //         padding: EdgeInsetsGeometry.fromLTRB(
  //           context.width * 0.04,
  //           context.height * 0.04,
  //           context.width * 0.04,
  //           context.width * 0.02,
  //         ),
  //         child: Column(
  //           spacing: context.width * 0.03,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
