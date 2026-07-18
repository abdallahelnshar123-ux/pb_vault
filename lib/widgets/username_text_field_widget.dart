import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pb_vault/core/utils/app_assets.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/app_styles.dart';
import '../core/utils/validators.dart';
import 'custom_text_form_field.dart';

class UsernameTextFieldWidget extends StatefulWidget {
  final Color? fillColor;

  final TextEditingController? controller;

  const UsernameTextFieldWidget({super.key, this.controller, this.fillColor});

  @override
  State<UsernameTextFieldWidget> createState() =>
      _UsernameTextFieldWidgetState();
}

class _UsernameTextFieldWidgetState extends State<UsernameTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      style: AppStyles.robotoBold16SurfaceDark(context),
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validators.required(value),
      controller: widget.controller,
      prefixIcon: SvgPicture.asset(
        AppAssets.bnbProfileIcon,
        fit: BoxFit.scaleDown,
        colorFilter: ColorFilter.mode(AppColors.surfaceDark, BlendMode.srcIn),
      ),
      // prefixIcon: const Icon(size: 30, Icons.person, color: AppColors.black),
      hintText: "username".tr(),
      hintStyle: AppStyles.robotoBold14gray(context),
      filled: true,
      fillColor: widget.fillColor,
    );
  }
}
