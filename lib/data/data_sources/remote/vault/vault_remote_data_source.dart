import '../../../../domain/entities/response/platform_account/encrypted_data.dart';
import '../../../model/response/platform_account_dto/encrypted_data_dto.dart';

abstract class VaultRemoteDataSource {
  Future<EncryptedDataDto> encrypt(String text);

  Future<String> decrypt(EncryptedDataDto data);

  Future<Map<String, dynamic>> createVerifier(String password);

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
