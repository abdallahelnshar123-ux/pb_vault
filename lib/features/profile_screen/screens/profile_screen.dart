import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pb_vault/core/utils/app_assets.dart';
import 'package:pb_vault/features/auth/cubit/user_state.dart';
import 'package:pb_vault/features/profile_screen/cubit/settings_cubit.dart';
import 'package:pb_vault/features/profile_screen/cubit/settings_state.dart';
import 'package:pb_vault/features/profile_screen/widgets/container_widget.dart';
import 'package:pb_vault/widgets/custom_elevated_button.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/screen_size.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/dialog_utils.dart';
import '../../../core/utils/snack_bar_utils.dart';
import '../../../domain/entities/response/user/auth_providers.dart';
import '../../auth/cubit/user_view_model.dart';
import '../widgets/language_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: _builtAppBar(context: context),
        body: BlocListener<UserCubit, UserState>(
          listenWhen: (previous, current) =>
              current is UserDeleteSuccessState ||
              current is UserDeleteErrorState ||
              current is UserDeleteLoadingState,
          listener: (context, state) {
            if (state is UserDeleteLoadingState) {
              DialogUtils.showLoading(context: context);
            } else if (state is UserDeleteSuccessState) {
              DialogUtils.hideLoading(context: context);
              SnackBarUtils.showSuccessSnackBar(
                context: context,
                message: 'account_deleted_successfully'.tr(),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.authScreen,
                (route) => false,
              );
            } else if (state is UserDeleteErrorState) {
              DialogUtils.hideLoading(context: context);

              SnackBarUtils.showErrorSnackBar(
                context: context,
                message: state.message.tr(),
              );
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.width * 0.05),
            child: Column(
              spacing: context.width * 0.07,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AvatarWidget._(),
                BlocBuilder<UserCubit, UserState>(
                  buildWhen: (previous, current) =>
                      current is UserDetailsUpdateSuccessState,
                  builder: (context, state) {
                    final user = context.read<UserCubit>().currentUser;

                    return ContainerWidget(
                      children: [
                        _buildInfoCard(
                          context,
                          value: user?.name ?? '---',
                          icon: AppAssets.bnbProfileIcon,
                        ),
                        const DividerWidget._(),
                        _buildInfoCard(
                          context,
                          value: user?.email ?? '---',
                          icon: AppAssets.emailIcon,
                        ),
                      ],
                    );
                  },
                ),
                Text(
                  'settings'.tr(),
                  style: AppStyles.robotoRegular18(
                    context,
                    lColor: AppColors.surfaceDark,
                    dColor: AppColors.secondary,
                  ),
                ),
                ContainerWidget(
                  children: [
                    _buildSettingsTile(
                      context,
                      trailing: LanguageWidget(),
                      title: 'language'.tr(),
                      icon: Icons.language,
                    ),
                    const DividerWidget._(),
                    _buildSettingsTile(
                      trailing: Switch(
                        value: context.isDark,
                        onChanged: (value) {
                          value == true
                              ? context.setThemeModeToDark()
                              : context.setThemeModeToLight();
                        },
                        activeThumbColor: AppColors.surfaceDark,
                      ),
                      title: 'dark_mode'.tr(),
                      context,
                      icon: Icons.dark_mode,
                    ),
                    BlocBuilder<SettingsCubit, SettingsState>(
                      buildWhen: (previous, current) =>
                          previous.isBiometricEnabled !=
                              current.isBiometricEnabled ||
                          previous.isBiometricSupported !=
                              current.isBiometricSupported,
                      builder: (context, state) {
                        return Visibility(
                          visible: state.isBiometricSupported,
                          child: Column(
                            children: [
                              const DividerWidget._(),
                              _buildSettingsTile(
                                trailing: Switch(
                                  value: state.isBiometricEnabled,
                                  onChanged: (value) {
                                    context
                                        .read<SettingsCubit>()
                                        .toggleBiometric(value);
                                  },
                                  activeThumbColor: AppColors.surfaceDark,
                                ),
                                title: 'biometric_unlock'.tr(),
                                context,
                                icon: Icons.fingerprint_rounded,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                _builtDeleteAccountButton(context: context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _builtContainer({
  //   required BuildContext context,
  //   required List<Widget> children,
  // }) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 10),
  //     decoration: BoxDecoration(
  //       color: context.easyColor(
  //         lColor: AppColors.primary,
  //         dColor: AppColors.backgroundLight,
  //       ),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Column(children: children),
  //   );
  // }

  Widget _buildInfoCard(
    BuildContext context, {
    required String value,
    required String icon,
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        icon,
        fit: BoxFit.scaleDown,
        colorFilter: ColorFilter.mode(AppColors.surfaceDark, BlendMode.srcIn),
      ),
      title: Text(value),
      titleTextStyle: AppStyles.robotoBold16SurfaceDark(context),
      subtitle: null,
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.surfaceDark),
      title: Text(title),
      titleTextStyle: AppStyles.robotoBold16SurfaceDark(context),
      trailing: trailing,
    );
  }

  PreferredSizeWidget _builtAppBar({required BuildContext context}) {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios_new_rounded),
      ),
      elevation: 0,
      actionsPadding: EdgeInsets.symmetric(horizontal: 5),
      title: Text('profile'.tr()),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            AppAssets.editIcon,
            colorFilter: ColorFilter.mode(
              context.easyColor(
                lColor: AppColors.surfaceDark,
                dColor: AppColors.secondary,
              ),
              BlendMode.srcIn,
            ),
            fit: .cover,
            height: 25,
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.editProfileScreen);
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            AppAssets.logoutIcon,
            colorFilter: ColorFilter.mode(AppColors.error, BlendMode.srcIn),
            fit: .cover,
            height: 25,
          ),
          onPressed: () async {
            await context.read<UserCubit>().logout();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.authScreen,
                (route) => false,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _builtDeleteAccountButton({required BuildContext context}) {
    var currentUser = context.read<UserCubit>().currentUser;
    return CustomElevatedButton(
      backgroundColor: context.easyColor(
        lColor: AppColors.backgroundDark,
        dColor: AppColors.primary,
      ),
      onPressed: () async {
        if (currentUser?.provider == AuthProviders.emailPassword) {
          String? password = await DialogUtils.showPasswordDialog(
            context: context,
            message: 'please_enter_password_to_delete_account',
            title: 'confirmation',
          );

          if (password != null && password.isNotEmpty) {
            if (!context.mounted) return;
            context.read<UserCubit>().deleteUser(password: password);
          }
        } else {
          DialogUtils.showMessage(
            context: context,
            message: 'are_you_sure_you_want_to_delete_the_account',
            title: 'confirmation',
            posAction: () {
              context.read<UserCubit>().deleteUser(password: "");
            },
            posActionText: 'yes',
            negActionText: 'no',
          );
        }
      },
      child: Row(
        spacing: 10,
        mainAxisAlignment: .center,
        children: [
          Icon(
            Icons.delete,
            color: context.easyColor(
              lColor: AppColors.backgroundLight,
              dColor: AppColors.surfaceDark,
            ),
            size: 30,
          ),
          Text(
            'delete_account'.tr(),
            style: AppStyles.robotoRegular18(
              context,
              lColor: AppColors.backgroundLight,
              dColor: AppColors.surfaceDark,
            ),
          ),
        ],
      ),
    );
  }
}

class DividerWidget extends StatelessWidget {
  const DividerWidget._();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.surfaceDark,
      endIndent: 20,
      indent: 20,
    );
  }
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget._();

  @override
  Widget build(BuildContext context) {
    var currentAvatar = context.watch<UserCubit>().currentUser?.avatar;
    var avatars = AppConstants.userAvatars;
    return (currentAvatar == null ||
            currentAvatar.isEmpty ||
            avatars[currentAvatar] == null)
        ? Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: context.easyColor(
                lColor: AppColors.primary,
                dColor: AppColors.backgroundLight,
              ),
              child: Icon(
                Icons.person,
                size: 70,
                color: AppColors.backgroundDark,
              ),
            ),
          )
        : CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.primary,
            child: SvgPicture.asset(avatars[currentAvatar]!),
          );
  }
}
