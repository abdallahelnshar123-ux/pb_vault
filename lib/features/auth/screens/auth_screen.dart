import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pb_vault/features/auth/widget/section_switcher.dart';
import 'package:pb_vault/widgets/custom_app_bar.dart';

import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: CustomAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: context.height * 0.02),
              _builtTitle(),
              _builtSubTitle(context),
              Expanded(child: SectionSwitcher()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _builtTitle() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        'welcome_to_pb_vault'.tr(),
        textAlign: TextAlign.center,
        style: AppStyles.interRegular20White,
      ),
    );
  }

  Widget _builtSubTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.width * 0.04,
        horizontal: context.width * 0.04,
      ),
      child: Text(
        'login_or_sign_up_to_unlock_your_personal_vault'.tr(),
        textAlign: TextAlign.center,
        style: AppStyles.interExtraLight14BackgroundLight,
      ),
    );
  }
}
