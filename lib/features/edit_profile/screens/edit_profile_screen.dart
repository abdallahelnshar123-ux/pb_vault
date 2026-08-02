import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pb_vault/features/auth/cubit/user_view_model.dart';
import 'package:pb_vault/widgets/username_text_field_widget.dart';

import '../../../core/constants/assets_constants.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/dialog_utils.dart';
import '../../../core/utils/screen_size.dart';
import '../../../core/utils/snack_bar_utils.dart';
import '../../../domain/entities/response/user/my_user.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../auth/cubit/user_state.dart';
import 'avatars_bottom_sheet.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late var userCubit = context.read<UserCubit>();
  late final MyUser currentUser = userCubit.currentUser!;
  late final TextEditingController nameController = TextEditingController(
    text: currentUser.name,
  );
  final _formKey = GlobalKey<FormState>();
  late final ValueNotifier<String> avatar = ValueNotifier(
    currentUser.avatar ?? 'profile_avatar_1',
  );

  @override
  void dispose() {
    nameController.dispose();
    // phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) =>
          current is UserDetailsUpdateSuccessState ||
          current is UserDetailsUpdateErrorState ||
          current is UserDetailsUpdateLoadingState ||
          current is UserDeleteLoadingState ||
          current is UserDeleteSuccessState ||
          current is UserDeleteErrorState,
      listener: (context, state) {
        if (state is UserDetailsUpdateSuccessState) {
          DialogUtils.hideLoading(context: context);
          Navigator.pop(context);
          SnackBarUtils.showSuccessSnackBar(
            context: context,
            message: 'data_was_updated_successfully'.tr(),
          );
        }
        if (state is UserDetailsUpdateErrorState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            title: 'error',
            message: state.message,
            posActionText: 'ok',
          );
        }
        if (state is UserDetailsUpdateLoadingState) {
          DialogUtils.showLoading(context: context);
        }
        if (state is UserDeleteSuccessState) {
          DialogUtils.hideLoading(context: context);
          SnackBarUtils.showSuccessSnackBar(
            context: context,
            message: 'account_was_deleted_successfully',
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.authScreen,
            (route) => false,
          );
        }
        if (state is UserDeleteErrorState) {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            title: 'error',
            message: state.message,
            posActionText: 'ok',
          );
        }
        if (state is UserDeleteLoadingState) {
          DialogUtils.showLoading(context: context);
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("edit_profile".tr()),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(16),
            child: CustomElevatedButton(
              backgroundColor: context.easyColor(
                lColor: AppColors.backgroundDark,
                dColor: AppColors.primary,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await userCubit.updateUserDetails(
                    user: currentUser.copyWith(
                      name: nameController.text,
                      avatar: avatar.value,
                    ),
                  );
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: Text(
                'update_data'.tr(),
                style: AppStyles.robotoRegular16White(context),
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 15,
                  children: [
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        showAvatarBottomSheet();
                      },
                      child: Stack(
                        alignment: .topRight,
                        children: [
                          ValueListenableBuilder<String>(
                            valueListenable: avatar,
                            builder:
                                (BuildContext context, value, Widget? child) {
                                  var avatarPath = userAvatars[value];
                                  return Container(
                                    width: context.width * 0.3,
                                    height: context.width * 0.3,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                    ),
                                    child: avatarPath != null
                                        ? ClipOval(
                                            child: SvgPicture.asset(
                                              avatarPath,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: context.width * 0.2,
                                            color: AppColors.backgroundDark,
                                          ),
                                  );
                                },
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            // margin: EdgeInsets.symmetric(
                            //   horizontal: 2,
                            //   vertical: 10,
                            // ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.lightGreen,
                              border: Border.all(
                                width: 3,
                                color: AppColors.backgroundDark,
                              ),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: AppColors.surfaceDark,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.height * 0.01),
                    UsernameTextFieldWidget(
                      controller: nameController,
                      fillColor: AppColors.secondary,
                    ),
                    // CustomTextFormField(
                    //   prefixIcon: Icon(Icons.person, color: AppColors.primary),
                    //   controller: nameController,
                    //   hintText: "enter_your_name".tr(),
                    //   hintStyle: AppStyles.robotoRegular16White(
                    //     context,
                    //   ).copyWith(fontSize: 16, fontWeight: FontWeight.w800),
                    //   validator: (value) => Validators.required(value),
                    //   fillColor: AppColors.backgroundDark,
                    //   filled: true,
                    //   keyboardType: TextInputType.name,
                    // ),
                    // CustomTextFormField(
                    //   prefixIcon: Icon(
                    //     Icons.phone,
                    //     color: AppColors.primary,
                    //   ),
                    //   controller: phoneController,
                    //   hintText: "enter_your_phone_number".tr(),
                    //   hintStyle: AppStyles.robotoRegular16White(
                    //     context,
                    //   ).copyWith(fontSize: 16, fontWeight: FontWeight.w800),
                    //   validator: (value) => Validators.phone(value),
                    //   fillColor: AppColors.darkGrayColor,
                    //   filled: true,
                    //   keyboardType: TextInputType.phone,
                    // ),
                    // Visibility(
                    //   visible:
                    //       currentUser.provider == AuthProviders.emailPassword,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       TextButton(
                    //         onPressed: () {
                    //           Navigator.of(
                    //             context,
                    //           ).pushNamed(AppRoutes.resetPasswordRouteName);
                    //         },
                    //         child: Text(
                    //           "reset_password".tr(),
                    //           style: AppStyles.robotoRegular16White(context)
                    //               .copyWith(
                    //                 decoration: TextDecoration.underline,
                    //                 decorationColor: AppColors.whiteColor,
                    //               ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAvatarBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      builder: (context) => SelectAvatarBottomSheet(
        newAvatar: (index) {
          avatar.value = index;
        },
        currentAvatar: avatar.value,
      ),
    );
  }
}

/// code to delete account

// onPressed: () async {
// if (currentUser.provider == AuthProviders.emailPassword) {
// String? password = await DialogUtils.showPasswordDialog(
// context: context,
// message: 'please_enter_password_to_delete_account',
// title: 'confirmation',
// );
//
// if (password != null && password.isNotEmpty) {
// if (!context.mounted) return;
// userCubit.deleteUser(password: password);
// }
// } else {
// DialogUtils.showMessage(
// context: context,
// message: 'are_you_sure_you_want_to_delete_the_account',
// title: 'confirmation',
// posAction: () {
// userCubit.deleteUser(password: "");
// },
// posActionText: 'yes',
// negActionText: 'no',
// );
// }
// },
