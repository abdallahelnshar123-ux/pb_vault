import 'package:flutter/material.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/features/platform_account/screens/platform_account_details_screen.dart';
import 'package:pb_vault/widgets/copy_account_password_button_widget.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';

class PasswordCardItem extends StatelessWidget {
  final List<PlatformAccount> accountsList;

  const PasswordCardItem({super.key, required this.accountsList});

  @override
  Widget build(BuildContext context) {
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
                    builder: (context) =>
                        PlatformAccountDetailsScreen(account: account),
                  ),
                );
              }
            },
            leading: CircleAvatar(
              backgroundColor: AppColors.backgroundDark,
              child: account.platform.icon.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        account.platform.icon,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Text(
                          account.platform.name[0].toUpperCase(),
                          style: AppStyles.interMedium14BackgroundDark,
                        ),
                      ),
                    )
                  : Text(
                      account.platform.name[0].toUpperCase(),
                      style: AppStyles.interMedium14BackgroundDark,
                    ),
            ),
            title: Text(
              account.platform.name,
              style: AppStyles.robotoBold16SurfaceDark(context),
            ),
            subtitle: Text(
              account.emailOrUsername,
              style: AppStyles.robotoELight12SurfaceDark(context),
            ),
            trailing: CopyAccountPasswordButtonWidget(
              account: account,
              iconColor: AppColors.surfaceDark,
            ),
          ),
        );
      },
    );
  }
}
