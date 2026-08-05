import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:pb_vault/widgets/email_text_field_widget.dart';

import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/dialog_utils.dart';
import '../../../core/utils/screen_size.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../cubit/user_state.dart';
import '../cubit/user_view_model.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) =>
          current is ResetUSerPasswordLoadingState ||
          current is ResetUserPasswordSuccessState ||
          current is ResetUSerPasswordErrorState,
      listener: (context, state) {
        if (state is ResetUSerPasswordErrorState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.message,
            title: "error",
            posActionText: 'ok',
          );
        }
        if (state is ResetUserPasswordSuccessState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: 'reset_password_message',
            title: "email_sent",
            posActionText: 'ok',
            posAction: () => Navigator.pop(context),
          );
        }
        if (state is ResetUSerPasswordLoadingState) {
          DialogUtils.showLoading(context: context);
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(title: Text("reset_password".tr())),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  spacing: context.height * 0.04,
                  children: [
                    Image.asset(AppAssets.forgetPasswordImage),
                    EmailTextFieldWidget(
                      fillColor: AppColors.white,
                      controller: emailController,
                    ),
                    CustomElevatedButton(
                      buttonWidth: double.infinity,
                      backgroundColor: context.easyColor(
                        lColor: AppColors.backgroundDark,
                        dColor: AppColors.primary,
                      ),
                      onPressed: () async {
                        var userCubit = context.read<UserCubit>();
                        var currentUser = userCubit.currentUser;
                        if (formKey.currentState!.validate()) {
                          if (currentUser == null) {
                            await userCubit.resetPassword(
                              email: emailController.text.trim(),
                            );
                          } else {
                            if (emailController.text.trim() !=
                                currentUser.email) {
                              DialogUtils.showMessage(
                                context: context,
                                message: 'the_email_you_entered_does_not_match'
                                    .tr(),
                                title: 'error'.tr(),
                                posActionText: 'ok'.tr(),
                              );
                            }
                            await userCubit.resetPassword(
                              email: emailController.text.trim(),
                            );

                          }
                        }
                      },
                      child: Text(
                        'send_reset_password_link'.tr(),
                        style: AppStyles.robotoRegular16White(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
