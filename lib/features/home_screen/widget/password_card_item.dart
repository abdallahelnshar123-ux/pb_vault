import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/features/auth/cubit/user_view_model.dart';
import 'package:pb_vault/features/platform_account/cubit/platform_account_view_model.dart';
import 'package:pb_vault/features/platform_account/screens/platform_account_details_screen.dart';
import 'package:pb_vault/widgets/platform_icon.dart';

import '../../../core/constants/platforms.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';

class PasswordCardItem extends StatelessWidget {
  final List<PlatformAccount> accountsList;

  const PasswordCardItem({super.key, required this.accountsList});

  @override
  Widget build(BuildContext context) {
    var platformsMain = platformMain;
    var platformsSecond = platformSecond;
    return ListView.separated(
      itemCount: accountsList.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: context.height * 0.015),
      itemBuilder: (context, index) {
        final account = accountsList[index];
        return Card(
          margin: EdgeInsets.zero,
          color: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () {
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      var userId = context.read<UserCubit>().currentUser?.id;
                      context.read<PlatformAccountCubit>().getAccountById(
                        userId: userId!,
                        accountId: account.id!,
                      );

                      return PlatformAccountDetailsScreen();
                    },
                  ),
                );
              }
            },
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: PlatformIcon(platformId: account.platformId),
            ),
            title: Text(
              platformsMain[account.platformId]?.name ??
                  platformsSecond[account.platformId]?.name ??
                  '',
              style: AppStyles.robotoBold16SurfaceDark(context),
            ),
            subtitle: Text(
              account.identifier,
              style: AppStyles.robotoELight12SurfaceDark(context),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.backgroundDark,
              size: context.width * 0.06,
            ),
          ),
        );
      },
    );
  }
}
