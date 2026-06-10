import 'package:pb_vault/data/mapper/platform_data_mapper.dart';
import '../../domain/entities/response/account/account.dart';
import '../model/response/account/account_dto.dart';

extension AccountMapper on AccountDto {
  Account toAccount() {
    return Account(
      id: id,
      platform: platform.toPlatformData(),
      emailOrUsername: emailOrUsername,
      encryptedPassword: encryptedPassword,
      notes: notes,
      createdAt: createdAt,
      nonce: nonce ,
      mac: mac,
    );
  }
}
