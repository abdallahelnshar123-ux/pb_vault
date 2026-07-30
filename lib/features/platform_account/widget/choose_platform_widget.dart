// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easy_theme/flutter_easy_theme.dart';
// import 'package:pb_vault/features/platform_account/widget/platforms_bottom_sheet.dart';
//
// import '../../../core/utils/app_colors.dart';
// import '../../../core/utils/app_styles.dart';
// import '../../../core/utils/screen_size.dart';
// import '../../../core/utils/snack_bar_utils.dart';
// import '../../../domain/entities/response/platform_account/platform_data.dart';
//
// class ChoosePlatformWidget extends StatefulWidget {
//   const ChoosePlatformWidget({super.key});
//
//   @override
//   State<ChoosePlatformWidget> createState() => _ChoosePlatformWidgetState();
// }
//
// class _ChoosePlatformWidgetState extends State<ChoosePlatformWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return    ValueListenableBuilder<PlatformData?>(
//       valueListenable: currentPlatform,
//       builder: (context, value, child) {
//         if (value == null) {
//           return TextButton.icon(
//             onPressed: () => _showPlatformPicker(context),
//             iconAlignment: IconAlignment.start,
//             icon: Icon(
//               Icons.add,
//               color: context.easyColor(
//                 lColor: AppColors.backgroundDark,
//                 dColor: AppColors.secondary,
//               ),
//               size: context.width * 0.08,
//             ),
//             label: Text(
//               'choose_platform'.tr(),
//               style: AppStyles.robotoRegular18(
//                 context,
//                 lColor: AppColors.backgroundDark,
//                 dColor: AppColors.secondary,
//               ),
//             ),
//           );
//         }
//         return ListTile(
//           splashColor: AppColors.transparent,
//           contentPadding: EdgeInsets.zero,
//           onLongPress: () {
//             if (currentPlatform.value?.website != null) {
//               Clipboard.setData(
//                 ClipboardData(text: currentPlatform.value!.website),
//               ).then((_) {
//                 if (!context.mounted) return;
//                 SnackBarUtils.showSuccessSnackBar(
//                   context: context,
//                   message: 'link_copied_to_clipboard'.tr(),
//                 );
//               });
//             }
//           },
//           onTap: () => _showPlatformPicker(context),
//           title: Text(
//             currentPlatform.value?.name ?? '',
//             style: AppStyles.robotoRegular18(
//               context,
//               lColor: AppColors.backgroundDark,
//               dColor: AppColors.secondary,
//             ),
//           ),
//           leading: currentPlatform.value != null
//               ? CircleAvatar(
//             backgroundColor: context.easyColor(
//               lColor: AppColors.primary,
//               dColor: AppColors.secondary,
//             ),
//             radius: context.width * 0.07,
//             child: Image.network(currentPlatform.value!.icon, width: 24),
//           )
//               : const Icon(Icons.category, color: AppColors.black),
//           subtitle: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Text(
//               currentPlatform.value!.website,
//               style: AppStyles.robotoRegular12Secondary(
//                 context,
//               ).copyWith(color: AppColors.success),
//             ),
//           ),
//         );
//       },
//     );
//
//   }
//
//
//   void _showPlatformPicker(BuildContext context) {
//     FocusManager.instance.primaryFocus?.unfocus();
//     showModalBottomSheet(
//       showDragHandle: true,
//       useSafeArea: true,
//       enableDrag: false,
//       isScrollControlled: true,
//       constraints: BoxConstraints.tight(
//         Size(double.infinity, context.height - 150),
//       ),
//       backgroundColor: context.easyColor(
//         lColor: AppColors.primary,
//         dColor: AppColors.backgroundDark,
//       ),
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => PlatformsBottomSheet(
//         currentPlatform: currentPlatform.value,
//         newPlatform: (platform) {
//           currentPlatform.value = platform;
//         },
//       ),
//     );
//   }
//
// }
