import 'package:pb_vault/data/mapper/platform_data_dto_mapper.dart';

import '../../domain/entities/response/account/account.dart';
import '../model/response/account/account_dto.dart';

extension AccountDtoMapper on Account {
  AccountDto toAccountDto() {
    return AccountDto(
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
