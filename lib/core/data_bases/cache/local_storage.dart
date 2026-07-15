import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:pb_vault/core/data_bases/cache/secure_storage/secure_storage_keys.dart';
import 'package:pb_vault/core/data_bases/cache/secure_storage/secure_storage_utils.dart';
import 'package:pb_vault/core/data_bases/cache/shared_prefs/shared_prefs_keys.dart';
import 'package:pb_vault/core/data_bases/cache/shared_prefs/shared_prefs_utils.dart';

import '../../../data/model/response/my_user_dto.dart';

@lazySingleton
class LocalStorage {
  final SharedPrefsUtils _sharedPrefs;
  final SecureStorageUtils _secureStorageUtils;

  LocalStorage(this._sharedPrefs, this._secureStorageUtils);

  bool get onboarding =>
      _sharedPrefs.getData<bool>(key: SharedPrefsKeys.onBoardingKey) ?? true;

  Future<void> setOnboardingDone() =>
      _sharedPrefs.saveData(key: SharedPrefsKeys.onBoardingKey, value: false);

  Future<void> setTheme(String value) =>
      _sharedPrefs.saveData(key: SharedPrefsKeys.appThemeKey, value: value);

  String? get token =>
      _sharedPrefs.getData<String>(key: SharedPrefsKeys.tokenKey);

  Future<void> saveToken(String token) =>
      _sharedPrefs.saveData(key: SharedPrefsKeys.tokenKey, value: token);

  Future<void> clearToken() =>
      _sharedPrefs.removeData(key: SharedPrefsKeys.tokenKey);

  Future<void> saveUser(MyUserDto user) async {
    await _sharedPrefs.saveData(
      key: SharedPrefsKeys.userKey,
      value: jsonEncode(user.toFireStore()),
    );
  }

  MyUserDto? getUser() {
    final data = _sharedPrefs.getData<String>(key: SharedPrefsKeys.userKey);
    if (data == null) return null;
    return MyUserDto.fromFireStore(jsonDecode(data));
  }

  Future<void> clearUser() =>
      _sharedPrefs.removeData(key: SharedPrefsKeys.userKey);

  bool get useBiometric =>
      _sharedPrefs.getData<bool>(key: SharedPrefsKeys.useBiometricKey) ?? false;

  Future<void> setUseBiometric(bool value) =>
      _sharedPrefs.saveData(key: SharedPrefsKeys.useBiometricKey, value: value);

  Future<void> saveSecretKey(List<int> secretKey) =>
      _secureStorageUtils.writeBytes(SecureStorageKeys.secretKey, secretKey);

  Future<List<int>?> get secretKey => _secureStorageUtils.readBytes(SecureStorageKeys.secretKey);

  Future<void> deleteSecretKey() => _secureStorageUtils.delete(SecureStorageKeys.secretKey);
}
