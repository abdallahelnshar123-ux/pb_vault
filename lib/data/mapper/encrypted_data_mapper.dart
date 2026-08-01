import '../../domain/entities/response/platform_account/encrypted_data.dart';
import '../model/response/platform_account_dto/encrypted_data_dto.dart';

extension EncryptedDataMapper on EncryptedDataDto {
  EncryptedData toEncryptedData() {
    return EncryptedData(cipherText: cipherText, nonce: nonce, mac: mac);
  }
}
