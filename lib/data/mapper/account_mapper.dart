import 'package:pb_vault/data/mapper/platform_data_mapper.dart';

import '../../domain/entities/response/platform_account/platform_account.dart';
import '../model/response/platform_account_dto/platform_account_dto.dart';

extension AccountMapper on PlatformAccountDto {
  PlatformAccount toAccount() {
    return PlatformAccount(
      id: id,
      platform: platform.toPlatformData(),
      emailOrUsername: emailOrUsername,
      encryptedPassword: encryptedPassword,
      notes: notes,
      createdAt: createdAt,
      nonce: nonce,
      mac: mac,
    );
  }
}
