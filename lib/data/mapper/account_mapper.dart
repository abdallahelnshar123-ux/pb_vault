import 'package:pb_vault/data/mapper/custom_field_mapper.dart';
import 'package:pb_vault/data/mapper/encrypted_data_mapper.dart';
import 'package:pb_vault/data/mapper/login_method_mapper.dart';
import 'package:pb_vault/data/mapper/platform_data_mapper.dart';

import '../../domain/entities/response/platform_account/platform_account.dart';
import '../model/response/platform_account_dto/platform_account_dto.dart';

extension AccountMapper on PlatformAccountDto {
  // PlatformAccount toAccount() {
  //   return PlatformAccount(
  //     id: id,
  //     platform: platform.toPlatformData(),
  //     identifier: identifier,
  //     password: password?.toEncryptedData(),
  //     loginMethods: loginMethods.map((e) => e.toLoginMethod()).toList(),
  //     recoveryCodes: recoveryCodes?.toEncryptedData(),
  //     passkey: passkey?.toEncryptedData(),
  //     twoFactorSecret: twoFactorSecret?.toEncryptedData(),
  //     notes: notes?.toEncryptedData(),
  //     customFields: customFields?.map((e) => e.toCustomField()).toList() ??[],
  //     createdAt: createdAt,
  //   );
  // }
}
