import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';

class SnackBarUtils {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
  showSuccessSnackBar({
    required BuildContext context,
    required String message,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
        content: Text(message, style: AppStyles.robotoRegular14SurfaceDark(context)),
        backgroundColor: AppColors.success,
      ),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
  showErrorSnackBar({required BuildContext context, required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
        content: Text(message, style: AppStyles.robotoRegular14White(context)),
        backgroundColor: AppColors.error,
      ),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
  showInfoSnackBar({required BuildContext context, required String message}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
        content: Text(
          message,
          style: AppStyles.robotoRegular14SurfaceDark(context),
        ),
        backgroundColor: AppColors.secondary,
      ),
    );
  }
}
