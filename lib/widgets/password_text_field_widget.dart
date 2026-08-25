import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/app_styles.dart';
import 'custom_text_form_field.dart';

class PasswordTextFieldWidget extends StatefulWidget {
  final Color? fillColor;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const PasswordTextFieldWidget({
    super.key,
    this.fillColor,
    this.onChanged,
    this.controller,
  });

  @override
  State<PasswordTextFieldWidget> createState() =>
      _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  final ValueNotifier<bool> isObscure = ValueNotifier(true);

  @override
  void dispose() {
    isObscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isObscure,
      builder: (context, value, child) => CustomTextFormField(
        style: AppStyles.robotoBold16SurfaceDark(context),
        onChanged: widget.onChanged,
        keyboardType: TextInputType.visiblePassword,
        controller: widget.controller,
        prefixIcon: SvgPicture.asset(
          "assets/icons/password_icon.svg",
          fit: BoxFit.scaleDown,
          colorFilter: ColorFilter.mode(AppColors.surfaceDark, BlendMode.srcIn),
        ),
        hintText: "password".tr(),
        hintStyle: AppStyles.robotoBold14gray(context),
        filled: true,
        obscureText: value,
        fillColor: widget.fillColor,
        suffixIcon: IconButton(
          isSelected: !value,
          selectedIcon: Icon(
            Icons.visibility_rounded,
            color: AppColors.surfaceDark,
          ),
          onPressed: () {
            isObscure.value = !isObscure.value;
          },
          icon: Icon(Icons.visibility_off_rounded, color: AppColors.black),
        ),
      ),
    );
  }
}
