import 'dart:convert';
import 'dart:isolate';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:injectable/injectable.dart';

import '../../../data/model/response/platform_account_dto/encrypted_data_dto.dart';

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

  Future<String> calculateVerifier({
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
      throw Exception('Vault is locked.');
    }
    return await _secretKey!.extractBytes();
  }

  Future<Map<String, dynamic>> createVerifier(String password) async {
    final salt = randomBytes(16);

    final hash = await calculateVerifier(password: password, salt: salt);

    await _createSecretKey(password: password, salt: salt);

    return {'salt': salt, 'hash': hash};
  }

  Future<bool> unlock({
    required String password,
    required List<int> salt,
    required String verifier,
  }) async {
    final calculatedVerifier = await calculateVerifier(
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

  Future<EncryptedDataDto> encrypt(String text) async {
    if (_secretKey == null) {
      throw Exception('Vault is locked. Unlock it first.');
    }
    final algorithm = _cryptography.aesGcm();
    final nonce = algorithm.newNonce();

    final encrypted = await algorithm.encrypt(
      utf8.encode(text),
      secretKey: _secretKey!,
      nonce: nonce,
    );

    return EncryptedDataDto(
      cipherText: encrypted.cipherText,
      mac: encrypted.mac.bytes,
      nonce: encrypted.nonce,
    );
  }

  Future<String> decrypt(EncryptedDataDto data) async {
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

  Future<List<EncryptedDataDto?>> encryptMultiple(
    List<String?> textList,
  ) async {
    final secretKeyBytes = await getSecretKeyBytes();

    return await Isolate.run(() async {
      final algorithm = _cryptography.aesGcm();
      final secretKey = SecretKey(secretKeyBytes);

      final List<EncryptedDataDto?> results = [];

      for (final text in textList) {
        if (text == null || text.trim().isEmpty) {
          results.add(null);
          continue;
        }

        final nonce = algorithm.newNonce();
        final encrypted = await algorithm.encrypt(
          utf8.encode(text),
          secretKey: secretKey,
          nonce: nonce,
        );

        results.add(
          EncryptedDataDto(
            cipherText: encrypted.cipherText,
            mac: encrypted.mac.bytes,
            nonce: encrypted.nonce,
          ),
        );
      }
      return results;
    });
  }

  Future<List<String?>> decryptMultiple(
    List<EncryptedDataDto?> dataList,
  ) async {
    final secretKeyBytes = await getSecretKeyBytes();

    return await Isolate.run(() async {
      final algorithm = _cryptography.aesGcm();
      final secretKey = SecretKey(secretKeyBytes);

      final List<String?> results = [];

      for (final data in dataList) {
        if (data == null) {
          results.add(null);
          continue;
        }

        final secretBox = SecretBox(
          data.cipherText,
          nonce: data.nonce,
          mac: Mac(data.mac),
        );

        final bytes = await algorithm.decrypt(secretBox, secretKey: secretKey);
        results.add(utf8.decode(bytes));
      }
      return results;
    });
  }
}
