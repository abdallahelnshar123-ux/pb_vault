import 'package:flutter/material.dart';
import 'package:flutter_easy_theme/flutter_easy_theme.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/screen_size.dart';
import '../../../core/constants/app_constants.dart';

class SelectAvatarBottomSheet extends StatelessWidget {
  final ValueChanged<String> newAvatar;
  final String currentAvatar;

  const SelectAvatarBottomSheet({
    super.key,
    required this.newAvatar,
    required this.currentAvatar,
  });

  @override
  Widget build(BuildContext context) {
    const avatars = AppConstants.userAvatars;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: context.height * 0.03,
        horizontal: context.width * 0.025,
      ),

      decoration: BoxDecoration(
        color: context.easyColor(
          lColor: AppColors.primary,
          dColor: AppColors.backgroundDark,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: GridView.builder(
        padding: EdgeInsetsGeometry.all(context.width * 0.025),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          mainAxisExtent: 100,
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            if (currentAvatar == 'profile_avatar_${index + 1}') return;
            newAvatar('profile_avatar_${index + 1}');
            Navigator.pop(context);
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration( color: context.easyColor(
              lColor: AppColors.primary,
              dColor: AppColors.backgroundDark,
            ),),
            child: Stack(
              alignment: AlignmentGeometry.bottomRight,
              children: [
                CircleAvatar(
                  radius: double.infinity,
                  backgroundColor:   context.easyColor(
              lColor:    AppColors.backgroundDark,
              dColor:AppColors.primary,
            ),
                  child: SvgPicture.asset(
                    avatars['profile_avatar_${index + 1}']!,
                  ),
                ),
                Visibility(
                  visible: currentAvatar == 'profile_avatar_${index + 1}',
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
