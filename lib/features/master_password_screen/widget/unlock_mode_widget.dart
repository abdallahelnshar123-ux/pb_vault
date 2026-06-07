import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pb_vault/features/auth/cubit/auth_view_model.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_state.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_view_model.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';

class UnlockModeWidget extends StatefulWidget {
  const UnlockModeWidget({super.key});

  @override
  State<UnlockModeWidget> createState() => _UnlockModeWidgetState();
}

class _UnlockModeWidgetState extends State<UnlockModeWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isObscure = ValueNotifier(true);

  @override
  void dispose() {
    passwordController.dispose();
    isObscure.dispose();
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
              _builtPasswordTextField(),
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

  Widget _builtPasswordTextField() {
    return ValueListenableBuilder<bool>(
      valueListenable: isObscure,
      builder: (context, value, child) => CustomTextFormField(
        style: AppStyles.robotoRegular16Black(context),
        keyboardType: TextInputType.visiblePassword,
        validator: (value) => Validators.password(value),
        controller: passwordController,
        prefixIcon: SvgPicture.asset(
          "assets/icons/password_icon.svg",
          fit: BoxFit.none,
          colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
        ),
        hintText: "password".tr(),
        hintStyle: AppStyles.robotoRegular16Black(context),
        filled: true,
        obscureText: value,
        fillColor: AppColors.white,
        suffixIcon: IconButton(
          isSelected: !value,
          selectedIcon: Icon(Icons.visibility_rounded, color: AppColors.black),
          onPressed: () {
            isObscure.value = !isObscure.value;
          },
          icon: Icon(Icons.visibility_off_rounded, color: AppColors.black),
        ),
      ),
    );
  }

  Widget _builtUnlockButton() {
    final masterCubit = context.read<MasterPasswordCubit>();
    final authCubit = context.read<AuthCubit>();
    return BlocBuilder<MasterPasswordCubit, MasterPasswordState>(
      builder: (context, state) {
        return CustomElevatedButton(
          onPressed: state is MasterPasswordVerifySuccess
              ? null
              : () async {
                  if (formKey.currentState!.validate()) {
                    {
                      masterCubit.verifyMasterPassword(
                        input: passwordController.text,
                        savedPassword: authCubit.currentUser?.masterPassword,
                      );
                    }
                  }
                },
          borderSideColor: AppColors.backgroundDark,
          backgroundColor: state is MasterPasswordVerifySuccess
              ? AppColors.surfaceDark
              : AppColors.primary,
          child: Text(
            state is MasterPasswordVerifySuccess
                ? "locked".tr()
                : "unlock".tr(),
            style: AppStyles.robotoBold20White(context),
          ),
        );
      },
    );
  }
}
