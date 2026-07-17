import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/core/utils/app_colors.dart';
import 'package:pb_vault/core/utils/app_styles.dart';
import 'package:pb_vault/features/profile_screen/cubit/settings_cubit.dart';

import '../cubit/settings_state.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsCubit = context.read<SettingsCubit>();
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) => previous.locale != current.locale,
      listener: (context, state) async {
        await context.setLocale(state.locale);
      },
      child: PopupMenuButton(
        style: ButtonStyle(alignment: AlignmentDirectional.centerEnd),
        onSelected: (value) {
          if (context.locale.languageCode == value) return;
          settingsCubit.changeLanguage(newLocale: Locale(value));
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
      ),
    );
  }
}
