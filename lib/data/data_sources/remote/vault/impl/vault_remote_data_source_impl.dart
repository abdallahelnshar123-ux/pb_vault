import 'package:injectable/injectable.dart';
import '../../../../../core/services/vault_crypto_service/vault_crypto_service.dart';
import '../../../../../domain/entities/vault/encrypted_data.dart';
import '../../../../exceptions/app_exceptions.dart';
import '../vault_remote_data_source.dart';

@Injectable(as: VaultRemoteDataSource)
class VaultRemoteDataSourceImpl implements VaultRemoteDataSource {
  final VaultCryptoService _vaultCryptoService;

  VaultRemoteDataSourceImpl(this._vaultCryptoService);

  @override
  Future<EncryptedData> encrypt(String text) async {
    try {
      return await _vaultCryptoService.encrypt(text);
    }  catch (e) {
      throw UnexpectedException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<String> decrypt(EncryptedData data) async {
    try {
      return await _vaultCryptoService.decrypt(data);
    }  catch (e) {
      throw UnexpectedException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<Map<String, dynamic>> createVerifier(String password) async {
    try {
      return await _vaultCryptoService.createVerifier(password);
    } catch (e) {
      throw UnexpectedException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<List<int>> getSecretKeyBytes() async {
    try {
      return await _vaultCryptoService.getSecretKeyBytes();
    } catch (e) {
      throw UnexpectedException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<bool> unlock({
    required String password,
    required List<int> salt,
    required String verifier,
  }) async {
    try {
      return await _vaultCryptoService.unlock(
        password: password,
        salt: salt,
        verifier: verifier,
      );
    } catch (e) {
      throw UnexpectedException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<void> unlockWithKey(List<int> keyBytes) async {
    try {
      _vaultCryptoService.unlockWithKey(keyBytes);
    } catch (e) {
      throw UnexpectedException(message: e.toString(), statusCode: null);
    }
  }

  @override
  void lock() {
    _vaultCryptoService.lock();
  }

  @override
  bool get isLocked => _vaultCryptoService.isLocked;
}
