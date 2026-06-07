import '../../domain/entities/on_boarding/on_boarding_item.dart';
import '../utils/app_assets.dart';

class AppConstants {
  static const String usersCollectionName = 'users';

  static final List<OnBoardingItem> onBoardingPages = [
    OnBoardingItem(
      image: AppAssets.onBoardingImage1,
      subtitle: "onboarding_description1",
      title: "onboarding_title1",
      firstButton: "next",
      secondButton: 'skip',
    ),

    OnBoardingItem(
      image: AppAssets.onBoardingImage2,
      subtitle: "onboarding_description2",
      title: "onboarding_title2",
      firstButton: "next",
      secondButton: "skip",
    ),

    OnBoardingItem(
      image: AppAssets.onBoardingImage3,
      subtitle: "onboarding_description3",
      title: "onboarding_title3",
      firstButton: "sign_in",
      secondButton: "register",
    ),
  ];
}
