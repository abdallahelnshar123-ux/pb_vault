import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/app_styles.dart';
import 'custom_text_form_field.dart';

class SearchTextFieldWidget extends StatelessWidget {
  final void Function(String)? onChanged;
  final Widget? suffixIcon;

  const SearchTextFieldWidget({super.key, this.onChanged, this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      suffixIcon: suffixIcon,
      onChanged: onChanged,
      style: AppStyles.robotoBold16SurfaceDark(context),
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icon(
        Icons.search_rounded,
        color: AppColors.surfaceDark,
        size: 30,
      ),
      hintText: "search".tr(),
      hintStyle: AppStyles.robotoBold14gray(context),
      filled: true,
      fillColor: AppColors.secondary,
    );
  }
}
