import 'package:pb_vault/domain/entities/response/platform_account/login_method.dart';

import '../../domain/entities/on_boarding/on_boarding_item.dart';
import '../../domain/entities/response/platform_account/platform_data.dart';
import '../utils/app_assets.dart';

class AppConstants {
  static const String usersCollectionName = 'users';
  static const String accountsCollectionName = 'accounts';

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
  static const List<PlatformData> popularPlatforms = [
    PlatformData(
      name: 'Google',
      icon: 'https://www.google.com/favicon.ico',
      website: 'https://www.google.com',
    ),
    PlatformData(
      name: 'Facebook',
      icon: 'https://www.facebook.com/favicon.ico',
      website: 'https://www.facebook.com',
    ),
    PlatformData(
      name: 'Instagram',
      icon: 'https://www.instagram.com/favicon.ico',
      website: 'https://www.instagram.com',
    ),
    PlatformData(
      name: 'Twitter (X)',
      icon: 'https://abs.twimg.com/favicons/twitter.2.ico',
      website: 'https://www.twitter.com',
    ),
    PlatformData(
      name: 'LinkedIn',
      icon: 'https://www.linkedin.com/favicon.ico',
      website: 'https://www.linkedin.com',
    ),
    PlatformData(
      name: 'GitHub',
      icon: 'https://github.githubassets.com/favicons/favicon.ico',
      website: 'https://github.com',
    ),
    PlatformData(
      name: 'Netflix',
      icon: 'https://www.netflix.com/favicon.ico',
      website: 'https://www.netflix.com',
    ),
    PlatformData(
      name: 'Amazon',
      icon: 'https://www.amazon.com/favicon.ico',
      website: 'https://www.amazon.com',
    ),
    PlatformData(
      name: 'Microsoft',
      icon: 'https://www.microsoft.com/favicon.ico',
      website: 'https://www.microsoft.com',
    ),
    PlatformData(
      name: 'Apple',
      icon: 'https://www.apple.com/favicon.ico',
      website: 'https://www.apple.com',
    ),
    PlatformData(
      name: 'Spotify',
      icon: 'https://www.spotify.com/favicon.ico',
      website: 'https://www.spotify.com',
    ),
    PlatformData(
      name: 'YouTube',
      icon: 'https://www.youtube.com/favicon.ico',
      website: 'https://www.youtube.com',
    ),
    PlatformData(
      name: 'TikTok',
      icon: 'https://www.tiktok.com/favicon.ico',
      website: 'https://www.tiktok.com',
    ),
    PlatformData(
      name: 'WhatsApp',
      icon: 'https://www.whatsapp.com/favicon.ico',
      website: 'https://www.whatsapp.com',
    ),
    PlatformData(
      name: 'Telegram',
      icon: 'https://telegram.org/favicon.ico',
      website: 'https://telegram.org',
    ),
    PlatformData(
      name: 'Snapchat',
      icon: 'https://www.snapchat.com/favicon.ico',
      website: 'https://www.snapchat.com',
    ),
    PlatformData(
      name: 'Reddit',
      icon: 'https://www.reddit.com/favicon.ico',
      website: 'https://www.reddit.com',
    ),
    PlatformData(
      name: 'Pinterest',
      icon: 'https://www.pinterest.com/favicon.ico',
      website: 'https://www.pinterest.com',
    ),
    PlatformData(
      name: 'Discord',
      icon: 'https://discord.com/favicon.ico',
      website: 'https://discord.com',
    ),
    PlatformData(
      name: 'Dropbox',
      icon: 'https://www.dropbox.com/favicon.ico',
      website: 'https://www.dropbox.com',
    ),
    PlatformData(
      name: 'Slack',
      icon: 'https://slack.com/favicon.ico',
      website: 'https://slack.com',
    ),
    PlatformData(
      name: 'Zoom',
      icon: 'https://zoom.us/favicon.ico',
      website: 'https://zoom.us',
    ),
    PlatformData(
      name: 'PayPal',
      icon: 'https://www.paypal.com/favicon.ico',
      website: 'https://www.paypal.com',
    ),
    PlatformData(
      name: 'Visa',
      icon: 'https://www.visa.com/favicon.ico',
      website: 'https://www.visa.com',
    ),
    PlatformData(
      name: 'Mastercard',
      icon: 'https://www.mastercard.com/favicon.ico',
      website: 'https://www.mastercard.com',
    ),
    PlatformData(
      name: 'Skype',
      icon: 'https://www.skype.com/favicon.ico',
      website: 'https://www.skype.com',
    ),
    PlatformData(
      name: 'Vimeo',
      icon: 'https://vimeo.com/favicon.ico',
      website: 'https://vimeo.com',
    ),
    PlatformData(
      name: 'Twitch',
      icon: 'https://www.twitch.tv/favicon.ico',
      website: 'https://www.twitch.tv',
    ),
    PlatformData(
      name: 'Airbnb',
      icon: 'https://www.airbnb.com/favicon.ico',
      website: 'https://www.airbnb.com',
    ),
    PlatformData(
      name: 'Uber',
      icon: 'https://www.uber.com/favicon.ico',
      website: 'https://www.uber.com',
    ),
    PlatformData(
      name: 'Lyft',
      icon: 'https://www.lyft.com/favicon.ico',
      website: 'https://www.lyft.com',
    ),
    PlatformData(
      name: 'Ebay',
      icon: 'https://www.ebay.com/favicon.ico',
      website: 'https://www.ebay.com',
    ),
    PlatformData(
      name: 'AliExpress',
      icon: 'https://www.aliexpress.com/favicon.ico',
      website: 'https://www.aliexpress.com',
    ),
    PlatformData(
      name: 'Canva',
      icon: 'https://www.canva.com/favicon.ico',
      website: 'https://www.canva.com',
    ),
    PlatformData(
      name: 'Notion',
      icon: 'https://www.notion.so/images/favicon.ico',
      website: 'https://www.notion.so',
    ),
    PlatformData(
      name: 'Trello',
      icon: 'https://trello.com/favicon.ico',
      website: 'https://trello.com',
    ),
    PlatformData(
      name: 'Asana',
      icon: 'https://asana.com/favicon.ico',
      website: 'https://asana.com',
    ),
    PlatformData(
      name: 'Adobe',
      icon: 'https://www.adobe.com/favicon.ico',
      website: 'https://www.adobe.com',
    ),
    PlatformData(
      name: 'Booking.com',
      icon: 'https://www.booking.com/favicon.ico',
      website: 'https://www.booking.com',
    ),
    PlatformData(
      name: 'Expedia',
      icon: 'https://www.expedia.com/favicon.ico',
      website: 'https://www.expedia.com',
    ),
    PlatformData(
      name: 'Hulu',
      icon: 'https://www.hulu.com/favicon.ico',
      website: 'https://www.hulu.com',
    ),
    PlatformData(
      name: 'Disney+',
      icon: 'https://www.disneyplus.com/favicon.ico',
      website: 'https://www.disneyplus.com',
    ),
    PlatformData(
      name: 'Steam',
      icon: 'https://store.steampowered.com/favicon.ico',
      website: 'https://store.steampowered.com',
    ),
    PlatformData(
      name: 'Epic Games',
      icon: 'https://www.epicgames.com/favicon.ico',
      website: 'https://www.epicgames.com',
    ),
    PlatformData(
      name: 'PlayStation',
      icon: 'https://www.playstation.com/favicon.ico',
      website: 'https://www.playstation.com',
    ),
    PlatformData(
      name: 'Xbox',
      icon: 'https://www.xbox.com/favicon.ico',
      website: 'https://www.xbox.com',
    ),
    PlatformData(
      name: 'Quora',
      icon: 'https://www.quora.com/favicon.ico',
      website: 'https://www.quora.com',
    ),
    PlatformData(
      name: 'Medium',
      icon: 'https://medium.com/favicon.ico',
      website: 'https://medium.com',
    ),
    PlatformData(
      name: 'WordPress',
      icon: 'https://wordpress.com/favicon.ico',
      website: 'https://wordpress.com',
    ),
    PlatformData(
      name: 'Wix',
      icon: 'https://www.wix.com/favicon.ico',
      website: 'https://www.wix.com',
    ),
  ];

