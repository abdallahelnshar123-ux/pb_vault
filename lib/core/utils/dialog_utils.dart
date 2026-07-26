import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pb_vault/widgets/password_text_field_widget.dart';

import 'app_colors.dart';
import 'app_styles.dart';

class DialogUtils {
  static void showLoading({required BuildContext context}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.transparent,
        contentPadding: EdgeInsets.all(20),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            CircularProgressIndicator(color: AppColors.backgroundDark),
          ],
        ),
      ),
    );
  }

  static void hideLoading({required BuildContext context}) {
    Navigator.pop(context);
  }

  static void showMessage({
    required BuildContext context,
    String title = '',
    required String message,
    String? posActionText,
    VoidCallback? posAction,
    String? negActionText,
    VoidCallback? negAction,
  }) {
    List<Widget> actions = [];
    if (posActionText != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();
          },
          child: Text(
            context.tr(posActionText),
            style: AppStyles.robotoRegular16(
              context,
              lColor: AppColors.surfaceDark,
              dColor: AppColors.white,
            ),
          ),
        ),
      );
    }
    if (negActionText != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            negAction?.call();
          },
          child: Text(
            context.tr(negActionText),
            style: AppStyles.robotoRegular16(
              context,
              lColor: AppColors.surfaceDark,
              dColor: AppColors.white,
            ),
          ),
        ),
      );
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(20),
        content: Text(
          context.tr(message),
          style: AppStyles.robotoRegular14(
            context,
            lColor: AppColors.surfaceDark,
            dColor: AppColors.white,
          ),
        ),
        title: Text(
          context.tr(title),
          style: AppStyles.robotoRegular14(
            context,
            lColor: AppColors.surfaceDark,
            dColor: AppColors.white,
          ),
        ),
        actions: actions,
      ),
    );
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Future<String?> showPasswordDialog({
    required BuildContext context,
    String title = '',
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    TextEditingController passwordController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          title: Text(
            context.tr(title),
            style: AppStyles.robotoRegular16(
              context,
              lColor: AppColors.surfaceDark,
              dColor: AppColors.white,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.tr(message),
                  style: AppStyles.robotoRegular14(
                    context,
                    lColor: AppColors.surfaceDark,
                    dColor: AppColors.white,
                  ),
                ),
                PasswordTextFieldWidget(
                  controller: passwordController,
                  fillColor: AppColors.secondary,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                context.tr(cancelText),
                style: AppStyles.robotoRegular16(
                  context,
                  lColor: AppColors.surfaceDark,
                  dColor: AppColors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, passwordController.text.trim());
                }
              },
              child: Text(
                context.tr(confirmText),
                style: AppStyles.robotoRegular16(
                  context,
                  lColor: AppColors.surfaceDark,
                  dColor: AppColors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
