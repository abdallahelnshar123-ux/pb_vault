import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/app_styles.dart';
import '../core/utils/validators.dart';
import 'custom_text_form_field.dart';

class ConfPasswordTextFieldWidget extends StatefulWidget {
  final Color? fillColor;
  final TextEditingController? confController;
  final TextEditingController? passwordController;

  const ConfPasswordTextFieldWidget({
    super.key,
    this.passwordController,
    this.fillColor,
    this.confController,
  });

  @override
  State<ConfPasswordTextFieldWidget> createState() =>
      _ConfPasswordTextFieldWidgetState();
}

class _ConfPasswordTextFieldWidgetState
    extends State<ConfPasswordTextFieldWidget> {
  final ValueNotifier<bool> confPassIsObscure = ValueNotifier(true);

  @override
  void dispose() {
    confPassIsObscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: confPassIsObscure,
      builder: (context, value, child) => CustomTextFormField(
        style: AppStyles.robotoBold16SurfaceDark(context),
        keyboardType: TextInputType.visiblePassword,
        validator: (value) =>
            Validators.confirmPassword(value, widget.passwordController!.text),
        controller: widget.confController,
        prefixIcon: SvgPicture.asset(
          "assets/icons/password_icon.svg",
          fit: BoxFit.scaleDown,
          colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
        ),
        hintText: "confirm_password".tr(),
        hintStyle: AppStyles.robotoBold14gray(context),
        filled: true,
        obscureText: value,
        fillColor: widget.fillColor,
        suffixIcon: IconButton(
          isSelected: !value,
          selectedIcon: Icon(Icons.visibility_rounded, color: AppColors.black),
          onPressed: () {
            confPassIsObscure.value = !confPassIsObscure.value;
          },
          icon: Icon(Icons.visibility_off_rounded, color: AppColors.black),
        ),
      ),
    );
  }
}
