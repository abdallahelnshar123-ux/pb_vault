import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pb_vault/core/utils/app_colors.dart';
import 'package:pb_vault/domain/entities/response/platform_account/login_method.dart';
import 'package:pb_vault/widgets/identifier_text_field_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../../../widgets/custom_elevated_button.dart';

class LoginMethodsBottomSheet extends StatefulWidget {
  final ValueChanged<LoginMethod> newLoginMethod;
  final LoginMethod? currentLoginMethod;

  const LoginMethodsBottomSheet({
    super.key,
    this.currentLoginMethod,
    required this.newLoginMethod,
  });

  @override
  State<LoginMethodsBottomSheet> createState() =>
      _LoginMethodsBottomSheetState();
}

class _LoginMethodsBottomSheetState extends State<LoginMethodsBottomSheet> {
  final loginMethodsIcon = AppConstants.loginMethodsIcons;
  final globalKey = GlobalKey<FormState>();
  late final controller = TextEditingController(
    text: widget.currentLoginMethod?.identifier,
  );
  LoginProvider? selectedLoginProvider;
@override
  void initState() {
  selectedLoginProvider =
      widget.currentLoginMethod?.provider ??
          LoginProvider.password;    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.04),
      child: Form(
        key: globalKey,
        child: Column(
          spacing: context.width * 0.04,
          children: [
            DropdownMenuFormField(
              selectOnly: true,
              initialSelection: selectedLoginProvider?.name,
              validator: (value) {
                if (value == null) {
                  return 'you_must_choose_login_provider'.tr();
                }

                return null;
              },
              onSelected: (value) => setState(() {
                selectedLoginProvider = LoginProvider.values.byName(value!);
              }),
              dropdownMenuEntries: LoginProvider.values
                  .map(
                    (loginProvider) => DropdownMenuEntry(
                      value: loginProvider.name,
                      label: loginProvider.name,
                      leadingIcon: CircleAvatar(
                        backgroundColor: AppColors.white,
                        radius: 30,
                        child: SvgPicture.asset(
                          loginMethodsIcon[loginProvider.name]!,
                          fit: .cover,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            Visibility(
              visible: selectedLoginProvider!.requiresEmail,
              child: IdentifierTextFieldWidget(controller: controller),
            ),
            _builtAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _builtAddButton() {
    return Builder(
      builder: (context) {
        return CustomElevatedButton(
          backgroundColor: context.easyColor(
            lColor: AppColors.backgroundDark,
            dColor: AppColors.primary,
          ),
          onPressed: () {
            if (globalKey.currentState!.validate()) {
              widget.newLoginMethod(
                LoginMethod(
                  id : Uuid().v4().toString(),
                  provider: selectedLoginProvider!,
                  identifier: selectedLoginProvider!.requiresEmail
                      ? controller.text.trim()
                      : '',
                ),
              );
              Navigator.pop(context);
            }
          },
          child: Text(
            'add'.tr(),
            style: AppStyles.robotoRegular16White(context),
          ),
        );
      },
    );
  }
}
