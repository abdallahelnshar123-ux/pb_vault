import '../../../model/response/platform_account_dto/encrypted_data_dto.dart';

abstract class VaultRemoteDataSource {
  Future<EncryptedDataDto> encrypt(String text);

  Future<String> decrypt(EncryptedDataDto data);

  Future<List<EncryptedDataDto?>> encryptMultiple(List<String?> textList);

  Future<List<String?>> decryptMultiple(List<EncryptedDataDto?> dataList);

  Future<Map<String, dynamic>> createVerifier(String password);

  Future<String> calculateVerifier({
    required String password,
    required List<int> salt,
  });

  Future<List<int>> getSecretKeyBytes();

  Future<bool> unlock({
    required String password,
    required List<int> salt,
    required String verifier,
  });

  Future<void> unlockWithKey(List<int> keyBytes);

  void lock();

  bool get isLocked;
}
