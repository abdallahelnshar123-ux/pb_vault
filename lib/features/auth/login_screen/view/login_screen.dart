import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/features/auth/login_screen/view/widget/login_ui.dart';

import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/utils/dialog_utils.dart';
import '../../auth_state.dart';
import '../../cubit/auth_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            title: 'success',
            context: context,
            message: 'login_successfully',
          );

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

        if (state is AuthLoginError) {
          debugPrint(state.message);
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            posActionText: 'ok',
            title: 'error',
            context: context,
            message: state.message,
          );
        }
        if (state is AuthContinueWithGoogleError) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            posActionText: 'ok',
            title: 'error',
            context: context,
            message: state.message,
          );
        }
        if (state is AuthLoginLoading ||
            state is AuthContinueWithGoogleLoading) {
          DialogUtils.showLoading(context: context);
        }
      },
      child: LoginUi(),
    );
  }
}
