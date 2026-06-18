import '../../entities/vault/encrypted_data.dart';

abstract class VaultRepository {
  Future<EncryptedData> encrypt(String text);

  Future<String> decrypt(EncryptedData data);

  Future<Map<String, dynamic>> createVerifier(String password);

  Future<bool> unlock({
    required String password,
    required List<int> salt,
    required String verifier,
  });

  void lock();

  bool get isLocked;
}
