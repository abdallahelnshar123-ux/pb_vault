import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
      children: [
        CustomTextFormField(
          onChanged: (value) {
            setState(() {
              codesList = value
                  .trim()
                  .split(RegExp(r'[\s,]+'))
                  .where((e) => e.isNotEmpty)
                  .toList();
            });
          },
          labelText: 'recovery_codes'.tr(),
          labelStyle: AppStyles.robotoBold14gray(context),
          controller: widget.controller,
          maxLines: 3,
          style: AppStyles.robotoBold16SurfaceDark(context),
          filled: true,
          fillColor: AppColors.secondary,
        ),
        ?codesList.isNotEmpty
            ? Wrap(
                children: codesList
                    .map(
                      (code) => Chip(
                        label: Text(code),
                        backgroundColor: AppColors.primary,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                    .toList(),
              )
            : null,
      ],
    );
  }
}
