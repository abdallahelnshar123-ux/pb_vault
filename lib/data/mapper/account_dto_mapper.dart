import 'package:pb_vault/data/mapper/platform_data_dto_mapper.dart';

import '../../domain/entities/response/platform_account/platform_account.dart';
import '../model/response/platform_account_dto/platform_account_dto.dart';


extension AccountDtoMapper on PlatformAccount {
  PlatformAccountDto toAccountDto() {
    return PlatformAccountDto(
      id: id,
      platform: platform.toPlatformDataDto(),
      encryptedPassword: encryptedPassword,
      notes: notes,
      createdAt: createdAt,
      emailOrUsername: emailOrUsername,
      mac: mac,
      nonce: nonce,
    );
  }
}
