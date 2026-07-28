import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pb_vault/core/constants/app_constants.dart';
import 'package:pb_vault/domain/entities/response/platform_account/login_method.dart';
import 'package:pb_vault/features/platform_account/widget/login_methods_bottom_sheet.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../../../widgets/custom_elevated_button.dart';

class LoginMethodsWidget extends StatefulWidget {
  const LoginMethodsWidget({super.key});

  @override
  State<LoginMethodsWidget> createState() => _LoginMethodsWidgetState();
}

class _LoginMethodsWidgetState extends State<LoginMethodsWidget> {
  List<LoginMethod> loginMethodList = [];

  final loginMethodsIcon = AppConstants.loginMethodsIcons;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(children: _buildLoginMethodsList(context)),
        _builtAddButton(),
      ],
    );
  }

  List<ListTile> _buildLoginMethodsList(BuildContext context) {
    return loginMethodList
        .map(
          (loginMethod) => ListTile(
            splashColor: AppColors.transparent,
            contentPadding: EdgeInsets.zero,

            title: Text(
              loginMethod.provider.name,
              style: AppStyles.robotoRegular18(
                context,
                lColor: AppColors.backgroundDark,
                dColor: AppColors.secondary,
              ),
            ),
            leading: CircleAvatar(

              backgroundColor: AppColors.white,
              radius: context.width * 0.07,
              child: SvgPicture.asset(

                loginMethodsIcon[loginMethod.provider.name] ?? '',
                fit: .fitWidth,
              ),
            ),
            subtitle: loginMethod.identifier != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      loginMethod.identifier!,
                      style: AppStyles.robotoRegular12Secondary(
                        context,
                      ).copyWith(color: AppColors.success),
                    ),
                  )
                : null,
          ),
        )
        .toList();
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
            _showLoginMethodsBottomSheet(context);
          },

          child: Text(
            'add'.tr(),
            style: AppStyles.robotoRegular16White(context),
          ),
        );
      },
    );
  }

  void _showLoginMethodsBottomSheet(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      showDragHandle: true,
      useSafeArea: true,
      enableDrag: false,
      isScrollControlled: true,
      constraints: BoxConstraints.tight(
        Size(double.infinity, context.height - 150),
      ),
      backgroundColor: context.easyColor(
        lColor: AppColors.primary,
        dColor: AppColors.backgroundDark,
      ),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => LoginMethodsBottomSheet(
        newLoginMethod: (LoginMethod value) {
          setState(() {
            loginMethodList.add(value);
          });
        },
      ),
    );
  }
}
