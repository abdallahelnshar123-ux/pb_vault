import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_routes.dart';
import '../../../../../../core/utils/app_styles.dart';
import '../../../../../../core/utils/screen_size.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../widgets/change_language_item.dart';
import '../../../../../../widgets/custom_elevated_button.dart';
import '../../../../../../widgets/custom_text_form_field.dart';
import '../../../cubit/auth_view_model.dart';
import '../../../widget/continue_with_google_button.dart';

class RegisterUi extends StatefulWidget {
  const RegisterUi({super.key});

  @override
  State<RegisterUi> createState() => _RegisterUiState();
}

class _RegisterUiState extends State<RegisterUi> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confPasswordController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passIsObscure = ValueNotifier(true);

  final ValueNotifier<bool> confPassIsObscure = ValueNotifier(true);

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confPasswordController.dispose();
    phoneController.dispose();
    passIsObscure.dispose();
    confPassIsObscure.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        title: Text(
          'Register'.tr(),
          style: AppStyles.robotoRegular16Yellow(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
          child: Form(
            key: formKey,
            child: Column(
              spacing: context.height * 0.02,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                  keyboardType: TextInputType.text,
                  errorStyle: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  controller: nameController,
                  validator: (value) => Validators.required(value),
                  prefixIcon: SvgPicture.asset(
                    AppAssets.nameIcon,
                    fit: BoxFit.none,
                  ),
                  hintText: "Name".tr(),
                  hintStyle: AppStyles.robotoRegular16White(context),
                  filled: true,
                  fillColor: AppColors.primary,
                ),
                CustomTextFormField(
                  keyboardType: TextInputType.emailAddress,
                  errorStyle: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  controller: emailController,
                  validator: (value) => Validators.email(value),
                  prefixIcon: SvgPicture.asset(
                    "assets/icons/email-icon.svg",
                    fit: BoxFit.none,
                  ),
                  hintText: "Email".tr(),
                  hintStyle: AppStyles.robotoRegular16White(context),
                  filled: true,
                  fillColor: AppColors.primary,
                ),
                ValueListenableBuilder(
                  valueListenable: passIsObscure,
                  builder: (context, value, child) => CustomTextFormField(
                    keyboardType: TextInputType.text,
                    errorStyle: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    validator: (value) => Validators.password(value),
                    controller: passwordController,
                    hintStyle: AppStyles.robotoRegular16White(context),
                    hintText: "Password".tr(),
                    prefixIcon: SvgPicture.asset(
                      AppAssets.passwordIcon,
                      fit: BoxFit.none,
                    ),
                    obscureText: value,
                    filled: true,
                    fillColor: AppColors.primary,
                    suffixIcon: IconButton(
                      isSelected: !value,
                      selectedIcon: Icon(
                        Icons.visibility_rounded,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        passIsObscure.value = !passIsObscure.value;
                      },
                      icon: Icon(
                        Icons.visibility_off_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: confPassIsObscure,
                  builder: (context, value, child) => CustomTextFormField(
                    keyboardType: TextInputType.text,
                    errorStyle: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    validator: (value) => Validators.confirmPassword(
                      value,
                      passwordController.text,
                    ),
                    controller: confPasswordController,
                    hintText: "Confirm Password".tr(),
                    hintStyle: AppStyles.robotoRegular16White(context),
                    prefixIcon: SvgPicture.asset(
                      AppAssets.passwordIcon,
                      fit: BoxFit.none,
                    ),
                    obscureText: value,
                    filled: true,
                    fillColor: AppColors.primary,
                    suffixIcon: IconButton(
                      isSelected: !value,
                      selectedIcon: Icon(
                        Icons.visibility_rounded,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        confPassIsObscure.value = !confPassIsObscure.value;
                      },
                      icon: Icon(
                        Icons.visibility_off_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                CustomTextFormField(
                  keyboardType: TextInputType.phone,
                  errorStyle: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  controller: phoneController,
                  validator: (value) => Validators.phone(value),
                  prefixIcon: SvgPicture.asset(
                    AppAssets.phoneIcon,
                    fit: BoxFit.none,
                  ),
                  hintText: "Phone Number".tr(),
                  hintStyle: AppStyles.robotoRegular16White(context),
                  filled: true,
                  fillColor: AppColors.primary,
                ),
                SizedBox(height: context.height * 0.01),
                CustomElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<AuthCubit>().registerWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                        name: nameController.text,
                        phone: phoneController.text,
                        avatarIndex: context
                            .read<AuthCubit>()
                            .selectedAvatarIndex,
                      );
                    }
                  },
                  backgroundColor: AppColors.primary,
                  child: Text(
                    'Create Account'.tr(),
                    style: AppStyles.robotoRegular20Black(context),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "already_have_account".tr(),
                      style: AppStyles.robotoRegular14White(context),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.loginRouteName,
                        );
                      },
                      child: Text(
                        "login".tr(),
                        style: AppStyles.robotoRegular14Yellow(context),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.primary,
                        indent: context.width * 0.09,
                        endIndent: context.width * 0.03,
                      ),
                    ),
                    Text(
                      "or".tr(),
                      style: AppStyles.robotoRegular15Yellow(context),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.primary,
                        indent: context.width * 0.03,
                        endIndent: context.width * 0.09,
                      ),
                    ),
                  ],
                ),
                ContinueWithGoogleButton(
                  onPressed: () {
                    context.read<AuthCubit>().continueWithGoogle();
                  },
                ),
                ChangeLanguageItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
