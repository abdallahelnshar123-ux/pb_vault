import 'package:injectable/injectable.dart';

import '../../../../../core/services/vault_crypto_service/vault_crypto_service.dart';
import '../../../../exceptions/app_exceptions.dart';
import '../../../../model/response/platform_account_dto/encrypted_data_dto.dart';
import '../vault_remote_data_source.dart';

@Injectable(as: VaultRemoteDataSource)
class VaultRemoteDataSourceImpl implements VaultRemoteDataSource {
  final VaultCryptoService _vaultCryptoService;

  VaultRemoteDataSourceImpl(this._vaultCryptoService);

  @override
  Future<EncryptedDataDto> encrypt(String text) async {
    try {
      return await _vaultCryptoService.encrypt(text);
    } catch (e) {
      throw UnexpectedException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<String> decrypt(EncryptedDataDto data) async {
    try {
      return await _vaultCryptoService.decrypt(data);
    } catch (e) {
      throw UnexpectedException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<List<EncryptedDataDto?>> encryptMultiple(List<String?> textList) async {
    try {
      return await _vaultCryptoService.encryptMultiple(textList);
    } catch (e) {
      throw UnexpectedException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<List<String?>> decryptMultiple(List<EncryptedDataDto?> dataList) async {
    try {
      return await _vaultCryptoService.decryptMultiple(dataList);
    } catch (e) {
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
  Future<String> calculateVerifier({
    required String password,
    required List<int> salt,
  }) async {
    try {
      return await _vaultCryptoService.calculateVerifier(
        password: password,
        salt: salt,
      );
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
