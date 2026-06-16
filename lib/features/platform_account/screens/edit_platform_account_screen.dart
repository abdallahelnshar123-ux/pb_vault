import 'package:cryptography/cryptography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/features/platform_account/cubit/platform_account_state.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/screen_size.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../core/di/di.dart';
import '../../../core/services/vault_crypto_service/vault_crypto_service.dart';
import '../../../domain/entities/response/platform_account/platform_account.dart';
import '../../../widgets/email_text_field_widget.dart';
import '../../../widgets/password_text_field_widget.dart';
import '../../auth/cubit/user_view_model.dart';
import '../cubit/platform_account_view_model.dart';

class EditPlatformAccountScreen extends StatefulWidget {
  const EditPlatformAccountScreen({super.key, required this.account});

  final PlatformAccount account;

  @override
  State<EditPlatformAccountScreen> createState() =>
      _EditPlatformAccountScreenState();
}

class _EditPlatformAccountScreenState extends State<EditPlatformAccountScreen> {
  late TextEditingController emailController = TextEditingController(
    text: widget.account.emailOrUsername,
  );
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController notesController = TextEditingController(
    text: widget.account.notes,
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      passwordController.text = await getIt<VaultCryptoService>().decryptPassword(
        mac: Mac(widget.account.mac),
        cipherText: widget.account.encryptedPassword,
        nonce: widget.account.nonce,
      );
    });
    super.initState();
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlatformAccountCubit, PlatformAccountState>(
      listener: (context, state) {
        if (state is EditPlatformAccountLoadingState) {
          DialogUtils.showLoading(context: context);
        } else if (state is EditPlatformAccountSuccessState) {
          DialogUtils.hideLoading(context: context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('account_updated_successfully'.tr()),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (state is EditPlatformAccountErrorState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.message,
            title: 'error'.tr(),
            posActionText: 'ok'.tr(),
          );
        }
      },
      child: SafeArea(
        bottom: true,
        top: false,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.backgroundDark,
            appBar: _builtAppBar(),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(context.width * 0.05),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: context.height * 0.02,
                  children: [
                    _builtPlatformTile(),
                    SizedBox(height: context.height * 0.03),
                    EmailTextFieldWidget(
                      fillColor: AppColors.secondary,
                      controller: emailController,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PasswordTextFieldWidget(
                          fillColor: AppColors.secondary,
                          controller: passwordController,
                        ),
                        _builtGeneratePassword(),
                      ],
                    ),
                    _builtNotesTextField(),
                    const SizedBox(height: 20),
                    _builtSaveChangesButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _builtAppBar() {
    return AppBar(
      centerTitle: false,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios_new_rounded),
        color: AppColors.secondary,
      ),
      title: Text(
        'edit_account'.tr(),
        style: AppStyles.robotoRegular20Secondary(context),
      ),
      elevation: 0,
    );
  }

  Widget _builtPlatformTile() {
    return ListTile(
      splashColor: AppColors.transparent,
      contentPadding: EdgeInsets.zero,

      title: Text(
        widget.account.platform.name,
        style: AppStyles.robotoRegular18Secondary(context),
      ),
      leading: CircleAvatar(
        backgroundColor: AppColors.secondary,
        radius: context.width * 0.07,
        child: Image.network(widget.account.platform.icon, width: 24),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          widget.account.platform.website,
          style: AppStyles.robotoRegular12Secondary(
            context,
          ).copyWith(color: AppColors.success),
        ),
      ),
    );
  }

  Widget _builtGeneratePassword() {
    return Builder(
      builder: (context) {
        return TextButton.icon(
          onPressed: () {
            final pass = context
                .read<PlatformAccountCubit>()
                .generateStrongPassword();
            passwordController.text = pass;
          },
          icon: const Icon(Icons.refresh, color: AppColors.secondary),
          label: Text(
            'generate_strong_password'.tr(),
            style: AppStyles.robotoRegular14Secondary(context),
          ),
        );
      },
    );
  }

  Widget _builtNotesTextField() {
    return CustomTextFormField(
      controller: notesController,
      hintText: 'notes'.tr(),
      maxLines: 3,
      hintStyle: AppStyles.robotoBold14gray(context),
      style: AppStyles.robotoBold16SurfaceDark(context),
      filled: true,
      fillColor: AppColors.secondary,
    );
  }

  Widget _builtSaveChangesButton() {
    return Builder(
      builder: (context) {
        return CustomElevatedButton(
          backgroundColor: AppColors.primary,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final userId = context.read<UserCubit>().currentUser?.id ?? '';
              context.read<PlatformAccountCubit>().updatePlatformAccount(
                userId: userId,
                emailOrUsername: emailController.text,
                password: passwordController.text,
                notes: notesController.text,
                originalAccount: widget.account,
              );
            }
          },
          child: Text(
            'save_changes'.tr(),
            style: AppStyles.robotoRegular16White(context),
          ),
        );
      },
    );
  }
}
