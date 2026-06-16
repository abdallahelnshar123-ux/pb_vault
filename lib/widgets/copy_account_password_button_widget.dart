import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pb_vault/core/services/vault_crypto_service/vault_crypto_service.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';

import '../core/di/di.dart';

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
        final password = await getIt<VaultCryptoService>().decryptPassword(
          mac: Mac(widget.account.mac),
          cipherText: widget.account.encryptedPassword,
          nonce: widget.account.nonce,
        );

        await Clipboard.setData(ClipboardData(text: password));
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
