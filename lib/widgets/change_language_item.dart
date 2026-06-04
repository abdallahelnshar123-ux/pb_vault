import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/utils/app_assets.dart';
import '../core/utils/app_colors.dart';

class ChangeLanguageItem extends StatelessWidget {
  const ChangeLanguageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.yellowColor),
        ),
        child: Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            builtIcon(
              context: context,
              logo: AppAssets.usaLogo,
              languageCode: 'ar',
              onTap: () => context.setLocale(Locale('en')),
            ),

            // GestureDetector(
            //   onTap: () => context.setLocale(Locale('en')),
            //   child: CircleAvatar(
            //     radius: 20,
            //     backgroundColor: context.locale.languageCode == 'en'
            //         ? AppColors.yellowColor
            //         : Colors.transparent,
            //     child: Image.asset(AppAssets.usaLogo, width: 30),
            //   ),
            // ),
            builtIcon(
              context: context,
              logo: AppAssets.egyptLogo,
              languageCode: 'en',
              onTap: () => context.setLocale(Locale('ar')),
            ),
            // GestureDetector(
            //   onTap: () => context.setLocale(Locale('ar')),
            //   child: CircleAvatar(
            //     radius: 20,
            //     backgroundColor: context.locale.languageCode == 'en'
            //         ? AppColors.transparentColor
            //         : AppColors.yellowColor,
            //     child: CircleAvatar(
            //       radius: 14,
            //       backgroundImage: AssetImage(AppAssets.egyptLogo),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget builtIcon({
    required BuildContext context,
    required String logo,
    required String languageCode,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: context.locale.languageCode == languageCode
            ? AppColors.transparentColor
            : AppColors.yellowColor,
        child: CircleAvatar(radius: 14, backgroundImage: AssetImage(logo)),
      ),
    );
  }
}
