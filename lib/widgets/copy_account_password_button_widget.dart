import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/features/home_screen/cubit/home_view_model.dart';

class CopyAccountPasswordButtonWidget extends StatefulWidget {
  const CopyAccountPasswordButtonWidget({
    super.key,
    required this.account,
    required this.iconColor,
  });

  final PlatformAccount account;

  final Color iconColor;

  @override
  State<CopyAccountPasswordButtonWidget> createState() =>
      _CopyAccountPasswordButtonWidgetState();
}

class _CopyAccountPasswordButtonWidgetState
    extends State<CopyAccountPasswordButtonWidget> {
  bool isPasswordCopy = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      isSelected: isPasswordCopy,
      selectedIcon: Icon(Icons.check, color: widget.iconColor),
      onPressed: () async {
        // final encryptedData = EncryptedData(
        //   cipherText: widget.account.encryptedPassword,
        //   mac: widget.account.mac,
        //   nonce: widget.account.nonce,
        // );

        // final password = await getIt<VaultRepository>().decrypt(encryptedData);
        //
        // await Clipboard.setData(ClipboardData(text: password));
        context.read<HomeCubit>().copyAccountPassword(account: widget.account);
        setState(() {
          isPasswordCopy = true;
        });
        Future.delayed(
          Duration(seconds: 2),
          () => setState(() {
            isPasswordCopy = false;
          }),
        );
      },
      icon: Icon(Icons.copy_all_outlined, color: widget.iconColor),
    );
  }
}
