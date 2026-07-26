import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pb_vault/core/constants/app_constants.dart';
import 'package:pb_vault/core/utils/app_routes.dart';
import 'package:pb_vault/features/home_screen/widget/password_card_item.dart';
import 'package:pb_vault/features/platform_account/screens/search_platform_accounts_screen.dart';
import 'package:pb_vault/widgets/custom_elevated_button.dart';
import 'package:pb_vault/widgets/main_error_widget.dart';
import 'package:pb_vault/widgets/main_loading_widget.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/screen_size.dart';
import '../../../core/di/di.dart';
import '../../auth/cubit/user_view_model.dart';
import '../../profile_screen/cubit/settings_cubit.dart';
import '../../profile_screen/screens/profile_screen.dart';
import '../cubit/home_state.dart';
import '../cubit/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<HomeCubit>().getAccounts(
        context.read<UserCubit>().currentUser!.id,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = context.read<UserCubit>().currentUser;

    return SafeArea(
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
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'saved_passwords'.tr(),
                    style: AppStyles.robotoRegular16(
                      context,
                      lColor: AppColors.surfaceDark,
                      dColor: AppColors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPlatformAccountsScreen(
                            allAccountsList: context
                                .read<HomeCubit>()
                                .accountsList,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.search_rounded,
                      color: context.easyColor(
                        lColor: AppColors.surfaceDark,
                        dColor: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeSuccess) {
                      if (state.accounts.isEmpty) {
                        return Center(
                          child: Text(
                            'no_accounts_yet'.tr(),
                            style: AppStyles.robotoRegular14(
                              context,
                              lColor: AppColors.backgroundDark,
                              dColor: AppColors.white,
                            ),
                          ),
                        );
                      }
                      return PasswordCardItem(accountsList: state.accounts);
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
    );
  }

  PreferredSizeWidget _builtAppbar({
    required String name,
    required BuildContext context,
  }) {
    var currentAvatar = context.watch<UserCubit>().currentUser?.avatar;
    var avatars = AppConstants.userAvatars;
    final size = context.width * 0.15;
    return AppBar(
      toolbarHeight: 115,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'welcome'.tr() + name,
            style: AppStyles.robotoRegular16(
              context,
              lColor: AppColors.surfaceDark,
              dColor: AppColors.white,
            ),
          ),
          Text(
            'save_your_password_easily_and_securely'.tr(),
            style: AppStyles.robotoRegular12(
              context,
              lColor: AppColors.gray,
              dColor: AppColors.secondary,
            ),
          ),
        ],
      ),
      actionsPadding: EdgeInsets.only(left: context.width * 0.04),
      actions: [
        IconButton(
          constraints: BoxConstraints.tightFor(width: size, height: size),
          iconSize: size * 0.7,
          padding: EdgeInsetsDirectional.only(end: 15),
          style: IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            var currentLocale = context.locale;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) =>
                      getIt<SettingsCubit>()
                        ..loadSettings(currentLocale: currentLocale),
                  child: const ProfileScreen(),
                ),
              ),
            );
          },
          icon:
              (currentAvatar == null ||
                  currentAvatar.isEmpty ||
                  avatars[currentAvatar] == null)
              ? Icon(
                  Icons.account_circle_outlined,
                  color: context.easyColor(
                    lColor: AppColors.surfaceDark,
                    dColor: AppColors.white,
                  ),
                )
              : SizedBox.expand(
                  child: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: SvgPicture.asset(avatars[currentAvatar]!),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _builtAddNewPasswordSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.easyColor(
          lColor: AppColors.primary,
          dColor: AppColors.backgroundLight,
        ),
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
                style: AppStyles.robotoRegular14(
                  context,
                  lColor: AppColors.white,
                  dColor: AppColors.surfaceDark,
                ),
              ),
              Text(
                'save_your_new_password_easily'.tr(),
                style: AppStyles.robotoRegular12(
                  context,
                  lColor: AppColors.white,
                  dColor: AppColors.surfaceDark,
                ),
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
