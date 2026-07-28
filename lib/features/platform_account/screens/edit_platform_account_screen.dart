import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:pb_vault/domain/use_cases/vault/decrypt_password_use_case.dart';
import 'package:pb_vault/domain/entities/response/platform_account/login_method.dart';
import 'package:pb_vault/features/platform_account/cubit/platform_account_state.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/dialog_utils.dart';
import '../../../../core/utils/screen_size.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../core/di/di.dart';
import '../../../domain/entities/response/platform_account/platform_account.dart';
import '../../../domain/entities/response/platform_account/encrypted_data.dart';
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
//   late TextEditingController emailController = TextEditingController(
//     text: widget.account.identifier,
//   );
//   late TextEditingController passwordController = TextEditingController();
//   late TextEditingController notesController = TextEditingController();
//   late TextEditingController recoveryCodesController = TextEditingController();
//   late TextEditingController passkeyController = TextEditingController();
//
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   List<LoginProvider> selectedLoginProviders = [];
//
//   @override
//   void initState() {
//     selectedLoginProviders = widget.account.loginMethods
//         .map((e) => e.provider)
//         .toList();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (widget.account.password != null) {
//         final encryptedData = EncryptedData(
//           cipherText: widget.account.password!.cipherText,
//           mac: widget.account.password!.mac,
//           nonce: widget.account.password!.nonce,
//         );
//         final result = await getIt<DecryptPasswordUseCase>().invoke(
//           encryptedData,
//         );
//         if (mounted) {
//           result.fold((failure) {}, (password) {
//             setState(() {
//               passwordController.text = password;
//             });
//           });
//         }
//       }
//       // Note: notes/recoveryCodes/passkey would need decryption here too
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     notesController.dispose();
//     recoveryCodesController.dispose();
//     passkeyController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<PlatformAccountCubit, PlatformAccountState>(
//       listener: (context, state) {
//         if (state is EditPlatformAccountLoadingState) {
//           DialogUtils.showLoading(context: context);
//         } else if (state is EditPlatformAccountSuccessState) {
//           DialogUtils.hideLoading(context: context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('account_updated_successfully'.tr()),
//               backgroundColor: AppColors.success,
//             ),
//           );
//           Navigator.popUntil(context, (route) => route.isFirst);
//         } else if (state is EditPlatformAccountErrorState) {
//           DialogUtils.hideLoading(context: context);
//           DialogUtils.showMessage(
//             context: context,
//             message: state.message,
//             title: 'error'.tr(),
//             posActionText: 'ok'.tr(),
//           );
//         }
//       },
//       child: SafeArea(
//         bottom: true,
//         top: false,
//         child: GestureDetector(
//           onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//           child: Scaffold(
//             appBar: _builtAppBar(),
//             body: SingleChildScrollView(
//               padding: EdgeInsets.all(context.width * 0.05),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   spacing: context.height * 0.02,
//                   children: [
//                     _builtPlatformTile(),
//                     SizedBox(height: context.height * 0.03),
//                     EmailTextFieldWidget(
//                       fillColor: AppColors.secondary,
//                       controller: emailController,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         PasswordTextFieldWidget(
//                           fillColor: AppColors.secondary,
//                           controller: passwordController,
//                         ),
//                         _builtGeneratePassword(),
//                       ],
//                     ),
//                     _builtMultiSelectLoginProvider(),
//                     _builtNotesTextField(),
//                     _builtMoreInformationExpansionTile(),
//                     const SizedBox(height: 20),
//                     _builtSaveChangesButton(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _builtMultiSelectLoginProvider() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('login_provider'.tr(), style: AppStyles.robotoBold14gray(context)),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 8,
//           children: LoginProvider.values.map((provider) {
//             final isSelected = selectedLoginProviders.contains(provider);
//             return FilterChip(
//               label: Text(
//                 provider.name.tr(),
//                 style: AppStyles.robotoRegular14White(context).copyWith(
//                   color: isSelected ? Colors.white : AppColors.surfaceDark,
//                 ),
//               ),
//               selected: isSelected,
//               onSelected: (bool selected) {
//                 setState(() {
//                   if (selected) {
//                     selectedLoginProviders.add(provider);
//                   } else {
//                     selectedLoginProviders.remove(provider);
//                   }
//                 });
//               },
//               selectedColor: AppColors.primary,
//               checkmarkColor: Colors.white,
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   Widget _builtMoreInformationExpansionTile() {
//     return ExpansionTile(
//       title: Text(
//         'more_information'.tr(),
//         style: AppStyles.robotoRegular14(
//           context,
//           lColor: AppColors.surfaceDark,
//           dColor: AppColors.secondary,
//         ),
//       ),
//       splashColor: AppColors.transparent,
//       collapsedIconColor: context.easyColor(
//         lColor: AppColors.backgroundDark,
//         dColor: AppColors.backgroundLight,
//       ),
//       tilePadding: EdgeInsets.zero,
//       shape: Border.all(width: 0, color: AppColors.transparent),
//       maintainState: true,
//       collapsedShape: Border.all(width: 0, color: AppColors.transparent),
//       iconColor: context.easyColor(
//         lColor: AppColors.backgroundDark,
//         dColor: AppColors.backgroundLight,
//       ),
//       children: [
//         CustomTextFormField(
//           labelText: 'recovery_codes'.tr(),
//           labelStyle: AppStyles.robotoBold14gray(context),
//           controller: recoveryCodesController,
//           maxLines: 3,
//           style: AppStyles.robotoBold16SurfaceDark(context),
//           filled: true,
//           fillColor: AppColors.secondary,
//         ),
//         SizedBox(height: context.height * 0.02),
//         CustomTextFormField(
//           labelText: 'pass_key'.tr(),
//           labelStyle: AppStyles.robotoBold14gray(context),
//           controller: passkeyController,
//           style: AppStyles.robotoBold16SurfaceDark(context),
//           filled: true,
//           fillColor: AppColors.secondary,
//         ),
//       ],
//     );
//   }
//
//   PreferredSizeWidget _builtAppBar() {
//     return AppBar(
//       leading: IconButton(
//         onPressed: () => Navigator.pop(context),
//         icon: const Icon(Icons.arrow_back_ios_new_rounded),
//       ),
//       title: Text('edit_account'.tr()),
//       elevation: 0,
//     );
//   }
//
//   Widget _builtPlatformTile() {
//     return ListTile(
//       splashColor: AppColors.transparent,
//       contentPadding: EdgeInsets.zero,
//       title: Text(
//         widget.account.platform.name,
//         style: AppStyles.robotoRegular18(
//           context,
//           lColor: AppColors.backgroundDark,
//           dColor: AppColors.secondary,
//         ),
//       ),
//       leading: CircleAvatar(
//         backgroundColor: context.easyColor(
//           lColor: AppColors.primary,
//           dColor: AppColors.secondary,
//         ),
//         radius: context.width * 0.07,
//         child: Image.network(widget.account.platform.icon, width: 24),
//       ),
//       subtitle: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Text(
//           widget.account.platform.website,
//           style: AppStyles.robotoRegular12Secondary(
//             context,
//           ).copyWith(color: AppColors.success),
//         ),
//       ),
//     );
//   }
//
//   Widget _builtGeneratePassword() {
//     return Builder(
//       builder: (context) {
//         return TextButton.icon(
//           onPressed: () {
//             final pass = context
//                 .read<PlatformAccountCubit>()
//                 .generateStrongPassword();
//             passwordController.text = pass;
//           },
//           icon: Icon(
//             Icons.refresh,
//             color: context.easyColor(
//               lColor: AppColors.backgroundDark,
//               dColor: AppColors.secondary,
//             ),
//           ),
//           label: Text(
//             'generate_strong_password'.tr(),
//             style: AppStyles.robotoRegular14(
//               context,
//               lColor: AppColors.backgroundDark,
//               dColor: AppColors.secondary,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _builtNotesTextField() {
//     return CustomTextFormField(
//       controller: notesController,
//       hintText: 'notes'.tr(),
//       maxLines: 3,
//       hintStyle: AppStyles.robotoBold14gray(context),
//       style: AppStyles.robotoBold16SurfaceDark(context),
//       filled: true,
//       fillColor: AppColors.secondary,
//     );
//   }
//
//   Widget _builtSaveChangesButton() {
//     return Builder(
//       builder: (context) {
//         return CustomElevatedButton(
//           backgroundColor: context.easyColor(
//             lColor: AppColors.backgroundDark,
//             dColor: AppColors.primary,
//           ),
//           onPressed: () {
//             if (formKey.currentState!.validate()) {
//               final userId = context.read<UserCubit>().currentUser?.id ?? '';
//               context.read<PlatformAccountCubit>().updatePlatformAccount(
//                 userId: userId,
//                 emailOrUsername: emailController.text,
//                 password: passwordController.text,
//                 notes: notesController.text,
//                 originalAccount: widget.account,
//                 loginProviders: selectedLoginProviders,
//                 recoveryCodes: recoveryCodesController.text,
//                 passkey: passkeyController.text,
//               );
//             }
//           },
//           child: Text(
//             'save_changes'.tr(),
//             style: AppStyles.robotoRegular16White(context),
//           ),
//         );
//       },
//     );
//   }
}