  static const Map<String, String> userAvatars = {
    'profile_avatar_1': 'assets/avatars/profile_avatar_1.svg',
    'profile_avatar_2': 'assets/avatars/profile_avatar_2.svg',
    'profile_avatar_3': 'assets/avatars/profile_avatar_3.svg',
    'profile_avatar_4': 'assets/avatars/profile_avatar_4.svg',
    'profile_avatar_5': 'assets/avatars/profile_avatar_5.svg',
    'profile_avatar_6': 'assets/avatars/profile_avatar_6.svg',
    'profile_avatar_7': 'assets/avatars/profile_avatar_7.svg',
    'profile_avatar_8': 'assets/avatars/profile_avatar_8.svg',
    'profile_avatar_9': 'assets/avatars/profile_avatar_9.svg',
    'profile_avatar_10': 'assets/avatars/profile_avatar_10.svg',
    'profile_avatar_11': 'assets/avatars/profile_avatar_11.svg',
    'profile_avatar_12': 'assets/avatars/profile_avatar_12.svg',
    'profile_avatar_13': 'assets/avatars/profile_avatar_13.svg',
    'profile_avatar_14': 'assets/avatars/profile_avatar_14.svg',
    'profile_avatar_15': 'assets/avatars/profile_avatar_15.svg',
    'profile_avatar_16': 'assets/avatars/profile_avatar_16.svg',
    'profile_avatar_17': 'assets/avatars/profile_avatar_17.svg',
    'profile_avatar_18': 'assets/avatars/profile_avatar_18.svg',
    'profile_avatar_19': 'assets/avatars/profile_avatar_19.svg',
    'profile_avatar_20': 'assets/avatars/profile_avatar_20.svg',
    'profile_avatar_21': 'assets/avatars/profile_avatar_21.svg',
    'profile_avatar_22': 'assets/avatars/profile_avatar_22.svg',
    'profile_avatar_23': 'assets/avatars/profile_avatar_23.svg',
    'profile_avatar_24': 'assets/avatars/profile_avatar_24.svg',
    'profile_avatar_25': 'assets/avatars/profile_avatar_25.svg',
    'profile_avatar_26': 'assets/avatars/profile_avatar_26.svg',
    'profile_avatar_27': 'assets/avatars/profile_avatar_27.svg',
    'profile_avatar_28': 'assets/avatars/profile_avatar_28.svg',
    'profile_avatar_29': 'assets/avatars/profile_avatar_29.svg',
    'profile_avatar_30': 'assets/avatars/profile_avatar_30.svg',
  };
  static Map<String, String> loginMethodsIcons = {
    LoginProvider.password.name : 'assets/icons/password_icon.svg',
    LoginProvider.apple.name : 'assets/icons/apple_icon.svg',
    LoginProvider.discord.name : 'assets/icons/discord_icon.svg',
    LoginProvider.facebook.name : 'assets/icons/facebook_icon.svg',
    LoginProvider.github.name : 'assets/icons/github_icon.svg',
    LoginProvider.passkey.name : 'assets/icons/passkey_icon.svg',
    LoginProvider.google.name : 'assets/icons/google_icon.svg',
    LoginProvider.linkedin.name : 'assets/icons/linkedin_icon.svg',
    LoginProvider.x.name : 'assets/icons/x_icon.svg',
    LoginProvider.microsoft.name : 'assets/icons/microsoft_icon.svg',
  };
}
