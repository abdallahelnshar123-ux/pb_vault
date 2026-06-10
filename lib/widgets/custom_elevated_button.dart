import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/screen_size.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color backgroundColor;
  final Color? borderSideColor;
  final double? buttonWidth;
  final Widget child;
  final double? borderRadius;
  final void Function()? onPressed;

  const CustomElevatedButton({
    super.key,
    required this.child,
    this.buttonWidth,
    this.borderRadius,
    required this.backgroundColor,
    this.borderSideColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(buttonWidth ?? 0, 0),
        side: BorderSide(color: borderSideColor ?? AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 15),
        ),
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(
          vertical: context.height * 0.015,
          horizontal: context.height * 0.02,
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
