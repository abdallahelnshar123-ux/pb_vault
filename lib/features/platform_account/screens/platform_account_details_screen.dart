import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pb_vault/core/constants/app_constants.dart';
import 'package:pb_vault/domain/entities/response/platform_account/login_method.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/features/platform_account/cubit/platform_account_state.dart';
import 'package:pb_vault/widgets/copy_account_password_button_widget.dart';
import 'package:pb_vault/widgets/main_error_widget.dart';
import 'package:pb_vault/widgets/main_loading_widget.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/screen_size.dart';
import '../../../core/utils/snack_bar_utils.dart';
import '../../auth/cubit/user_view_model.dart';
import '../cubit/platform_account_view_model.dart';
import 'edit_platform_account_screen.dart';

class PlatformAccountDetailsScreen extends StatefulWidget {
  const PlatformAccountDetailsScreen({super.key});

  // final PlatformAccount account;

  @override
  State<PlatformAccountDetailsScreen> createState() =>
      _PlatformAccountDetailsScreenState();
}

class _PlatformAccountDetailsScreenState
    extends State<PlatformAccountDetailsScreen> {
  final ValueNotifier<bool> isObscure = ValueNotifier(true);

  // String plainPassword = '';

  // late final currentUser = context.read<UserCubit>().currentUser!;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   if (widget.account.password != null) {
    //     final encryptedData = EncryptedData(
    //       cipherText: widget.account.password!.cipherText,
    //       mac: widget.account.password!.mac,
    //       nonce: widget.account.password!.nonce,
    //     );
    //     final result = await getIt<DecryptPasswordUseCase>().invoke(
    //       encryptedData,
    //     );
    //     if (mounted) {
    //       result.fold((failure) {}, (password) {
    //         setState(() {
    //           plainPassword = password;
    //         });
    //       });
    //     }
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    isObscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlatformAccountCubit, PlatformAccountState>(
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
        // else if (state is GetPlatformAccountLoadingState) {
        //   DialogUtils.showLoading(context: context);
        // } else if (state is GetPlatformAccountSuccessState) {
        //   DialogUtils.hideLoading(context: context);
        // } else if (state is GetPlatformAccountErrorState) {
        //   DialogUtils.hideLoading(context: context);
        //   DialogUtils.showMessage(
        //     context: context,
        //     message: state.message,
        //     title: 'error',
        //     posAction: () {
        //       Navigator.pop(context);
        //     },
        //     posActionText: 'ok',
        //   );
        // }
      },
      buildWhen: (previous, current) =>
          current is GetPlatformAccountLoadingState ||
          current is GetPlatformAccountSuccessState ||
          current is GetPlatformAccountErrorState,
      builder: (BuildContext context, PlatformAccountState state) {
        if (state is GetPlatformAccountSuccessState) {
          return SafeArea(
            top: false,
            bottom: true,
            child: Scaffold(
              // backgroundColor: AppColors.backgroundDark,
              appBar: _builtAppBar(context: context, account: state.account),
              body: Container(
                margin: EdgeInsets.all(16),
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: context.easyColor(
                    lColor: AppColors.primary,
                    dColor: AppColors.secondary,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _builtPlatformIcon(account: state.account),
                      Text(
                        state.account.platform.name,
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
                          crossAxisAlignment: .start,
                          spacing: 15,
                          mainAxisSize: .min,
                          children: [
                            _buildInfoTile(
                              context,
                              title: 'email_username_phone'.tr(),
                              icon: Icons.email_outlined,
                              value: state.account.identifier,
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: isObscure,
                              builder: (context, value, child) {
                                return _buildInfoTile(
                                  value:
                                      state.account.password?.isNotEmpty ??
                                          false
                                      ? value
                                            ? '******'
                                            : state.account.password!
                                      : '-',
                                  context,
                                  title: 'password'.tr(),
                                  icon: Icons.lock_outline,
                                  trailing: _builtPasswordButtons(
                                    value: value,
                                    account: state.account,
                                  ),
                                );
                              },
                            ),

                            _buildLoginMethodsList(
                              context: context,
                              loginMethodList: state.account.loginMethods,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            'details'.tr(),
                            style: AppStyles.robotoRegular18SurfaceDark(
                              context,
                            ),
                          ),
                          _buildDetailsCard(
                            context,
                            title: 'website_address'.tr(),
                            subTitle: state.account.platform.website,
                          ),
                          _buildDetailsCard(
                            context,
                            title: 'notes'.tr(),
                            subTitle: state.account.notes == null
                                ? '-'
                                : state
                                      .account
                                      .notes!, // Placeholder since it's encrypted now
                          ),
                          _buildDetailsCard(
                            context,
                            title: 'recovery_codes'.tr(),
                            subTitle: state.account.recoveryCodes == null
                                ? '-'
                                : state
                                      .account
                                      .recoveryCodes!, // Placeholder since it's encrypted now
                          ),
                          _buildDetailsCard(
                            context,
                            title: 'pass_key'.tr(),
                            subTitle: state.account.passkey == null
                                ? '-'
                                : state
                                      .account
                                      .passkey!, // Placeholder since it's encrypted now
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (state is GetPlatformAccountErrorState) {
          return MainErrorWidget(
            errorMessage: state.message,
            onPressed: () {},
            widgetHeight: double.infinity,
          );
        }
        return Scaffold(body: MainLoadingWidget());
      },
    );
  }

  Widget _buildLoginMethodsList({
    required BuildContext context,
    required List<LoginMethod> loginMethodList,
  }) {
    var loginMethodsIcon = AppConstants.loginMethodsIcons;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Text(
          'login_methods'.tr(),
          style: AppStyles.robotoRegular12Primary(context),
        ),
        ...loginMethodList.map(
          (loginMethod) => ListTile(
            minVerticalPadding: 0,
            dense: false,
            visualDensity: .compact,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadiusGeometry.circular(8)
            // ),
            // selected: true,
            // selectedTileColor: AppColors.primary,
            splashColor: AppColors.transparent,
            contentPadding: EdgeInsets.zero,

            title: Text(
              loginMethod.provider.name,
              style: AppStyles.robotoRegular12Secondary(context),
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.white,
              radius: context.width * 0.03,
              child: SvgPicture.asset(
                loginMethodsIcon[loginMethod.provider.name] ?? '',
                fit: .cover,
                width: context.width * 0.04,
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
        ),
      ],
    );
  }

  PreferredSizeWidget _builtAppBar({
    required BuildContext context,
    required PlatformAccount account,
  }) {
    final currentUser = context.read<UserCubit>().currentUser!;
    return AppBar(
      toolbarHeight: 90,
      automaticallyImplyLeading: false,
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: context.easyColor(
            lColor: AppColors.primary,
            dColor: AppColors.secondary,
          ),
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
                        EditPlatformAccountScreen(account: account),
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
                  title: 'confirmation'.tr(),
                  message: 'are_you_sure_you_want_to_delete_account',
                  posActionText: 'yes',
                  negActionText: 'no',
                  posAction: () {
                    context.read<PlatformAccountCubit>().deletePlatformAccount(
                      userId: currentUser.id,
                      accountId: account.id!,
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

  Widget _builtPlatformIcon({required PlatformAccount account}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        shape: BoxShape.circle,
      ),
      child: Image.network(
        account.platform.icon,
        width: 80,
        height: 80,
        errorBuilder: (_, _, _) =>
            const Icon(Icons.public, size: 80, color: AppColors.primary),
      ),
    );
  }

  Widget _builtPasswordButtons({
    required bool value,
    required PlatformAccount account,
  }) {
    return Row(
      mainAxisAlignment: .end,
      mainAxisSize: .min,
      children: [
        CopyAccountPasswordButtonWidget(
          account: account,
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
