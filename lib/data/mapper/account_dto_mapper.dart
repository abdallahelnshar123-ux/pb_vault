import 'package:pb_vault/data/mapper/custom_field_dto_mapper.dart';
import 'package:pb_vault/data/mapper/encrypted_data_dto_mapper.dart';
import 'package:pb_vault/data/mapper/login_method_dto_mapper.dart';
import 'package:pb_vault/data/mapper/platform_data_dto_mapper.dart';

import '../../domain/entities/response/platform_account/platform_account.dart';
import '../model/response/platform_account_dto/platform_account_dto.dart';

extension AccountDtoMapper on PlatformAccount {
  // PlatformAccountDto toAccountDto() {
  //   return PlatformAccountDto(
  //     id: id,
  //     platform: platform.toPlatformDataDto(),
  //     identifier: identifier,
  //     password: password?.toEncryptedDataDto(),
  //     loginMethods: loginMethods.map((e) => e.toLoginMethodDto()).toList(),
  //     recoveryCodes: recoveryCodes?.toEncryptedDataDto(),
  //     passkey: passkey?.toEncryptedDataDto(),
  //     twoFactorSecret: twoFactorSecret?.toEncryptedDataDto(),
  //     notes: notes?.toEncryptedDataDto(),
  //     customFields: customFields.map((e) => e.toCustomFieldDto()).toList(),
  //     createdAt: createdAt,
  //   );
  // }
}
