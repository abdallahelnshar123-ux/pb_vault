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

class LoginMethodsWidget extends StatefulWidget {
  const LoginMethodsWidget({super.key, required this.newLoginMethod});

  final ValueChanged<List<LoginMethod>> newLoginMethod;

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
        InkWell(
          splashColor: context.easyColor(
            lColor: AppColors.surfaceDark,
            dColor: AppColors.primary,
          ),
          onTap: () {
            _showLoginMethodsBottomSheet(context);
          },
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'login_methods'.tr(),
                style: AppStyles.robotoRegular14(
                  context,
                  lColor: AppColors.surfaceDark,
                  dColor: AppColors.backgroundLight,
                ),
              ),
              Icon(
                Icons.add,
                size: context.width * 0.07,
                color: context.easyColor(
                  lColor: AppColors.surfaceDark,
                  dColor: AppColors.backgroundLight,
                ),
              ),
            ],
          ),
        ),

        Column(children: _buildLoginMethodsList(context)),
        // _builtAddButton(),
      ],
    );
  }

  List<ListTile> _buildLoginMethodsList(BuildContext context) {
    return loginMethodList
        .map(
          (loginMethod) => ListTile(
            trailing: Row(
              spacing: 10,
              mainAxisSize: .min,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    tapTargetSize: .shrinkWrap,
                    iconSize: context.width * 0.04,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    final id = loginMethod.id;
                    _showLoginMethodsBottomSheet(context, id: id);
                  },
                  icon: Icon(Icons.edit, color: AppColors.success),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    tapTargetSize: .shrinkWrap,
                    iconSize: context.width * 0.04,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    final id = loginMethod.id;

                    setState(() {
                      loginMethodList.remove(
                        loginMethodList
                            .where((element) => element.id == id)
                            .first,
                      );
                    });
                  },
                  icon: Icon(Icons.delete, color: AppColors.error),
                ),
              ],
            ),
            splashColor: AppColors.transparent,
            contentPadding: EdgeInsets.zero,

            title: Text(
              loginMethod.provider.name,
              style: AppStyles.robotoRegular14(
                context,
                lColor: AppColors.backgroundDark,
                dColor: AppColors.secondary,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.white,
              radius: context.width * 0.04,
              child: SvgPicture.asset(
                loginMethodsIcon[loginMethod.provider.name] ?? '',
                fit: .cover,
                width: context.width * 0.05,
                colorFilter: loginMethod.provider == LoginProvider.password
                    ? ColorFilter.mode(AppColors.black, .srcIn)
                    : null,
              ),
            ),
            subtitle: loginMethod.identifier != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      loginMethod.identifier!,
                      style: AppStyles.robotoRegular10(
                        context,
                        lColor: AppColors.backgroundDark,
                        dColor: AppColors.secondary,
                      ).copyWith(color: AppColors.success),
                    ),
                  )
                : null,
          ),
        )
        .toList();
  }

  void _showLoginMethodsBottomSheet(BuildContext context, {String? id}) {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      showDragHandle: true,
      useSafeArea: true,
      enableDrag: false,
      isScrollControlled: true,

      constraints: BoxConstraints.expand(
        width: context.width,
        height: context.height * 0.6,
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
        currentLoginMethod: id != null
            ? loginMethodList.where((element) => element.id == id).first
            : null,
        newLoginMethod: (LoginMethod value) {
          setState(() {
            loginMethodList.add(value);
            widget.newLoginMethod(loginMethodList);
          });
        },
      ),
    );
  }
}
