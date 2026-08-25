import 'package:pb_vault/domain/entities/response/platform_account/login_method.dart';

import '../../domain/entities/on_boarding/on_boarding_page.dart';
import '../utils/app_assets.dart';

class AppConstants {
  static final List<OnBoardingPage> onBoardingPages = [
    OnBoardingPage(
      image: AppAssets.onBoardingImage1,
      subtitle: "onboarding_description1",
      title: "onboarding_title1",
      firstButton: "next",
      secondButton: 'skip',
    ),

    OnBoardingPage(
      image: AppAssets.onBoardingImage2,
      subtitle: "onboarding_description2",
      title: "onboarding_title2",
      firstButton: "next",
      secondButton: "skip",
    ),

    OnBoardingPage(
      image: AppAssets.onBoardingImage3,
      subtitle: "onboarding_description3",
      title: "onboarding_title3",
      firstButton: "sign_in",
      secondButton: "register",
    ),
  ];

  static Map<String, String> loginMethodsIcons = {
    LoginProvider.password.name: 'assets/icons/password_icon.svg',
    LoginProvider.apple.name: 'assets/icons/apple_icon.svg',
    LoginProvider.discord.name: 'assets/icons/discord_icon.svg',
    LoginProvider.facebook.name: 'assets/icons/facebook_icon.svg',
    LoginProvider.github.name: 'assets/icons/github_icon.svg',
    LoginProvider.passkey.name: 'assets/icons/passkey_icon.svg',
    LoginProvider.google.name: 'assets/icons/google_icon.svg',
    LoginProvider.linkedin.name: 'assets/icons/linkedin_icon.svg',
    LoginProvider.x.name: 'assets/icons/x_icon.svg',
    LoginProvider.microsoft.name: 'assets/icons/microsoft_icon.svg',
  };
}
