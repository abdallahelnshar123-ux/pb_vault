import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/widgets/email_text_field_widget.dart';
import 'package:pb_vault/widgets/password_text_field_widget.dart';

import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../cubit/user_state.dart';
import '../cubit/user_view_model.dart';
import 'continue_with_google_button.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserAuthenticatedState) {
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

        if (state is LoginWithEmailPasswordErrorState) {
          debugPrint(state.message);
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            posActionText: 'ok',
            title: 'error',
            context: context,
            message: state.message,
          );
        }
        if (state is ContinueWithGoogleErrorState) {
          DialogUtils.hideLoading(context: context);
          if (state.message != 'Cancelled by user') {
            DialogUtils.showMessage(
              posActionText: 'ok',
              title: 'error',
              context: context,
              message: state.message,
            );
          }
        }
        if (state is LoginWithEmailPasswordLoadingState ||
            state is ContinueWithGoogleLoadingState) {
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
                  ContinueWithGoogleButton(
                    onPressed: () {
                      context.read<UserCubit>().continueWithGoogle();
                    },
                  ),
                  _builtDivider(),
                  EmailTextFieldWidget(
                    controller: emailController,
                    fillColor: AppColors.white,
                  ),
                  PasswordTextFieldWidget(
                    fillColor: AppColors.white,
                    controller: passwordController,
                  ),
                  _builtForgetPassword(),
                  _builtLoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _builtDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.height * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Divider(
              color: AppColors.white,
              indent: context.width * 0.04,
              endIndent: context.width * 0.03,
            ),
          ),
          Text(
            "or_continue_with_email".tr(),
            style: AppStyles.robotoRegular14White(context),
          ),
          Expanded(
            child: Divider(
              color: AppColors.white,
              indent: context.width * 0.03,
              endIndent: context.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }

  Widget _builtForgetPassword() {
    return TextButton(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.only(bottom: context.height * 0.02),
      ),
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.pushNamed(context, AppRoutes.resetPasswordScreen);
      },
      child: Text(
        "forget_password".tr(),
        style: AppStyles.robotoRegular14White(context),
      ),
    );
  }

  Widget _builtLoginButton() {
    return CustomElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          context.read<UserCubit>().loginWithEmailAndPassword(
            emailController.text,
            passwordController.text,
          );
        }
      },
      backgroundColor: AppColors.black,
      child: Text("login".tr(), style: AppStyles.robotoRegular16White(context)),
    );
  }
}
