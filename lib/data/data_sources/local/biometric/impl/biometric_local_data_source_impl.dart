import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/data_bases/cache/local_storage.dart';
import '../../../../exceptions/app_exceptions.dart';
import '../biometric_local_data_source.dart';

@Injectable(as: BiometricLocalDataSource)
class BiometricLocalDataSourceImpl implements BiometricLocalDataSource {
  final LocalStorage _localStorage;

  BiometricLocalDataSourceImpl(this._localStorage);

  @override
  Future<void> saveSecretKey(List<int> secretKey) async {
    try {
      await _localStorage.saveSecretKey(secretKey);
    } catch (e) {
      throw CacheException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<Option<List<int>>> getSecretKey() async {
    try {
      final key = await _localStorage.secretKey;
      return key != null ? Some(key) : const None();
    } catch (e) {
      throw CacheException(message: e.toString(), statusCode: null);
    }
  }

  @override
  Future<void> deleteSecretKey() async {
    try {
      await _localStorage.deleteSecretKey();
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

  @override
  Future<void> setBiometricRejected(bool enabled) async {
    try {
      await _localStorage.setBiometricRejected(enabled);
    } catch (e) {
      throw CacheException(message: e.toString(), statusCode: null);
    }
  }

  @override
  bool isBiometricRejected() {
    try {
      return _localStorage.isBiometricRejected;
    } catch (e) {
      throw CacheException(message: e.toString(), statusCode: null);
    }
  }
}
