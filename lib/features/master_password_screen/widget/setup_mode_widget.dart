import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../auth/cubit/auth_view_model.dart';
import '../cubit/master_password_state.dart';
import '../cubit/master_password_view_model.dart';

class SetupModeWidget extends StatefulWidget {
  const SetupModeWidget({super.key});

  @override
  State<SetupModeWidget> createState() => _SetupModeWidgetState();
}

class _SetupModeWidgetState extends State<SetupModeWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confPasswordController = TextEditingController();

  final ValueNotifier<bool> passIsObscure = ValueNotifier(true);

  final ValueNotifier<bool> confPassIsObscure = ValueNotifier(true);

  @override
  void dispose() {
    passIsObscure.dispose();
    confPassIsObscure.dispose();
    passwordController.dispose();
    confPasswordController.dispose();
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
              _builtConfPasswordTextField(),
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
      'setup_your_master_password'.tr(),
      textAlign: TextAlign.center,
      style: AppStyles.interRegular20White,
    );
  }

  Widget _builtSubTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      child: Text(
        'create_master_password'.tr(),
        textAlign: TextAlign.center,
        style: AppStyles.interExtraLight14BackgroundLight,
      ),
    );
  }

  Widget _builtLockIcon(BuildContext context) {
    return BlocBuilder<MasterPasswordCubit, MasterPasswordState>(
      builder: (context, state) {
        return Icon(
          state is MasterPasswordSetupSuccess ? Icons.check : Icons.settings,
          size: 80,
          color: state is MasterPasswordSetupSuccess
              ? AppColors.success
              : AppColors.primary,
        );
      },
    );
  }

  Widget _builtPasswordTextField() {
    return ValueListenableBuilder<bool>(
      valueListenable: passIsObscure,
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
            passIsObscure.value = !passIsObscure.value;
          },
          icon: Icon(Icons.visibility_off_rounded, color: AppColors.black),
        ),
      ),
    );
  }

  Widget _builtConfPasswordTextField() {
    return ValueListenableBuilder<bool>(
      valueListenable: confPassIsObscure,
      builder: (context, value, child) => CustomTextFormField(
        style: AppStyles.robotoRegular16Black(context),
        keyboardType: TextInputType.visiblePassword,
        validator: (value) =>
            Validators.confirmPassword(value, passwordController.text),
        controller: confPasswordController,
        prefixIcon: SvgPicture.asset(
          "assets/icons/password_icon.svg",
          fit: BoxFit.none,
          colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
        ),
        hintText: "confirm_password".tr(),
        hintStyle: AppStyles.robotoRegular16Black(context),
        filled: true,
        obscureText: value,
        fillColor: AppColors.white,
        suffixIcon: IconButton(
          isSelected: !value,
          selectedIcon: Icon(Icons.visibility_rounded, color: AppColors.black),
          onPressed: () {
            confPassIsObscure.value = !confPassIsObscure.value;
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
          onPressed: state is MasterPasswordSetupSuccess
              ? null
              : () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (formKey.currentState!.validate()) {
                    {
                      masterCubit.setMasterPassword(
                        user: authCubit.currentUser!,
                        masterPassword: passwordController.text,
                      );
                    }
                  }
                },
          borderSideColor: AppColors.backgroundDark,
          backgroundColor: state is MasterPasswordSetupSuccess
              ? AppColors.surfaceDark
              : AppColors.primary,
          child: Text(
            state is MasterPasswordSetupSuccess ? "done".tr() : "create".tr(),
            style: AppStyles.robotoBold20White(context),
          ),
        );
      },
    );
  }
}
