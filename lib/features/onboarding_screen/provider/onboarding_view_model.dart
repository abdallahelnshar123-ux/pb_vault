import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/core/constants/app_constants.dart';

import '../../../domain/use_cases/set_onboarding_done_use_case.dart';

@injectable
class OnboardingViewModel extends ChangeNotifier {
  final SetOnboardingDoneUseCase _setOnboardingDoneUseCase;
  final int onboardingPagesNumber = AppConstants.onBoardingPages.length;

  int currentIndex = 0;

  OnboardingViewModel(this._setOnboardingDoneUseCase);

  void changeIndex(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      notifyListeners();
    }
  }
  void onFirstButtonClick() {
    if (currentIndex < onboardingPagesNumber - 1) {
      currentIndex++;
      notifyListeners();
    } else {
      _setOnboardingDoneUseCase.setOnboardingDone();
    }
  }

  void onSecondButtonClick() {
    _setOnboardingDoneUseCase.setOnboardingDone();
  }
  // OnboardingAction onFirstButtonClick() {
  //   if (currentIndex < onboardingPagesNumber - 1) {
  //     currentIndex++;
  //     notifyListeners();
  //     return OnboardingAction.nextPage;
  //   }
  //   _setOnboardingDoneUseCase.setOnboardingDone();
  //   return OnboardingAction.navigateToAuth;
  // }
  //
  // // void onFirstButtonClick(BuildContext context) {
  // //   if (currentIndex < onboardingPagesNumber - 1) {
  // //     currentIndex++;
  // //     notifyListeners();
  // //   } else {
  // //     _setOnboardingDoneUseCase.setOnboardingDone();
  // //     Navigator.pushReplacementNamed(context, AppRoutes.authScreen);
  // //   }
  // // }
  //
  // void onSecondButtonClick() {
  //   _setOnboardingDoneUseCase.setOnboardingDone();
  //   // return OnboardingAction.navigateToAuth;
  // }
}

// enum OnboardingAction { nextPage, navigateToAuth }
