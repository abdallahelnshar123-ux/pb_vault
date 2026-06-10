import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/core/utils/app_routes.dart';
import 'package:pb_vault/features/home_screen/widget/password_card_item.dart';
import 'package:pb_vault/widgets/custom_elevated_button.dart';
import 'package:pb_vault/widgets/main_error_widget.dart';
import 'package:pb_vault/widgets/main_loading_widget.dart';

import '../../../../core/di/di.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/screen_size.dart';
import '../../auth/cubit/auth_view_model.dart';
import '../cubit/home_state.dart';
import '../cubit/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var currentUser = context.read<AuthCubit>().currentUser;
    final authCubit = context.read<AuthCubit>();
    final userId = authCubit.currentUser?.id ?? '';

    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..getAccounts(userId),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: _builtAppbar(name: currentUser?.name ?? '', context: context),
          body: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: context.width * 0.04,
            ),
            child: Column(
              spacing: context.width * 0.05,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _builtAddNewPasswordSection(context),
                Text(
                  'saved_passwords'.tr(),
                  style: AppStyles.robotoRegular16White(context),
                ),
                Expanded(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeSuccess) {
                        if (state.accounts.isEmpty) {
                          return Center(
                            child: Text(
                              'no_accounts_found'.tr(),
                              style: AppStyles.robotoRegular14White(context),
                            ),
                          );
                        }
                        return PasswordCardItem(state: state);
                      } else if (state is HomeError) {
                        return MainErrorWidget(
                          errorMessage: state.message,
                          onPressed: () {},
                          widgetHeight: double.infinity,
                        );
                      }
                      return MainLoadingWidget();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _builtAppbar({
    required String name,
    required BuildContext context,
  }) {
    return AppBar(
      toolbarHeight: 115,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'welcome'.tr() + name,
            style: AppStyles.robotoRegular16White(context),
          ),
          Text(
            'save_your_password_easily_and_securely'.tr(),
            style: AppStyles.robotoRegular12Secondary(context),
          ),
        ],
      ),
      actions: [
        IconButton(
          padding: EdgeInsets.only(right: 15),
          style: IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {},
          icon: Icon(
            Icons.account_circle_outlined,
            size: context.width * 0.1,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _builtAddNewPasswordSection(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      padding: EdgeInsets.all(context.width * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.secondary,
      ),
      child: Column(
        spacing: context.width * 0.04,
        crossAxisAlignment: .start,
        children: [
          Icon(
            Icons.shield,
            size: context.width * 0.06,
            color: AppColors.surfaceDark,
          ),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'new_password'.tr(),
                style: AppStyles.robotoRegular14SurfaceDark(context),
              ),
              Text(
                'save_your_new_password_easily'.tr(),
                style: AppStyles.robotoRegular12SurfaceDark(context),
              ),
            ],
          ),

          CustomElevatedButton(
            buttonWidth: double.infinity,
            backgroundColor: AppColors.surfaceDark,
            borderRadius: 50,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addAccountScreen);
            },
            child: Row(
              spacing: context.width * 0.025,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'add_new'.tr(),
                  style: AppStyles.robotoRegular14White(context),
                ),
                Icon(
                  Icons.add,
                  size: context.width * 0.06,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
