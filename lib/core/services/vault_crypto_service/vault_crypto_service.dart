import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/entities/vault/encrypted_data.dart';

@lazySingleton
class VaultCryptoService {
  final Cryptography _cryptography;
  final Pbkdf2 _pbkdf2;

  SecretKey? _secretKey;

  VaultCryptoService(this._cryptography, this._pbkdf2);

  bool get isLocked => _secretKey == null;

  void lock() {
    _secretKey = null;
  }

  Future<String> _calculateVerifier({
    required String password,
    required List<int> salt,
  }) async {
    final hash = await _cryptography.sha256().hash([
      ...utf8.encode(password),
      ...salt,
    ]);

    return base64Encode(hash.bytes);
  }

  Future<void> _createSecretKey({
    required String password,
    required List<int> salt,
  }) async {
    final secretKey = await _pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );

    _secretKey = secretKey;
  }

  Future<List<int>> getSecretKeyBytes() async {
    if (_secretKey == null) {
      throw  Exception( 'Vault is locked.');
    }
    return await _secretKey!.extractBytes();
  }

  Future<Map<String, dynamic>> createVerifier(String password) async {
    final salt = randomBytes(16);

    final hash = await _calculateVerifier(password: password, salt: salt);

    await _createSecretKey(password: password, salt: salt);

    return {'salt': salt, 'hash': hash};
  }

  Future<bool> unlock({
    required String password,
    required List<int> salt,
    required String verifier,
  }) async {
    final calculatedVerifier = await _calculateVerifier(
      password: password,
      salt: salt,
    );

    if (verifier == calculatedVerifier) {
      await _createSecretKey(password: password, salt: salt);
      return true;
    }
    return false;
  }

  void unlockWithKey(List<int> keyBytes) {
    _secretKey = SecretKey(keyBytes);
  }

  Future<EncryptedData> encrypt(String text) async {
    if (_secretKey == null) {
      throw Exception('Vault is locked. Unlock it first.');
    }

    final nonce = randomBytes(12);

    final encrypted = await _cryptography.aesGcm().encrypt(
      utf8.encode(text),
      secretKey: _secretKey!,
      nonce: nonce,
    );

    return EncryptedData(
      cipherText: encrypted.cipherText,
      mac: encrypted.mac.bytes,
      nonce: encrypted.nonce,
    );
  }

  Future<String> decrypt(EncryptedData data) async {
    if (_secretKey == null) {
      throw Exception('Vault is locked. Unlock it first.');
    }

    final secretBox = SecretBox(
      data.cipherText,
      nonce: data.nonce,
      mac: Mac(data.mac),
    );

    final bytes = await _cryptography.aesGcm().decrypt(
      secretBox,
      secretKey: _secretKey!,
    );

    return utf8.decode(bytes);
  }
}
