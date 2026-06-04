import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/screen_size.dart';
import '../../../../widgets/custom_elevated_button.dart';

class ContinueWithGoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ContinueWithGoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      onPressed: onPressed,
      backgroundColor: AppColors.yellowColor,
      child: Row(
        spacing: context.width * 0.02,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icons/google_icon.svg", fit: BoxFit.none),
          Text(
            "continue_with_google".tr(),
            style: AppStyles.robotoRegular20Black(context),
          ),
        ],
      ),
    );
  }
}
