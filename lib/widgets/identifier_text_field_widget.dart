import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/app_styles.dart';
import '../core/utils/validators.dart';
import 'custom_text_form_field.dart';

class IdentifierTextFieldWidget extends StatefulWidget {
  final Color? fillColor;

  final TextEditingController? controller;

  const IdentifierTextFieldWidget({super.key, this.controller, this.fillColor});

  @override
  State<IdentifierTextFieldWidget> createState() => _EmailTextFieldWidgetState();
}

class _EmailTextFieldWidgetState extends State<IdentifierTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      style: AppStyles.robotoBold16SurfaceDark(context),
      keyboardType: TextInputType.emailAddress,
      controller: widget.controller,
      prefixIcon: SvgPicture.asset(
        "assets/icons/email-icon.svg",
        fit: BoxFit.scaleDown,
        colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
      ),
      hintText: "email".tr(),
      hintStyle: AppStyles.robotoBold14gray(context),
      filled: true,
      fillColor: widget.fillColor,
    );
  }
}
