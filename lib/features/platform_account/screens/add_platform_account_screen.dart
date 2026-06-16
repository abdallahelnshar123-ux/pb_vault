import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/core/utils/snack_bar_utils.dart';
import 'package:pb_vault/features/platform_account/cubit/platform_account_view_model.dart';
import 'package:pb_vault/widgets/email_text_field_widget.dart';
import 'package:pb_vault/widgets/password_text_field_widget.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/screen_size.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../domain/entities/response/platform_account/platform_data.dart';
import '../../auth/cubit/user_view_model.dart';
import '../cubit/platform_account_state.dart';
import '../widget/platforms_bottom_sheet.dart';

class AddPlatformAccountScreen extends StatefulWidget {
  const AddPlatformAccountScreen({super.key});

  @override
  State<AddPlatformAccountScreen> createState() => _AddPlatformAccountScreenState();
}

class _AddPlatformAccountScreenState extends State<AddPlatformAccountScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValueNotifier<PlatformData?> currentPlatform = ValueNotifier(null);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    notesController.dispose();
    currentPlatform.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlatformAccountCubit, PlatformAccountState>(
      listener: (context, state) {
        if (state is AddPlatformAccountLoadingState) {
          DialogUtils.showLoading(context: context);
        } else if (state is AddPlatformAccountSuccessState) {
          DialogUtils.hideLoading(context: context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('account_added_successfully'.tr()),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        } else if (state is AddPlatformAccountErrorState) {
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
                    _builtChoosePlatform(),
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
                    _builtAddButton(),
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
        'add_new_account'.tr(),
        style: AppStyles.robotoRegular20Secondary(context),
      ),
      elevation: 0,
    );
  }

  void _showPlatformPicker(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      showDragHandle: true,
      useSafeArea: true,
      enableDrag: false,
      isScrollControlled: true,
      constraints: .tight(Size(double.infinity, context.height -150)),
      backgroundColor: AppColors.backgroundDark,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PlatformsBottomSheet(
        currentPlatform: currentPlatform.value,
        newPlatform: (platform) {
          currentPlatform.value = platform;
        },
      ),
    );
  }

  Widget _builtChoosePlatform() {
    return ValueListenableBuilder<PlatformData?>(
      valueListenable: currentPlatform,
      builder: (context, value, child) {
        if (value == null) {
          return TextButton.icon(
            onPressed: () => _showPlatformPicker(context),
            iconAlignment: .start,
            icon: Icon(
              Icons.add,
              color: AppColors.secondary,
              size: context.width * 0.08,
            ),
            label: Text(
              'choose_platform'.tr(),
              style: AppStyles.robotoRegular18Secondary(context),
            ),
          );
        }
        return ListTile(
          splashColor: AppColors.transparent,
          contentPadding: EdgeInsets.zero,
          onLongPress: () {
            if (currentPlatform.value?.website != null) {
              Clipboard.setData(
                ClipboardData(text: currentPlatform.value!.website),
              ).then((_) {
                if (!context.mounted) return;
                SnackBarUtils.showSuccessSnackBar(
                  context: context,
                  message: 'link_copied_to_clipboard'.tr(),
                );
              });
            }
          },
          onTap: () => _showPlatformPicker(context),
          title: Text(
            currentPlatform.value?.name ?? '',
            style: AppStyles.robotoRegular18Secondary(context),
          ),
          leading: currentPlatform.value != null
              ? CircleAvatar(
                  backgroundColor: AppColors.secondary,
                  radius: context.width * 0.07,
                  child: Image.network(currentPlatform.value!.icon, width: 24),
                )
              : const Icon(Icons.category, color: AppColors.black),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              currentPlatform.value!.website,
              style: AppStyles.robotoRegular12Secondary(
                context,
              ).copyWith(color: AppColors.success),
            ),
          ),
        );
      },
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

  Widget _builtAddButton() {
    return Builder(
      builder: (context) {
        return CustomElevatedButton(
          backgroundColor: AppColors.primary,
          onPressed: () {
            if (formKey.currentState!.validate() &&
                currentPlatform.value != null) {
              final userId = context.read<UserCubit>().currentUser?.id ?? '';
              context.read<PlatformAccountCubit>().addPlatformAccount(
                userId: userId,
                platform: currentPlatform.value!,
                emailOrUsername: emailController.text,
                password: passwordController.text,
                notes: notesController.text,
              );
            } else if (currentPlatform.value == null) {
              SnackBarUtils.showInfoSnackBar(
                context: context,
                message: 'please_select_platform'.tr(),
              );
            }
          },
          child: Text(
            'add'.tr(),
            style: AppStyles.robotoRegular16White(context),
          ),
        );
      },
    );
  }
}
