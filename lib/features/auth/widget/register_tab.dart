import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../cubit/auth_state.dart';
import '../cubit/auth_view_model.dart';

class RegisterTab extends StatefulWidget {
  const RegisterTab({super.key});

  @override
  State<RegisterTab> createState() => _RegisterTabState();
}

class _RegisterTabState extends State<RegisterTab> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passIsObscure = ValueNotifier(true);

  final ValueNotifier<bool> confPassIsObscure = ValueNotifier(true);
  final ValueNotifier<bool> isPassword8Char = ValueNotifier(false);
  final ValueNotifier<bool> passwordContains1number = ValueNotifier(false);
  final ValueNotifier<bool> isPasswordUpperAndLower = ValueNotifier(false);
  final ValueNotifier<bool> checkBoxValue = ValueNotifier(false);
  final ValueNotifier<bool> checkBoxError = ValueNotifier(false);

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confPasswordController.dispose();
    passIsObscure.dispose();
    confPassIsObscure.dispose();
    checkBoxError.dispose();
    checkBoxValue.dispose();
    isPassword8Char.dispose();
    passwordContains1number.dispose();
    isPasswordUpperAndLower.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            title: 'success',
            context: context,
            message: 'success',
          );
          Future.delayed(Duration(seconds: 2), () {
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.masterPasswordScreen,
                (route) => false,
              );
            }
          });
        }

        if (state is AuthRegisterError) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            posActionText: 'ok',
            title: 'error',
            context: context,
            message: state.message,
          );
        }
        if (state is AuthRegisterLoading ||
            state is AuthContinueWithGoogleLoading) {
          DialogUtils.showLoading(context: context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.04,
              vertical: context.height * 0.045,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: context.height * 0.015,
                children: [
                  _builtNameTextField(),
                  _builtEmailTextField(),
                  _builtPasswordTextField(),
                  _builtConfPasswordTextField(),
                  _builtPasswordChecker(),
                  SizedBox(height: context.height * 0.04),
                  _builtCheckBox(),
                  _builtRegisterButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _builtNameTextField() {
    return CustomTextFormField(
      style: AppStyles.robotoRegular16Black(context),
      keyboardType: TextInputType.name,
      validator: (value) => Validators.required(value),
      controller: nameController,
      prefixIcon: SvgPicture.asset(
        "assets/icons/name_icon.svg",
        fit: BoxFit.none,
        colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
      ),
      hintText: "name".tr(),
      hintStyle: AppStyles.robotoRegular16Black(context),
      filled: true,
      fillColor: AppColors.white,
    );
  }

  Widget _builtEmailTextField() {
    return CustomTextFormField(
      style: AppStyles.robotoRegular16Black(context),
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validators.email(value),
      controller: emailController,
      prefixIcon: SvgPicture.asset(
        "assets/icons/email-icon.svg",
        fit: BoxFit.none,
        colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
      ),
      hintText: "email".tr(),
      hintStyle: AppStyles.robotoRegular16Black(context),
      filled: true,
      fillColor: AppColors.white,
    );
  }

  Widget _builtPasswordTextField() {
    return ValueListenableBuilder<bool>(
      valueListenable: passIsObscure,
      builder: (context, value, child) => CustomTextFormField(
        onChanged: (value) {
          if (value.length >= 8) {
            isPassword8Char.value = true;
          } else {
            isPassword8Char.value = false;
          }
          if (RegExp(r'\d').hasMatch(value)) {
            passwordContains1number.value = true;
          } else {
            passwordContains1number.value = false;
          }
          if (RegExp(r'[A-Z]').hasMatch(value) &&
              RegExp(r'[a-z]').hasMatch(value)) {
            isPasswordUpperAndLower.value = true;
          } else {
            isPasswordUpperAndLower.value = false;
          }
        },
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

  Widget _builtPassCheckerItem({
    required ValueNotifier<bool> notifier,
    required String text,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, value, child) => Row(
        spacing: context.width * 0.02,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: value ? AppColors.success : AppColors.white,
            size: context.width * 0.05,
          ),
          Text(
            text,
            style: value
                ? AppStyles.robotoRegular14Green(context)
                : AppStyles.robotoRegular14White(context),
          ),
        ],
      ),
    );
  }

  Widget _builtPasswordChecker() {
    return Column(
      spacing: context.height * 0.005,
      children: [
        _builtPassCheckerItem(
          notifier: isPassword8Char,
          text: 'at_least_8_characters'.tr(),
        ),
        _builtPassCheckerItem(
          notifier: passwordContains1number,
          text: 'at_least_1_number'.tr(),
        ),
        _builtPassCheckerItem(
          notifier: isPasswordUpperAndLower,
          text: 'both_upper_and_lower_case_letters'.tr(),
        ),
      ],
    );
  }

  Widget _builtCheckBox() {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: checkBoxError,
          builder: (context, value, child) {
            return ValueListenableBuilder<bool>(
              valueListenable: checkBoxValue,
              builder: (BuildContext context, bool value, Widget? child) =>
                  Checkbox(
                    checkColor: AppColors.success,
                    overlayColor: WidgetStatePropertyAll(AppColors.transparent),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: AppColors.primary,
                    side: BorderSide(
                      color: checkBoxError.value
                          ? AppColors.error
                          : AppColors.white,
                    ),
                    tristate: false,
                    isError: checkBoxError.value,
                    value: value,
                    onChanged: (value) {
                      checkBoxValue.value = value!;
                    },
                  ),
            );
          },
        ),
        Text(
          'i_agree_to_terms_and_conditions'.tr(),
          style: AppStyles.robotoRegular10White(context),
        ),
      ],
    );
  }

  Widget _builtRegisterButton() {
    return CustomElevatedButton(
      onPressed: () {
        if (checkBoxValue.value) {
          if (formKey.currentState!.validate()) {
            context.read<AuthCubit>().registerWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
              name: nameController.text,
              avatarIndex: -1,
            );
          }
        } else {
          checkBoxError.value = true;
        }
      },
      backgroundColor: AppColors.black,
      child: Text(
        "register".tr(),
        style: AppStyles.robotoRegular16White(context),
      ),
    );
  }
}
