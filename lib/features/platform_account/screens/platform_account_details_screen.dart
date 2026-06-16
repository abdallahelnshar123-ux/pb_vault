import 'package:cryptography/cryptography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pb_vault/core/services/vault_crypto_service/vault_crypto_service.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';
import 'package:pb_vault/features/platform_account/cubit/platform_account_state.dart';
import 'package:pb_vault/widgets/copy_account_password_button_widget.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../core/di/di.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/snack_bar_utils.dart';
import '../../../domain/entities/response/platform_account/platform_account.dart';
import '../../auth/cubit/user_view_model.dart';
import '../cubit/platform_account_view_model.dart';
import 'edit_platform_account_screen.dart';

class PlatformAccountDetailsScreen extends StatefulWidget {
  const PlatformAccountDetailsScreen({super.key, required this.account});

  final PlatformAccount account;

  @override
  State<PlatformAccountDetailsScreen> createState() =>
      _PlatformAccountDetailsScreenState();
}

class _PlatformAccountDetailsScreenState
    extends State<PlatformAccountDetailsScreen> {
  final ValueNotifier<bool> isObscure = ValueNotifier(true);
  late final String unEncryptedPassword;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      unEncryptedPassword = await getIt<VaultCryptoService>().decryptPassword(
        mac: Mac(widget.account.mac),
        cipherText: widget.account.encryptedPassword,
        nonce: widget.account.nonce,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    isObscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserCubit>().currentUser!;

    return BlocListener<PlatformAccountCubit, PlatformAccountState>(
      listener: (context, state) {
        if (state is DeletePlatformAccountLoadingState) {
          DialogUtils.showLoading(context: context);
        } else if (state is DeletePlatformAccountSuccessState) {
          DialogUtils.hideLoading(context: context);
          Navigator.pop(context);
          SnackBarUtils.showSuccessSnackBar(
            context: context,
            message: 'account_deleted_successfully'.tr(),
          );
        } else if (state is DeletePlatformAccountErrorState) {
          Navigator.pop(context);
          DialogUtils.showMessage(context: context, message: state.message);
        }
      },
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          backgroundColor: AppColors.backgroundDark,
          appBar: _builtAppBar(context: context, currentUser: currentUser),
          body: Container(
            margin: EdgeInsets.all(16),
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.secondary,
            ),
            child: SingleChildScrollView(
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _builtPlatformIcon(),
                  Text(
                    widget.account.platform.name,
                    style: AppStyles.robotoBlack20SurfaceDark(context),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      spacing: 15,
                      mainAxisSize: .min,
                      children: [
                        _buildInfoTile(
                          context,
                          title: 'user_name-email_address'.tr(),
                          icon: Icons.email_outlined,
                          value: widget.account.emailOrUsername,
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: isObscure,
                          builder: (context, value, child) {
                            return _buildInfoTile(
                              value: value ? '******' : unEncryptedPassword,
                              context,
                              title: 'password'.tr(),
                              icon: Icons.lock_outline,
                              trailing: _builtPasswordButtons(value: value),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'details'.tr(),
                        style: AppStyles.robotoRegular18SurfaceDark(context),
                      ),
                      _buildDetailsCard(
                        context,
                        title: 'website_address'.tr(),
                        subTitle: widget.account.platform.website,
                      ),
                      _buildDetailsCard(
                        context,
                        title: 'notes'.tr(),
                        subTitle:
                            widget.account.notes == null ||
                                widget.account.notes!.isEmpty
                            ? 'no_notes'.tr()
                            : widget.account.notes!,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _builtAppBar({
    required BuildContext context,
    required MyUser currentUser,
  }) {
    return AppBar(
      toolbarHeight: 90,
      automaticallyImplyLeading: false,
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.secondary,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              color: AppColors.surfaceDark,
            ),
            Text(
              'account_details'.tr(),
              style: AppStyles.robotoRegular18SurfaceDark(context),
            ),
            Spacer(),
            IconButton(
              icon: SvgPicture.asset(
                AppAssets.editIcon,
                colorFilter: ColorFilter.mode(
                  AppColors.surfaceDark,
                  BlendMode.srcIn,
                ),
                fit: .cover,
                height: 25,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditPlatformAccountScreen(account: widget.account),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 30,
              ),
              onPressed: () async {
                DialogUtils.showMessage(
                  context: context,
                  message: 'are_you_sure_you_want_to_delete_account',
                  posActionText: 'yes',
                  negActionText: 'no',
                  posAction: () {
                    context.read<PlatformAccountCubit>().deletePlatformAccount(
                      userId: currentUser.id,
                      accountId: widget.account.id!,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _builtPlatformIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        shape: BoxShape.circle,
      ),
      child: Image.network(
        widget.account.platform.icon,
        width: 80,
        height: 80,
        errorBuilder: (_, _, _) =>
            const Icon(Icons.public, size: 80, color: AppColors.primary),
      ),
    );
  }

  Widget _builtPasswordButtons({required bool value}) {
    return Row(
      mainAxisAlignment: .end,
      mainAxisSize: .min,
      children: [
        CopyAccountPasswordButtonWidget(
          account: widget.account,
          iconColor: AppColors.secondary,
        ),
        IconButton(
          visualDensity: .compact,
          isSelected: !value,
          selectedIcon: Icon(
            Icons.visibility_rounded,
            color: AppColors.secondary,
          ),
          onPressed: () {
            isObscure.value = !isObscure.value;
          },
          icon: Icon(Icons.visibility_off_rounded, color: AppColors.secondary),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    Widget? trailing,
  }) {
    return Column(
      spacing: 0,
      crossAxisAlignment: .start,
      children: [
        Text(title, style: AppStyles.robotoRegular12Primary(context)),
        ListTile(
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: AppColors.secondary),
          title: Text(value),
          titleTextStyle: AppStyles.robotoBold16Secondary(context),
          trailing: trailing,
        ),
      ],
    );
  }

  Widget _buildDetailsCard(
    BuildContext context, {
    required String title,
    required String subTitle,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subTitle),
      titleTextStyle: AppStyles.robotoRegular12SurfaceDark(context),
      subtitleTextStyle: AppStyles.robotoBold16SurfaceDark(context),
      trailing: trailing,
    );
  }
}
