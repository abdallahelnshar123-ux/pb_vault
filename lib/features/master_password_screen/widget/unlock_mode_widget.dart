import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/features/auth/cubit/user_view_model.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_state.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_view_model.dart';
import 'package:pb_vault/widgets/password_text_field_widget.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../../../widgets/custom_elevated_button.dart';

class UnlockModeWidget extends StatefulWidget {
  const UnlockModeWidget({super.key});

  @override
  State<UnlockModeWidget> createState() => _UnlockModeWidgetState();
}

class _UnlockModeWidgetState extends State<UnlockModeWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MasterPasswordCubit>().biometricUnlock();
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: context.height * 0.02,
            children: [
              _builtTitle(),
              _builtSubTitle(context),
              SizedBox(height: context.height * 0.05),
              _builtLockIcon(context),
              SizedBox(height: context.height * 0.05),
              PasswordTextFieldWidget(
                controller: passwordController,
                fillColor: AppColors.secondary,
              ),
              SizedBox(height: context.height * 0.008),
              _builtUnlockButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildBiometricButton() {
  //   return BlocBuilder<MasterPasswordCubit, MasterPasswordState>(
  //     builder: (context, state) {
  //       return InkWell(
  //         onTap: state is MasterPasswordVerifySuccess
  //             ? null
  //             : () => context.read<MasterPasswordCubit>().biometricUnlock(),
  //         child: Container(
  //           padding: EdgeInsets.all(context.width * 0.03),
  //           decoration: BoxDecoration(
  //             color: AppColors.secondary,
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(color: AppColors.primary),
  //           ),
  //           child: Icon(
  //             Icons.fingerprint_rounded,
  //             color: AppColors.primary,
  //             size: 30,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _builtTitle() {
    return Text(
      'unlock_vault'.tr(),
      textAlign: TextAlign.center,
      style: AppStyles.interRegular20White,
    );
  }

  Widget _builtSubTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      child: Text(
        'enter_your_master_password'.tr(),
        textAlign: TextAlign.center,
        style: AppStyles.interExtraLight14BackgroundLight,
      ),
    );
  }

  Widget _builtLockIcon(BuildContext context) {
    return BlocBuilder<MasterPasswordCubit, MasterPasswordState>(
      builder: (context, state) {
        return Icon(
          state is MasterPasswordVerifySuccess
              ? Icons.lock_open_outlined
              : Icons.lock_outline,
          size: 80,
          color: state is MasterPasswordVerifySuccess
              ? AppColors.success
              : AppColors.primary,
        );
      },
    );
  }


  Widget _builtUnlockButton() {
    final masterCubit = context.read<MasterPasswordCubit>();
    final authCubit = context.read<UserCubit>();
    return BlocBuilder<MasterPasswordCubit, MasterPasswordState>(
      builder: (context, state) {
        return CustomElevatedButton(
          onPressed: state is MasterPasswordVerifySuccess
              ? null
              : () async {
                  if (formKey.currentState!.validate()) {
                    {
                      masterCubit.verifyMasterPassword(
                        masterPassword: passwordController.text,
                        salt: authCubit.currentUser!.salt!,
                        passwordVerifier:
                            authCubit.currentUser!.passwordVerifier!,
                      );
                    }
                  }
                },
          borderSideColor: AppColors.backgroundDark,
          backgroundColor: state is MasterPasswordVerifySuccess
              ? AppColors.backgroundDark
              : AppColors.primary,
          child: Text(
            state is MasterPasswordVerifySuccess
                ? "unlocked".tr()
                : "unlock".tr(),
            style: AppStyles.robotoBold20White(context),
          ),
        );
      },
    );
  }
}
