import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:pb_vault/features/auth/widget/login_tab.dart';
import 'package:pb_vault/features/auth/widget/register_tab.dart';

import '../../../../../../../core/utils/app_colors.dart';
import '../../../../../../../core/utils/app_styles.dart';

class SectionSwitcher extends StatelessWidget {
  const SectionSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            overlayColor: WidgetStatePropertyAll(
              context.easyColor(
                lColor: AppColors.backgroundLight,
                dColor: AppColors.backgroundDark,
              ),
            ),
            indicatorWeight: 3,
            labelStyle: AppStyles.robotoRegular14White(context),
            labelColor: context.easyColor(
              lColor: AppColors.backgroundDark,
              dColor: AppColors.white,
            ),

            unselectedLabelColor: AppColors.primary,
            dividerColor: AppColors.backgroundDark,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: context.easyColor(
              lColor: AppColors.backgroundDark,
              dColor: AppColors.white,
            ),
            tabs: [
              Tab(text: 'login'.tr()),
              Tab(text: 'register'.tr()),
            ],
          ),
          Expanded(child: TabBarView(children: [LoginTan(), RegisterTab()])),
        ],
      ),
    );
  }
}
