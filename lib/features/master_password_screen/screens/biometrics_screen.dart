import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/core/utils/app_routes.dart';
import 'package:pb_vault/core/utils/dialog_utils.dart';
import 'package:pb_vault/features/auth/cubit/user_view_model.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_state.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_view_model.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../../../widgets/custom_elevated_button.dart';

class BiometricsScreen extends StatefulWidget {
  const BiometricsScreen({super.key});

  @override
  State<BiometricsScreen> createState() => _BiometricsScreenState();
}

class _BiometricsScreenState extends State<BiometricsScreen> {
  bool isBiometricsActivated = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MasterPasswordCubit, MasterPasswordState>(
      listenWhen: (previous, current) => current is BiometricErrorState,
      listener: (context, state) {
        if (state is BiometricErrorState) {
          DialogUtils.showMessage(
            context: context,
            message: 'error_while_trying_activating_biometric',
            posActionText: 'ok',
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: context.height * 0.02,
              children: [
                SizedBox(height: context.height * 0.2),
                _builtFingerprintIcon(context),
                SizedBox(height: context.height * 0.05),
                _builtTitle(),
                _builtSubTitle(context),
                SizedBox(height: context.height * 0.03),
                _buildEnableBiometricButton(),
                _buildSkipButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _builtTitle() {
    return Text(
      isBiometricsActivated
          ? 'biometric_authentication_is_now_activated'.tr()
          : 'use_biometric_authentication'.tr(),
      textAlign: TextAlign.center,
      style: AppStyles.interRegular20White,
    );
  }

  Widget _builtSubTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      child: Text(
        isBiometricsActivated
            ? 'you_can_turn_it_off_from_sittings'.tr()
            : 'unlock_your_vault_with_your_biometric_credential'.tr(),
        textAlign: TextAlign.center,
        style: AppStyles.interExtraLight14BackgroundLight,
      ),
    );
  }

  Widget _builtFingerprintIcon(BuildContext context) {
    return Icon(
      Icons.fingerprint_rounded,
      size: 100,
      color: isBiometricsActivated ? AppColors.success : AppColors.primary,
    );
  }

  Widget _buildEnableBiometricButton() {
    return CustomElevatedButton(
      onPressed: () async {
        if (isBiometricsActivated) {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.homeRouteName,
              (route) => false,
            );
          }
        } else {
          bool biometricResult = await context
              .read<MasterPasswordCubit>()
              .enableBiometric(true);
          if (biometricResult) {
            setState(() {
              isBiometricsActivated = true;
            });
          }
        }
      },
      borderSideColor: AppColors.backgroundDark,
      backgroundColor: AppColors.primary,

      child: Text(
        isBiometricsActivated ? "continue".tr() : "enable_biometric_login".tr(),
        style: AppStyles.robotoRegular16White(context),
      ),
    );
  }

  Widget _buildSkipButton() {
    var currentUser = context.read<UserCubit>().currentUser;
    return Visibility(
      visible: !isBiometricsActivated,
      child: CustomElevatedButton(
        onPressed: () {
          context.read<MasterPasswordCubit>().rejectBiometric(true);
          Navigator.pushNamedAndRemoveUntil(
            context,
            currentUser?.avatar == '' &&
                    context.read<UserCubit>().isAccountJustCreated
                ? AppRoutes.pickAvatarScreen
                : AppRoutes.homeRouteName,
            (route) => false,
          );
        },
        borderSideColor: AppColors.primary,
        backgroundColor: AppColors.backgroundDark,
        child: Text(
          "skip_for_now".tr(),
          style: AppStyles.robotoRegular16White(context),
        ),
      ),
    );
  }
}
