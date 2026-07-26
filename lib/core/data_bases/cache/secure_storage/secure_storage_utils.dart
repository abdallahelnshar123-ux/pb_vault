import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageUtils {
  final FlutterSecureStorage _storage;

  SecureStorageUtils(this._storage);

  Future<void> writeBytes(String key, List<int> value) async {
    await _storage.write(key: key, value: base64Encode(value));
  }

  Future<List<int>?> readBytes(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;
    return base64Decode(value);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> writeString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readString(String key) async {
    return await _storage.read(key: key);
  }
}
