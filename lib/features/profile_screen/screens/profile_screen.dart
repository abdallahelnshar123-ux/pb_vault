import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pb_vault/core/utils/app_assets.dart';
import 'package:pb_vault/features/auth/cubit/auth_state.dart';
import 'package:pb_vault/widgets/custom_elevated_button.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/screen_size.dart';
import '../../../core/utils/dialog_utils.dart';
import '../../../core/utils/snack_bar_utils.dart';
import '../../../domain/entities/response/auth/auth_providers.dart';
import '../../auth/cubit/auth_view_model.dart';
import '../widgets/language_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().currentUser;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: _builtAppBar(context: context),
      body: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            current is AccountDeleteSuccess ||
            current is AccountDeleteError ||
            current is AccountDeleteLoading,
        listener: (context, state) {
          if (state is AccountDeleteLoading) {
            DialogUtils.showLoading(context: context);
          } else if (state is AccountDeleteSuccess) {
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
          } else if (state is AccountDeleteError) {
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
              _builtAvatar(),
              _builtContainer(
                children: [
                  _buildInfoCard(
                    context,
                    value: user?.name ?? '---',
                    icon: AppAssets.bnbProfileIcon,
                  ),
                  _builtDivider(),
                  _buildInfoCard(
                    context,
                    value: user?.email ?? '---',
                    icon: AppAssets.emailIcon,
                  ),
                ],
              ),
              Text(
                'settings'.tr(),
                style: AppStyles.robotoRegular18Secondary(context),
              ),
              _builtContainer(
                children: [
                  _buildSettingsTile(
                    context,
                    trailing: LanguageWidget(),
                    title: 'language'.tr(),
                    icon: Icons.language,
                  ),
                  _builtDivider(),
                  _buildSettingsTile(
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // todo :  Add theme logic here
                      },
                      activeThumbColor: AppColors.surfaceDark,
                    ),
                    title: 'dark_mode'.tr(),
                    context,
                    icon: Icons.dark_mode,
                  ),
                ],
              ),
              _builtLogoutButton(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _builtAvatar() {
    return const Center(
      child: CircleAvatar(
        radius: 60,
        backgroundColor: AppColors.secondary,
        child: Icon(Icons.person, size: 70, color: AppColors.backgroundDark),
      ),
    );
  }

  Widget _builtDivider() {
    return const Divider(
      color: AppColors.surfaceDark,
      endIndent: 20,
      indent: 20,
    );
  }

  Widget _builtContainer({required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

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
      centerTitle: false,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios_new_rounded),
        color: AppColors.secondary,
      ),
      backgroundColor: AppColors.transparent,
      elevation: 0,
      actionsPadding: EdgeInsets.symmetric(horizontal: 5),
      title: Text(
        'profile'.tr(),
        style: AppStyles.robotoRegular18Secondary(context),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            AppAssets.editIcon,
            colorFilter: ColorFilter.mode(AppColors.secondary, BlendMode.srcIn),
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
          onPressed: () {
            context.read<AuthCubit>().logout(context);
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.authScreen,
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Widget _builtLogoutButton({required BuildContext context}) {
    var currentUser = context.read<AuthCubit>().currentUser;
    return CustomElevatedButton(
      backgroundColor: AppColors.primary,
      onPressed: () async {
        if (currentUser?.provider == AuthProviders.emailPassword) {
          String? password = await DialogUtils.showPasswordDialog(
            context: context,
            message: 'please_enter_password_to_delete_account',
            title: 'confirmation',
          );

          if (password != null && password.isNotEmpty) {
            if (!context.mounted) return;
            context.read<AuthCubit>().deleteAccount(
              context: context,
              password: password,
            );
          }
        } else {
          DialogUtils.showMessage(
            context: context,
            message: 'are_you_sure_you_want_to_delete_the_account',
            title: 'confirmation',
            posAction: () {
              context.read<AuthCubit>().deleteAccount(
                context: context,
                password: "",
              );
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
          Icon(Icons.delete, color: AppColors.surfaceDark, size: 30),
          Text(
            'delete_account'.tr(),
            style: AppStyles.robotoRegular18SurfaceDark(context),
          ),
        ],
      ),
    );
  }
}
