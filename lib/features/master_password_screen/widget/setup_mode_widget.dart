import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:pb_vault/widgets/conf_password_text_field_widget.dart';
import 'package:pb_vault/widgets/password_text_field_widget.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../auth/cubit/user_view_model.dart';
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
              _builtCreateButton(),
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
        'create_master_password'.tr(),
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

  Widget _builtCreateButton() {
    final masterCubit = context.read<MasterPasswordCubit>();
    final authCubit = context.read<UserCubit>();
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
          borderSideColor: context.easyColor(
            lColor: AppColors.backgroundLight,
            dColor: AppColors.backgroundDark,
          ),
          backgroundColor: state is MasterPasswordSetupSuccess
              ? context.easyColor(
                  dColor: AppColors.backgroundLight,
                  lColor: AppColors.backgroundDark,
                )
              : context.easyColor(
                  lColor: AppColors.backgroundDark,
                  dColor: AppColors.primary,
                ),
          child: Text(
            state is MasterPasswordSetupSuccess
                ? "success".tr()
                : "create".tr(),
            style:
            state is MasterPasswordSetupSuccess ? AppStyles.robotoBold20(
              context,
              lColor: AppColors.backgroundDark,
              dColor: AppColors.white,
            ):
            AppStyles.robotoBold20White(context)
          ),
        );
      },
    );
  }
}
