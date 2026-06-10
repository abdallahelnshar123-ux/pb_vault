import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class VaultCryptoService {
  final Cryptography _cryptography;

  SecretKey? _secretKey;
  final Pbkdf2 _pbkdf2;

  VaultCryptoService(this._cryptography, this._pbkdf2);

  void setSecretKey(SecretKey key) {
    _secretKey = key;
  }

  SecretKey get secretKey {
    return _secretKey!;
  }

  Future<Map<String, Object>> createVerifier({required String password}) async {
    final salt = randomBytes(16);

    final hash = await _cryptography.sha256().hash([
      ...utf8.encode(password),
      ...salt,
    ]);
    final secretKey = await _pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
    setSecretKey(secretKey);

    return {'salt': salt, 'hash': base64Encode(hash.bytes)};
  }

  Future<String> verifyVerifier({
    required String password,
    required List<int> salt,
  }) async {
    final hash = await _cryptography.sha256().hash([
      ...utf8.encode(password),
      ...salt,
    ]);

    return base64Encode(hash.bytes);
  }

  Future<bool> verifyMasterPassword({
    required String masterPassword,
    required List<int> salt,
    required String passwordVerifier,
  }) async {
    final verifier = await verifyVerifier(password: masterPassword, salt: salt);

    if (passwordVerifier == verifier) {
      final secretKey = await _pbkdf2.deriveKey(
        secretKey: SecretKey(utf8.encode(masterPassword)),
        nonce: salt,
      );

      setSecretKey(secretKey);
      return true;
    }
    return false;
  }

  Future<SecretBox> encryptPassword({required String password}) async {
    final nonce = randomBytes(12);

    final encrypted = await _cryptography.aesGcm().encrypt(
      utf8.encode(password),
      secretKey: _secretKey!,
      nonce: nonce,
    );

    return encrypted;
  }

  Future<String> decryptPassword({
    required Mac mac,
    required var cipherText,
    required List<int> nonce,
  }) async {
    final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);

    final bytes = await _cryptography.aesGcm().decrypt(
      secretBox,
      secretKey: _secretKey!,
    );

    return utf8.decode(bytes);
  }

  void clear() {
    _secretKey = null;
  }
}
