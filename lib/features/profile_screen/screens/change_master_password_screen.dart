import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';

import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../../../widgets/conf_password_text_field_widget.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/password_text_field_widget.dart';
import '../../master_password_screen/cubit/master_password_state.dart';
import '../../master_password_screen/cubit/master_password_view_model.dart';

class ChangeMasterPasswordScreen extends StatefulWidget {
  const ChangeMasterPasswordScreen({super.key});

  @override
  State<ChangeMasterPasswordScreen> createState() =>
      _ChangeMasterPasswordScreenState();
}

class _ChangeMasterPasswordScreenState
    extends State<ChangeMasterPasswordScreen> {
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
    return BlocListener<MasterPasswordCubit, MasterPasswordState>(
      listener: (context, state) {
        if (state is ChangeMasterPasswordSuccess) {
          DialogUtils.hideLoading(context: context);
          Future.delayed(Duration(seconds: 2), () {
            if (context.mounted) {
              Navigator.pop(context);
            }
          });
        }
        if (state is ChangeMasterPasswordError) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            title: 'error',
            message: state.message,
            posActionText: 'ok',
            posAction: state.message == 'error_while_getting_data'
                ? () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.authScreen,
                      (route) => false,
                    );
                  }
                : null,
          );
        }
        if (state is ChangeMasterPasswordLoading) {
          DialogUtils.showLoading(context: context);
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: Text('change_master_password'.tr()),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: context.height * 0.02,
                  children: [
                    SizedBox(height: context.height * 0.04),
                    _buildTitle(),
                    _buildSubTitle(context),
                    SizedBox(height: context.height * 0.05),
                    _buildIcon(context),
                    SizedBox(height: context.height * 0.05),
                    PasswordTextFieldWidget(
                      fillColor: AppColors.secondary,
                      controller: passwordController,
                    ),
                    ConfPasswordTextFieldWidget(
                      fillColor: AppColors.secondary,
                      passwordController: passwordController,
                      confController: confPasswordController,
                    ),
                    SizedBox(height: context.height * 0.008),
                    _buildChangeButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'change_your_master_password'.tr(),
      textAlign: TextAlign.center,
      style: AppStyles.interRegular20(
        context,
        lColor: AppColors.black,
        dColor: AppColors.white,
      ),
    );
  }

  Widget _buildSubTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      child: Text(
        'enter_new_password'.tr(),
        textAlign: TextAlign.center,
        style: AppStyles.interExtraLight14(
          context,
          lColor: AppColors.surfaceDark,
          dColor: AppColors.backgroundLight,
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return BlocBuilder<MasterPasswordCubit, MasterPasswordState>(
      builder: (context, state) {
        return Icon(
          state is MasterPasswordSetupSuccess ? Icons.check : Icons.settings,
          size: 80,
          color: state is MasterPasswordSetupSuccess
              ? AppColors.success
              : context.easyColor(
                  lColor: AppColors.backgroundDark,
                  dColor: AppColors.primary,
                ),
        );
      },
    );
  }

  Widget _buildChangeButton() {
    final masterCubit = context.read<MasterPasswordCubit>();
    return BlocBuilder<MasterPasswordCubit, MasterPasswordState>(
      builder: (context, state) {
        return CustomElevatedButton(
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            if (formKey.currentState!.validate()) {
              {
                await masterCubit.changeMasterPassword(
                  passwordController.text.trim(),
                );
              }
            }
          },
          borderSideColor: context.easyColor(
            lColor: AppColors.backgroundLight,
            dColor: AppColors.backgroundDark,
          ),
          backgroundColor: state is ChangeMasterPasswordSuccess
              ? AppColors.transparent
              : context.easyColor(
                  lColor: AppColors.backgroundDark,
                  dColor: AppColors.primary,
                ),
          child: Text(
            state is ChangeMasterPasswordSuccess
                ? "success".tr()
                : "change".tr(),
            style: state is ChangeMasterPasswordSuccess
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
