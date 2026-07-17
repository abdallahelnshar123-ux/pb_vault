import '../../../../domain/entities/vault/encrypted_data.dart';

abstract class VaultRemoteDataSource {
  Future<EncryptedData> encrypt(String text);

  Future<String> decrypt(EncryptedData data);

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
