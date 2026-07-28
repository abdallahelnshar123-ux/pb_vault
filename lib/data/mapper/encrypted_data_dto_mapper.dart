import '../../domain/entities/response/platform_account/encrypted_data.dart';
import '../model/response/platform_account_dto/encrypted_data_dto.dart';

extension EncryptedDataDtoMapper on EncryptedData {
  EncryptedDataDto toEncryptedDataDto() {
    return EncryptedDataDto(cipherText: cipherText, nonce: nonce, mac: mac);
  }
}
