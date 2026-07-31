import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:pb_vault/core/utils/screen_size.dart';
import 'package:pb_vault/domain/entities/on_boarding/on_boarding_page.dart';
import 'package:pb_vault/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../core/utils/app_routes.dart';
import '../provider/onboarding_view_model.dart';
import '../widget/dots_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingViewModel provider = context.watch<OnboardingViewModel>();
    final int currentIndex = provider.currentIndex;
    final List<OnBoardingPage> onboardingDataList =
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
                  style: AppStyles.interRegular20(
                    context,
                    lColor: AppColors.black,
                    dColor: AppColors.white,
                  ),
                ),
              ),
              Text(
                onboardingDataList[currentIndex].subtitle.tr(),
                textAlign: TextAlign.center,
                style: AppStyles.interExtraLight14(
                  context,
                  lColor: AppColors.surfaceDark,
                  dColor: AppColors.backgroundLight,
                ),
              ),

              CustomElevatedButton(
                buttonWidth: double.infinity,
                onPressed: () {
                  final wasLastPage =
                      provider.currentIndex ==
                      provider.onboardingPagesNumber - 1;

                  provider.onFirstButtonClick();

                  if (wasLastPage) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.authScreen,
                    );
                  }
                },
                // onPressed: () {
                //   // provider.onFirstButtonClick(context);
                //   final action = provider.onFirstButtonClick();
                //
                //   if (action == OnboardingAction.navigateToAuth) {
                //     Navigator.pushReplacementNamed(context, AppRoutes.authScreen);
                //   }
                // },
                backgroundColor: context.easyColor(
                  lColor: AppColors.backgroundDark,
                  dColor: AppColors.primary,
                ),
                child: Text(
                  onboardingDataList[currentIndex].firstButton.tr(),
                  style: AppStyles.interMedium14(
                    context,
                    lColor: AppColors.white,
                    dColor: AppColors.backgroundDark,
                  ),
                ),
              ),

              CustomElevatedButton(
                buttonWidth: double.infinity,
                onPressed: () {
                  provider.onSecondButtonClick();
                  Navigator.pushReplacementNamed(context, AppRoutes.authScreen);
                },
                backgroundColor: AppColors.backgroundLight,
                borderSideColor: context.easyColor(
                  lColor: AppColors.backgroundDark,
                  dColor: AppColors.primary,
                ),
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
