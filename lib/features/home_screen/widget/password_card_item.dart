import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/features/home_screen/cubit/home_view_model.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/screen_size.dart';
import '../cubit/home_state.dart';

class PasswordCardItem extends StatelessWidget {
  final HomeSuccess state;

  const PasswordCardItem({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: state.accounts.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: context.height * 0.015),
      itemBuilder: (context, index) {
        final account = state.accounts[index];
        return Card(
          margin: EdgeInsets.zero,
          color: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () async {
              // todo : open password
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
            trailing: IconButton(
              onPressed: () {
                context.read<HomeCubit>().copyAccountPassword(
                  account: account,
                  context: context,
                );
              },
              icon: const Icon(
                Icons.copy_all_outlined,
                color: AppColors.surfaceDark,
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }
}
