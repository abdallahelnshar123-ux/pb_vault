import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/screen_size.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color backgroundColor;
  final Color? borderSideColor;
  final Widget child;
  final void Function() onPressed;

  const CustomElevatedButton({
    super.key,
    required this.child,
    required this.backgroundColor,
    this.borderSideColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 0),
        side: BorderSide(color: borderSideColor ?? AppColors.transparentColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: context.height * 0.015),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
