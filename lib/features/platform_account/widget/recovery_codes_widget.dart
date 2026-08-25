import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pb_vault/features/platform_account/widget/text_field_container_widget.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../widgets/custom_text_form_field.dart';

class RecoveryCodesWidget extends StatefulWidget {
  final TextEditingController controller;

  const RecoveryCodesWidget({super.key, required this.controller});

  @override
  State<RecoveryCodesWidget> createState() => _RecoveryCodesWidgetState();
}

class _RecoveryCodesWidgetState extends State<RecoveryCodesWidget> {
  List<String> codesList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 20,
      children: [
        TextFieldContainerWidget(
          text: 'recovery_codes'.tr(),
          style: AppStyles.robotoRegular12SurfaceDark(context),
          child: CustomTextFormField(
            onChanged: (value) {
              setState(() {
                codesList = value
                    .trim()
                    .split(RegExp(r'[\s,]+'))
                    .where((e) => e.isNotEmpty)
                    .toList();
              });
            },
            // labelText: 'recovery_codes'.tr(),
            // labelStyle: AppStyles.robotoBold14gray(context),
            controller: widget.controller,
            maxLines: 3,
            style: AppStyles.robotoBold16SurfaceDark(context),
            filled: true,
            fillColor: AppColors.secondary,
          ),
        ),
        ?codesList.isNotEmpty
            ? GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 1.3,
                  crossAxisSpacing: 10,
                ),

                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: codesList
                    .map(
                      (code) => Chip(
                        label: FittedBox(fit: .scaleDown, child: Text(code)),
                        labelStyle: AppStyles.robotoRegular12SurfaceDark(
                          context,
                        ),
                        backgroundColor: AppColors.primary,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                    .toList(),
              )
            // Wrap(
            //         crossAxisAlignment: WrapCrossAlignment.start,
            //         runAlignment: WrapAlignment.spaceBetween,
            //         spacing: 20,
            //         children: codesList
            //             .map(
            //               (code) => Chip(
            //                 label: Text(code),
            //                 labelStyle:AppStyles.robotoRegular12SurfaceDark(context),
            //                 backgroundColor: AppColors.primary,
            //                 shape: BeveledRectangleBorder(
            //                   borderRadius: BorderRadius.circular(8),
            //                 ),
            //               ),
            //             )
            //             .toList(),
            //       )
            : null,
      ],
    );
  }
}
