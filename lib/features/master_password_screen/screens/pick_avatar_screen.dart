import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pb_vault/core/utils/app_routes.dart';
import 'package:pb_vault/core/utils/app_styles.dart';
import 'package:pb_vault/core/utils/dialog_utils.dart';
import 'package:pb_vault/core/utils/screen_size.dart';
import 'package:pb_vault/features/auth/cubit/user_state.dart';
import 'package:pb_vault/features/auth/cubit/user_view_model.dart';
import 'package:pb_vault/widgets/custom_elevated_button.dart';

import '../../../core/constants/assets_constants.dart';
import '../../../core/utils/app_colors.dart';

class PickAvatarScreen extends StatefulWidget {
  const PickAvatarScreen({super.key});

  @override
  State<PickAvatarScreen> createState() => _PickAvatarScreenState();
}

class _PickAvatarScreenState extends State<PickAvatarScreen> {
  static const avatars = userAvatars;

  var currentAvatar = 'profile_avatar_1';

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) =>
          current is UserDetailsUpdateLoadingState ||
          current is UserDetailsUpdateSuccessState ||
          current is UserDetailsUpdateErrorState,
      listener: (context, state) {
        if (state is UserDetailsUpdateLoadingState) {
          DialogUtils.showLoading(context: context);
        }
        if (state is UserDetailsUpdateErrorState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: state.message,
            title: 'error'.tr(),
          );
        }
        DialogUtils.showMessage(
          context: context,
          message: 'avatar_saved_successfully'.tr(),
          title: 'success'.tr(),
          posActionText: 'ok'.tr(),
          posAction: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.homeRouteName,
              (route) => false,
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          actionsPadding: EdgeInsets.symmetric(horizontal: 10),
          toolbarHeight: 80,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.homeRouteName,
                  (route) => false,
                );
              },
              child: Text(
                'skip'.tr(),
                style: AppStyles.robotoRegular14(
                  context,
                  lColor: AppColors.surfaceDark,
                  dColor: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: context.width * 0.025,
            vertical: context.width * 0.05,
          ),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              SizedBox(height: context.height * 0.005),
              Text(
                'pick_avatar_for_your_account'.tr(),
                style: AppStyles.robotoRegular18(
                  context,
                  lColor: AppColors.surfaceDark,
                  dColor: AppColors.white,
                ),
                textAlign: .center,
              ),
              SizedBox(height: 50),
              CircleAvatar(
                radius: 80,
                backgroundColor: context.easyColor(
                  lColor: AppColors.backgroundDark,
                  dColor: AppColors.primary,
                ),
                child: SvgPicture.asset(avatars[currentAvatar]!),
              ),
              Expanded(
                child: AvatarGridView(
                  newAvatarIndex: (value) {
                    if (currentAvatar == value) return;
                    setState(() {
                      currentAvatar = value;
                    });
                  },
                  currentAvatarIndex: currentAvatar,
                ),
              ),
              CustomElevatedButton(
                backgroundColor: context.easyColor(
                  lColor: AppColors.backgroundDark,
                  dColor: AppColors.primary,
                ),
                onPressed: () async {
                  var userCubit = context.read<UserCubit>();
                  var currentUser = userCubit.currentUser!;
                  await userCubit.updateUserDetails(
                    user: currentUser.copyWith(avatar: currentAvatar),
                  );
                },
                child: Text(
                  'continue'.tr(),
                  style: AppStyles.robotoRegular16White(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarGridView extends StatelessWidget {
  final ValueChanged<String> newAvatarIndex;
  final String currentAvatarIndex;

  const AvatarGridView({
    super.key,
    required this.newAvatarIndex,
    required this.currentAvatarIndex,
  });

  @override
  Widget build(BuildContext context) {
    const avatars = userAvatars;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: context.height * 0.03,
        horizontal: context.width * 0.025,
      ),

      decoration: BoxDecoration(
        color: context.easyColor(
          lColor: AppColors.backgroundLight,
          dColor: AppColors.backgroundDark,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: GridView.builder(
        // padding: EdgeInsetsGeometry.all(context.width * 0.025),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          mainAxisExtent: 110,
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            if (currentAvatarIndex == 'profile_avatar_${index + 1}') return;
            newAvatarIndex('profile_avatar_${index + 1}');
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: context.easyColor(
                lColor: AppColors.backgroundLight,
                dColor: AppColors.backgroundDark,
              ),
            ),
            child: Stack(
              alignment: AlignmentGeometry.bottomRight,
              children: [
                CircleAvatar(
                  radius: double.infinity,
                  backgroundColor: context.easyColor(
                    lColor: AppColors.backgroundDark,
                    dColor: AppColors.primary,
                  ),
                  child: SvgPicture.asset(
                    avatars['profile_avatar_${index + 1}']!,
                  ),
                ),
                Visibility(
                  visible: currentAvatarIndex == 'profile_avatar_${index + 1}',
                  child: Container(
                    padding: EdgeInsets.all(3),
                    margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amberAccent,
                      border: Border.all(
                        width: 3,
                        color: AppColors.backgroundDark,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppColors.surfaceDark,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        itemCount: avatars.length,
      ),
    );
  }
}
