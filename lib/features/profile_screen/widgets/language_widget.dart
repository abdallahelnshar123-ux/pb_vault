import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pb_vault/core/utils/app_colors.dart';
import 'package:pb_vault/core/utils/app_styles.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      style: ButtonStyle(alignment: AlignmentDirectional.centerEnd),
      onSelected: (value) {
        if (context.locale.languageCode == value) return;
        context.setLocale(Locale(value));
        Intl.defaultLocale = value;
      },
      iconSize: 28,
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.change_circle_outlined,
        size: 30,
        color: AppColors.surfaceDark,
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'en',
          child: Text(
            context.tr('english'),
            style: AppStyles.robotoRegular14Secondary(context),
          ),
        ),
        PopupMenuItem(
          value: 'ar',
          child: Text(
            context.tr('arabic'),
            style: AppStyles.robotoRegular14Secondary(context),
          ),
        ),
      ],
    );
  }
}
