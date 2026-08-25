import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pb_vault/core/services/vault_crypto_service/vault_crypto_service.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/encrypted_data_dto.dart';

void main() {
  late VaultCryptoService vault;
  late Cryptography cryptography;
  late Pbkdf2 pbkdf2;

  setUp(() {
    cryptography = Cryptography.instance;
    // Standard PBKDF2 configuration used in the app
    pbkdf2 = Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 100000, bits: 256);
    vault = VaultCryptoService(cryptography, pbkdf2);
  });

  const tPassword = 'password123';
  final tSalt = List.generate(16, (i) => i);

  group('Initial State', () {
    test('should be locked when initialized', () {
      expect(vault.isLocked, isTrue);
    });
  });

  group('calculateVerifier', () {
    test('should return correct base64 encoded hash', () async {
      // Act
      final verifier = await vault.calculateVerifier(
        password: tPassword,
        salt: tSalt,
      );

      // Assert
      expect(verifier, isA<String>());
      expect(verifier, isNotEmpty);
      // Verifying deterministic nature
      final secondVerifier = await vault.calculateVerifier(
        password: tPassword,
        salt: tSalt,
      );
      expect(verifier, equals(secondVerifier));
    });
  });

  group('createVerifier', () {
    test('should create salt and hash and unlock the vault', () async {
      // Act
      final result = await vault.createVerifier(tPassword);

      // Assert
      expect(result['salt'], isA<List<int>>());
      expect(result['salt'], hasLength(16));
      expect(result['hash'], isA<String>());
      expect(vault.isLocked, isFalse);
    });

    test('should generate different salt and hash each time', () async {
      // Act
      final first = await vault.createVerifier(tPassword);
      final second = await vault.createVerifier(tPassword);

      // Assert
      expect(first['salt'], isNot(equals(second['salt'])));
      expect(first['hash'], isNot(equals(second['hash'])));
    });
  });

  group('lock', () {
    test('should lock the vault and clear secret key', () async {
      // Arrange
      await vault.createVerifier(tPassword);
      expect(vault.isLocked, isFalse);

      // Act
      vault.lock();

      // Assert
      expect(vault.isLocked, isTrue);
      expect(() => vault.getSecretKeyBytes(), throwsA(isA<Exception>()));
    });
  });

  group('unlock', () {
    test(
      'should unlock vault when password and verifier are correct',
      () async {
        // Arrange
        final result = await vault.createVerifier(tPassword);
        vault.lock();

        // Act
        final success = await vault.unlock(
          password: tPassword,
          salt: result['salt'],
          verifier: result['hash'],
        );

        // Assert
        expect(success, isTrue);
        expect(vault.isLocked, isFalse);
      },
    );

    test('should return false when password is incorrect', () async {
      // Arrange
      final result = await vault.createVerifier(tPassword);
      vault.lock();

      // Act
      final success = await vault.unlock(
        password: 'wrong_password',
        salt: result['salt'],
        verifier: result['hash'],
      );

      // Assert
      expect(success, isFalse);
      expect(vault.isLocked, isTrue);
    });
  });

  group('unlockWithKey', () {
    test('should unlock vault with provided key bytes', () async {
      // Arrange
      final keyBytes = List.generate(32, (i) => i);

      // Act
      vault.unlockWithKey(keyBytes);

      // Assert
      expect(vault.isLocked, isFalse);
      expect(await vault.getSecretKeyBytes(), equals(keyBytes));
    });
  });

  group('getSecretKeyBytes', () {
    test('should throw Exception when vault is locked', () async {
      await expectLater(vault.getSecretKeyBytes(), throwsA(isA<Exception>()));
    });

    test('should return 32 bytes when unlocked (AES-256)', () async {
      // Arrange
      await vault.createVerifier(tPassword);

      // Act
      final bytes = await vault.getSecretKeyBytes();

      // Assert
      expect(bytes, hasLength(32));
    });
  });

  group('encrypt & decrypt', () {
    const tPlainText = 'Secret message';

    test('should encrypt and decrypt correctly', () async {
      // Arrange
      await vault.createVerifier(tPassword);

      // Act
      final encrypted = await vault.encrypt(tPlainText);
      final decrypted = await vault.decrypt(encrypted);

      // Assert
      expect(decrypted, equals(tPlainText));
      expect(encrypted.cipherText, isNot(equals(tPlainText.codeUnits)));
    });

    test('should throw Exception when encrypting while locked', () async {
      await expectLater(vault.encrypt(tPlainText), throwsA(isA<Exception>()));
    });

    test('should throw Exception when decrypting while locked', () async {
      final encrypted = EncryptedDataDto(cipherText: [], nonce: [], mac: []);
      await expectLater(vault.decrypt(encrypted), throwsA(isA<Exception>()));
    });

    test(
      'should throw SecretBoxAuthenticationError when MAC is invalid',
      () async {
        // Arrange
        await vault.createVerifier(tPassword);
        final encrypted = await vault.encrypt(tPlainText);

        final invalidMac = [...encrypted.mac];
        invalidMac[0] ^= 0x01;

        final invalidEncrypted = EncryptedDataDto(
          cipherText: encrypted.cipherText,
          nonce: encrypted.nonce,
          mac: invalidMac,
        );

        await expectLater(
          vault.decrypt(invalidEncrypted),
          throwsA(isA<SecretBoxAuthenticationError>()),
        );
      },
    );
  });

  group('Multiple Operations', () {
    final tTexts = ['message 1', 'message 2', null, '', '   ', 'message 3'];

    test(
      'should encrypt multiple items correctly handling nulls/empty',
      () async {
        // Arrange
        await vault.createVerifier(tPassword);

        // Act
        final encryptedList = await vault.encryptMultiple(tTexts);

        // Assert
        expect(encryptedList, hasLength(tTexts.length));
        expect(encryptedList[0], isNotNull);
        expect(encryptedList[1], isNotNull);
        expect(encryptedList[2], isNull);
        expect(encryptedList[3], isNull);
        expect(encryptedList[4], isNull);
        expect(encryptedList[5], isNotNull);
      },
    );

    test('should decrypt multiple items successfully', () async {
      // Arrange
      await vault.createVerifier(tPassword);
      final encryptedList = await vault.encryptMultiple(tTexts);

      // Act
      final decryptedList = await vault.decryptMultiple(encryptedList);

      // Assert
      expect(decryptedList, hasLength(tTexts.length));
      expect(decryptedList[0], equals(tTexts[0]));
      expect(decryptedList[1], equals(tTexts[1]));
      expect(decryptedList[2], isNull);
      expect(decryptedList[3], isNull);
      expect(decryptedList[4], isNull);
      expect(decryptedList[5], equals(tTexts[5]));
    });

    test('should throw Exception when encryptMultiple while locked', () async {
      await expectLater(
        vault.encryptMultiple(['test']),
        throwsA(isA<Exception>()),
      );
    });
  });
}
