import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        title: Text(
          'edit_profile'.tr(),
          style: AppStyles.interRegular20White,
        ),
      ),
      body: Center(
        child: Text(
          'Edit Profile Screen Placeholder',
          style: AppStyles.interRegular20White,
        ),
      ),
    );
  }
}
