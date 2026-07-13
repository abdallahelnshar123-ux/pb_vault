import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/data_bases/cache/local_storage.dart';
import '../../../../../core/data_bases/secure_storage/secure_storage_keys.dart';
import '../../../../../core/data_bases/secure_storage/secure_storage_utils.dart';
import '../../../../exceptions/app_exceptions.dart';
import '../biometric_local_data_source.dart';

@Injectable(as: BiometricLocalDataSource)
class BiometricLocalDataSourceImpl implements BiometricLocalDataSource {
  final LocalStorage _localStorage;
  final SecureStorageUtils _secureStorage;

  BiometricLocalDataSourceImpl(this._localStorage, this._secureStorage);

  @override
  Future<void> saveSecretKey(List<int> secretKey) async {
    try {
      await _secureStorage.writeBytes(SecureStorageKeys.secretKey, secretKey);
    } catch (e) {
      throw CacheException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<Option<List<int>>> getSecretKey() async {
    try {
      final key = await _secureStorage.readBytes(SecureStorageKeys.secretKey);
      return key != null ? Some(key) : const None();
    } catch (e) {
      throw CacheException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<void> deleteSecretKey() async {
    try {
      await _secureStorage.delete(SecureStorageKeys.secretKey);
    } catch (e) {
      throw CacheException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _localStorage.setUseBiometric(enabled);
    } catch (e) {
      throw CacheException(message: e.toString(), statusCode: null);
    }
  }

  @override
  bool isBiometricEnabled() {
    try {
      return _localStorage.useBiometric;
    } catch (e) {
      throw CacheException(message: e.toString(), statusCode: null);
    }
  }
}
