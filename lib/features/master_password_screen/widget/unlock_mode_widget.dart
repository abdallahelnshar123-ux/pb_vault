import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
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

  Widget _builtTitle() {
    return Text(
      'unlock_vault'.tr(),
      textAlign: TextAlign.center,
      style: AppStyles.interRegular20(
        context,
        lColor: AppColors.black,
        dColor: AppColors.white,
      ),
    );
  }

  Widget _builtSubTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      child: Text(
        'enter_your_master_password'.tr(),
        textAlign: TextAlign.center,
        style: AppStyles.interExtraLight14(
          context,
          lColor: AppColors.surfaceDark,
          dColor: AppColors.backgroundLight,
        ),
      ),
    );
  }

  Widget _builtLockIcon(BuildContext context) {
    return BlocBuilder<MasterPasswordCubit, MasterPasswordState>(
      builder: (context, state) {
        return Icon(
          state is UnlockSuccessState
              ? Icons.lock_open_outlined
              : Icons.lock_outline,
          size: 80,
          color: state is UnlockSuccessState
              ? AppColors.success
              : context.easyColor(
                  lColor: AppColors.backgroundDark,
                  dColor: AppColors.primary,
                ),
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
          onPressed: state is UnlockSuccessState
              ? null
              : () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (formKey.currentState!.validate()) {
                    {
                      masterCubit.unlockVault(
                        masterPassword: passwordController.text,
                        salt: authCubit.currentUser!.salt!,
                        passwordVerifier:
                            authCubit.currentUser!.passwordVerifier!,
                      );
                    }
                  }
                },
          borderSideColor: context.easyColor(
            lColor: AppColors.backgroundLight,
            dColor: AppColors.backgroundDark,
          ),
          backgroundColor: state is UnlockSuccessState
              ? AppColors.transparent
              : context.easyColor(
                  lColor: AppColors.backgroundDark,
                  dColor: AppColors.primary,
                ),
          child: Text(
            state is UnlockSuccessState ? "unlocked".tr() : "unlock".tr(),
            style: state is UnlockSuccessState
                ? AppStyles.robotoBold20(
                    context,
                    lColor: AppColors.backgroundDark,
                    dColor: AppColors.white,
                  )
                : AppStyles.robotoBold20White(context),
          ),
        );
      },
    );
  }
}
