import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/features/master_password_screen/widget/setup_mode_widget.dart';
import 'package:pb_vault/widgets/custom_app_bar.dart';

import '../../../../core/di/di.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../auth/cubit/auth_view_model.dart';
import '../cubit/master_password_state.dart';
import '../cubit/master_password_view_model.dart';
import '../widget/unlock_mode_widget.dart';

class MasterPasswordScreen extends StatefulWidget {
  const MasterPasswordScreen({super.key});

  @override
  State<MasterPasswordScreen> createState() => _MasterPasswordScreenState();
}

class _MasterPasswordScreenState extends State<MasterPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isObscure = ValueNotifier(true);

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    isObscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final isSetupMode =
        authCubit.currentUser?.passwordVerifier == null ||
        authCubit.currentUser!.passwordVerifier!.isEmpty;

    return BlocProvider(
      create: (context) => getIt<MasterPasswordCubit>(),
      child: BlocListener<MasterPasswordCubit, MasterPasswordState>(
        listener: (context, state) {
          if (state is MasterPasswordSetupSuccess) {
            DialogUtils.hideLoading(context: context);
            context.read<AuthCubit>().currentUser = state.user;
            Future.delayed(Duration(seconds: 2), () {
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.homeRouteName,
                  (route) => false,
                );
              }
            });
          }
          if (state is MasterPasswordVerifySuccess) {
            DialogUtils.hideLoading(context: context);
            Future.delayed(Duration(seconds: 2), () {
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.homeRouteName,
                  (route) => false,
                );
              }
            });
          }
          if (state is MasterPasswordSetupError ||
              state is MasterPasswordVerifyError) {
            DialogUtils.hideLoading(context: context);
            String message = '';
            if (state is MasterPasswordSetupError) message = state.message;
            if (state is MasterPasswordVerifyError) message = state.message;

            DialogUtils.showMessage(
              context: context,
              title: 'error'.tr(),
              message: message,
              posActionText: 'ok'.tr(),
            );
          }
          if (state is MasterPasswordSetupLoading ||
              state is MasterPasswordVerifyLoading) {
            DialogUtils.showLoading(context: context);
          }
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: CustomAppBar(),
            body: isSetupMode ? SetupModeWidget() : UnlockModeWidget(),
          ),
        ),
      ),
    );
  }
}
