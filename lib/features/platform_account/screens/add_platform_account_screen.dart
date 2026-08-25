import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:pb_vault/core/utils/password_utils.dart';
import 'package:pb_vault/core/utils/snack_bar_utils.dart';
import 'package:pb_vault/features/platform_account/cubit/platform_account_view_model.dart';
import 'package:pb_vault/features/platform_account/widget/login_methods_widget.dart';
import 'package:pb_vault/features/platform_account/widget/more_information_expansion_rile_widget.dart';
import 'package:pb_vault/widgets/identifier_text_field_widget.dart';
import 'package:pb_vault/widgets/password_text_field_widget.dart';
import 'package:pb_vault/widgets/platform_icon.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/screen_size.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../domain/entities/response/platform_account/platform_data.dart';
import '../../auth/cubit/user_view_model.dart';
import '../cubit/platform_account_state.dart';
import '../platform_account_controller/platform_account_controller.dart';
import '../widget/platforms_bottom_sheet.dart';

class AddPlatformAccountScreen extends StatefulWidget {
  const AddPlatformAccountScreen({super.key});

  @override
  State<AddPlatformAccountScreen> createState() =>
      _AddPlatformAccountScreenState();
}

class _AddPlatformAccountScreenState extends State<AddPlatformAccountScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final controller = PlatformAccountController();

  @override
  void dispose() {
    controller.dispose();
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
            appBar: _builtAppBar(),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(context.width * 0.05),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: context.height * 0.02,
                  children: [
                    _builtChoosePlatform(context),
                    SizedBox(height: context.height * 0.03),
                    IdentifierTextFieldWidget(
                      fillColor: AppColors.secondary,
                      controller: controller.identifier,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PasswordTextFieldWidget(
                          fillColor: AppColors.secondary,
                          controller: controller.password,
                        ),
                        _builtGeneratePassword(),
                      ],
                    ),

                    LoginMethodsWidget(
                      newLoginMethod: (value) =>
                          controller.loginMethods = value,
                    ),
                    Divider(
                      color: context.easyColor(
                        lColor: AppColors.backgroundDark,
                        dColor: AppColors.backgroundLight,
                      ),
                      radius: BorderRadius.circular(8),
                    ),
                    Moreinformationexpansiontilewidget(
                      notesController: controller.notes,
                      passkeyController: controller.passkey,
                      recoveryCodesController: controller.recoveryCodes,
                    ),
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
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      title: Text('add_new_account'.tr()),
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
      constraints: BoxConstraints.tight(
        Size(double.infinity, context.height - 150),
      ),
      backgroundColor: context.easyColor(
        lColor: AppColors.primary,
        dColor: AppColors.backgroundDark,
      ),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PlatformsBottomSheet(
        currentPlatform: controller.currentPlatform.value,
        newPlatform: (platform) {
          controller.currentPlatform.value = platform;
        },
      ),
    );
  }

  Widget _builtChoosePlatform(BuildContext context) {
    return ValueListenableBuilder<PlatformData?>(
      valueListenable: controller.currentPlatform,
      builder: (context, value, child) {
        if (value == null) {
          return TextButton.icon(
            onPressed: () => _showPlatformPicker(context),
            iconAlignment: IconAlignment.start,
            icon: Icon(
              Icons.add,
              color: context.easyColor(
                lColor: AppColors.backgroundDark,
                dColor: AppColors.secondary,
              ),
              size: context.width * 0.08,
            ),
            label: Text(
              'choose_platform'.tr(),
              style: AppStyles.robotoRegular18(
                context,
                lColor: AppColors.backgroundDark,
                dColor: AppColors.secondary,
              ),
            ),
          );
        }
        return ListTile(
          splashColor: AppColors.transparent,
          contentPadding: EdgeInsets.zero,
          onLongPress: () {
            if (controller.currentPlatform.value?.website != null) {
              Clipboard.setData(
                ClipboardData(text: controller.currentPlatform.value!.website),
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
            controller.currentPlatform.value?.name ?? '',
            style: AppStyles.robotoRegular18(
              context,
              lColor: AppColors.backgroundDark,
              dColor: AppColors.secondary,
            ),
          ),
          leading: controller.currentPlatform.value != null
              ? CircleAvatar(
                  backgroundColor: context.easyColor(
                    lColor: AppColors.primary,
                    dColor: AppColors.secondary,
                  ),
                  radius: context.width * 0.07,
                  child: PlatformIcon(
                    platformId: value.id,
                    size: context.width * 0.06,
                  ),
                )
              : const Icon(Icons.category, color: AppColors.black),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              controller.currentPlatform.value!.website,
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
            final pass = PasswordUtils.generateStrongPassword();
            controller.password.text = pass;
          },
          icon: Icon(
            Icons.refresh,
            color: context.easyColor(
              lColor: AppColors.backgroundDark,
              dColor: AppColors.secondary,
            ),
          ),
          label: Text(
            'generate_strong_password'.tr(),
            style: AppStyles.robotoRegular14(
              context,
              lColor: AppColors.backgroundDark,
              dColor: AppColors.secondary,
            ),
          ),
        );
      },
    );
  }

  Widget _builtAddButton() {
    return Builder(
      builder: (context) {
        return CustomElevatedButton(
          backgroundColor: context.easyColor(
            lColor: AppColors.backgroundDark,
            dColor: AppColors.primary,
          ),
          onPressed: _submit,
          child: Text(
            'add'.tr(),
            style: AppStyles.robotoRegular16White(context),
          ),
        );
      },
    );
  }

  void _submit() {
    if (formKey.currentState!.validate() &&
        controller.currentPlatform.value != null) {
      final userId = context.read<UserCubit>().currentUser?.id ?? '';
      context.read<PlatformAccountCubit>().addPlatformAccount(
        userId: userId,
        platform: controller.currentPlatform.value!,
        identifier: controller.identifier.text.trim(),
        password: controller.password.text.trim(),
        notes: controller.notes.text.trim(),
        loginMethods: controller.loginMethods,
        recoveryCodes: controller.recoveryCodes.text.trim(),
        passkey: controller.passkey.text.trim(),
      );
    } else if (controller.currentPlatform.value == null) {
      SnackBarUtils.showInfoSnackBar(
        context: context,
        message: 'please_select_platform'.tr(),
      );
    }
  }
}
