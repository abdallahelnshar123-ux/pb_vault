import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_routes.dart';
import '../../../../../../core/utils/app_styles.dart';
import '../../../../../../core/utils/screen_size.dart';
import '../../../../../../domain/entities/response/user/my_user.dart';
import '../../../../../../widgets/change_language_item.dart';
import '../../../../../../widgets/custom_elevated_button.dart';
import '../../../../../../widgets/custom_text_form_field.dart';
import '../../../../../core/utils/validators.dart';
import '../../../cubit/auth_view_model.dart';
import '../../../widget/continue_with_google_button.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({super.key});

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late MyUser? user;

  final ValueNotifier<bool> isObscure = ValueNotifier(true);
  String language = 'en';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isObscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),

      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.04,
              vertical: context.height * 0.03,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: context.height * 0.02,
                children: [
                  CustomTextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => Validators.email(value),
                    controller: emailController,
                    prefixIcon: SvgPicture.asset(
                      "assets/icons/email-icon.svg",
                      fit: BoxFit.none,
                    ),
                    hintText: "email".tr(),
                    hintStyle: AppStyles.robotoRegular16White(context),
                    filled: true,
                    fillColor: AppColors.primary,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: isObscure,
                    builder: (context, value, child) => CustomTextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) => Validators.password(value),
                      controller: passwordController,
                      prefixIcon: SvgPicture.asset(
                        "assets/icons/password_icon.svg",
                        fit: BoxFit.none,
                      ),
                      hintText: "password".tr(),
                      hintStyle: AppStyles.robotoRegular16White(context),
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
                          isObscure.value = !isObscure.value;
                        },
                        icon: Icon(
                          Icons.visibility_off_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.only(
                            bottom: context.height * 0.02,
                          ),
                        ),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.pushNamed(
                            context,
                            AppRoutes.resetPasswordRouteName,
                          );
                        },
                        child: Text(
                          "forget_password".tr(),
                          style: AppStyles.robotoRegular14Yellow(context),
                        ),
                      ),
                    ],
                  ),

                  CustomElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthCubit>().loginWithEmailAndPassword(
                          emailController.text,
                          passwordController.text,
                        );
                      }
                    },
                    backgroundColor: AppColors.primary,
                    child: Text(
                      "login".tr(),
                      style: AppStyles.robotoRegular20Black(context),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "don't_have_account".tr(),
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
                            AppRoutes.registerRouteName,
                          );
                        },
                        child: Text(
                          "create_one".tr(),
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
      ),
    );
  }
}
