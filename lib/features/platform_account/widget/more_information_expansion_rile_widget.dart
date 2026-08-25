import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:pb_vault/features/platform_account/widget/recovery_codes_widget.dart';
import 'package:pb_vault/features/platform_account/widget/text_field_container_widget.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../../../widgets/custom_text_form_field.dart';

class Moreinformationexpansiontilewidget extends StatelessWidget {
  const Moreinformationexpansiontilewidget({
    super.key,
    required this.notesController,
    required this.passkeyController,
    required this.recoveryCodesController,
  });

  final TextEditingController notesController;
  final TextEditingController recoveryCodesController;
  final TextEditingController passkeyController;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'more_information'.tr(),
        style: AppStyles.robotoRegular14(
          context,
          lColor: AppColors.surfaceDark,
          dColor: AppColors.secondary,
        ),
      ),
      splashColor: AppColors.transparent,
      collapsedIconColor: context.easyColor(
        lColor: AppColors.backgroundDark,
        dColor: AppColors.backgroundLight,
      ),
      tilePadding: EdgeInsets.zero,
      shape: Border.all(width: 0, color: AppColors.transparent),
      maintainState: true,
      collapsedShape: Border.all(width: 0, color: AppColors.transparent),
      iconColor: context.easyColor(
        lColor: AppColors.backgroundDark,
        dColor: AppColors.backgroundLight,
      ),
      children: [
        TextFieldContainerWidget(
          text: 'notes'.tr(),
          style: AppStyles.robotoRegular12SurfaceDark(context),
          child: CustomTextFormField(
            controller: notesController,
            // hintText: 'notes'.tr(),
            maxLines: 3,
            // hintStyle: AppStyles.robotoBold14gray(context),
            style: AppStyles.robotoBold16SurfaceDark(context),
            filled: true,
            fillColor: AppColors.secondary,
          ),
        ),
        SizedBox(height: context.height * 0.02),
        RecoveryCodesWidget(controller: recoveryCodesController),
        SizedBox(height: context.height * 0.02),
        TextFieldContainerWidget(
          text: 'pass_key'.tr(),
          style: AppStyles.robotoRegular12SurfaceDark(context),
          child: CustomTextFormField(
            // labelText: 'pass_key'.tr(),
            // labelStyle: AppStyles.robotoBold14gray(context),
            controller: passkeyController,
            style: AppStyles.robotoBold16SurfaceDark(context),
            filled: true,
            fillColor: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
