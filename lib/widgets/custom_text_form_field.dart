import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/screen_size.dart';

typedef OnChanged = void Function(String)?;
typedef OnValidator = String? Function(String?)?;
typedef OnFieldSubmitted = void Function(String)?;

class CustomTextFormField extends StatelessWidget {
  final Color? borderSideColor;
  final Color? fillColor;
  final bool? filled;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final TextStyle? errorStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final OnChanged onChanged;
  final OnFieldSubmitted onFieldSubmitted;
  final TextEditingController? controller;
  final OnValidator validator;
  final TextInputType? keyboardType;
  final String obscuringCharacter;
  final bool obscureText;

  const CustomTextFormField({
    super.key,
    this.style,
    this.hintText,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.fillColor,
    this.filled,
    this.borderSideColor,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines,
    this.controller,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.obscuringCharacter = '.',
    this.keyboardType,
    this.errorStyle,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines ?? 1,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      keyboardType: keyboardType,
      style: style,
      cursorColor: AppColors.primary,
      cursorHeight: context.height * 0.04,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),

        filled: filled,
        fillColor: fillColor,
        errorMaxLines: 2,
        errorStyle: errorStyle,
        enabledBorder: builtDecorationBorder(
          borderColor: borderSideColor ?? AppColors.transparent,
        ),
        focusedBorder: builtDecorationBorder(
          borderColor: borderSideColor ?? AppColors.primary,
        ),
        errorBorder: builtDecorationBorder(borderColor: AppColors.error),
        focusedErrorBorder: builtDecorationBorder(borderColor: AppColors.error),
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixIconConstraints: BoxConstraints.tight(
          Size(context.width * 0.1, context.width * 0.06),
        ),
      ),
    );
  }

  OutlineInputBorder builtDecorationBorder({required Color borderColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(width: 2, color: borderColor),
    );
  }
}
