import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';

class SnackBarUtils {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
  showSnackBar({required BuildContext context, required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
        content: Text(message, style: AppStyles.robotoRegular14Black(context)),
        backgroundColor: AppColors.whiteColor,
      ),
    );
  }
}
