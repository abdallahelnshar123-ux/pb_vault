import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pb_vault/core/services/vault_crypto_service/vault_crypto_service.dart';
import 'package:pb_vault/domain/entities/response/platform_account/encrypted_data.dart';

void main() {
  late VaultCryptoService vault;
  late Cryptography cryptography;
  late Pbkdf2 pbkdf2;

  setUp(() {
    cryptography = Cryptography.instance;

    pbkdf2 = Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 100000, bits: 256);

    vault = VaultCryptoService(cryptography, pbkdf2);
  });

  String tPassword = 'password123';

  group('initial state ', () {
    test('vault is locked at init so is locked must return true ', () {
      expect(vault.isLocked, isTrue);
    });
  });

  group('createVerifier', () {
    test('should create salt, hash and unlock the vault', () async {
      // Act
      final result = await vault.createVerifier(tPassword);

      // Assert
      expect(result['salt'], isA<List<int>>());
      expect(result['salt'], hasLength(16));

      expect(result['hash'], isA<String>());
      expect(result['hash'], isNotEmpty);

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
    test('should lock the vault', () async {
      // Arrange
      await vault.createVerifier(tPassword);

      expect(vault.isLocked, isFalse);

      // Act
      vault.lock();

      // Assert
      expect(vault.isLocked, isTrue);
    });

    test('should remain locked when lock is called on locked vault', () {
      // Arrange
      expect(vault.isLocked, isTrue);

      // Act
      vault.lock();

      // Assert
      expect(vault.isLocked, isTrue);
    });
  });

  group('unlock', () {
    test(
      'should unlock vault when password and verifier are correct',
      () async {
        // Arrange
        final result = await vault.createVerifier('123456');

        vault.lock();

        expect(vault.isLocked, isTrue);

        // Act
        final unlocked = await vault.unlock(
          password: '123456',
          salt: result['salt'],
          verifier: result['hash'],
        );

        // Assert
        expect(unlocked, isTrue);
        expect(vault.isLocked, isFalse);
      },
    );
    test('should return false when password is incorrect', () async {
      // Arrange
      final result = await vault.createVerifier('123456');

      vault.lock();

      // Act
      final unlocked = await vault.unlock(
        password: '654321',
        salt: result['salt'],
        verifier: result['hash'],
      );

      // Assert
      expect(unlocked, isFalse);
      expect(vault.isLocked, isTrue);
    });

    test('should return false when verifier is incorrect', () async {
      // Arrange
      final result = await vault.createVerifier('123456');

      vault.lock();

      // Act
      final unlocked = await vault.unlock(
        password: '123456',
        salt: result['salt'],
        verifier: 'invalid verifier',
      );

      // Assert
      expect(unlocked, isFalse);
      expect(vault.isLocked, isTrue);
    });
  });

  group('encrypt', () {
    test('should throw exception when vault is locked', () async {
      // Arrange
      expect(vault.isLocked, isTrue);

      // Act & Assert
      expect(() => vault.encrypt('Hello World'), throwsA(isA<Exception>()));
    });

    test('should encrypt text successfully', () async {
      // Arrange
      await vault.createVerifier('123456');

      // Act
      final encrypted = await vault.encrypt('Hello World');

      // Assert
      expect(encrypted, isA<EncryptedData>());
      expect(encrypted.cipherText, isNotEmpty);
      expect(encrypted.mac, isNotEmpty);
      expect(encrypted.nonce, hasLength(12));
    });

    test(
      'should generate different ciphertext for the same plaintext',
      () async {
        // Arrange
        await vault.createVerifier('123456');

        // Act
        final first = await vault.encrypt('Hello World');
        final second = await vault.encrypt('Hello World');

        // Assert
        expect(first.cipherText, isNot(equals(second.cipherText)));

        expect(first.nonce, isNot(equals(second.nonce)));
      },
    );
  });

  group('decrypt', () {
    test('should throw exception when vault is locked', () async {
      // Arrange
      final encryptedData = EncryptedData(
        cipherText: [1, 2, 3],
        mac: [4, 5, 6],
        nonce: List.filled(12, 0),
      );

      expect(vault.isLocked, isTrue);

      // Act & Assert
      expect(() => vault.decrypt(encryptedData), throwsA(isA<Exception>()));
    });

    test('should decrypt encrypted text successfully', () async {
      // Arrange
      await vault.createVerifier('123456');

      const text = 'Hello World';

      final encrypted = await vault.encrypt(text);

      // Act
      final decrypted = await vault.decrypt(encrypted);

      // Assert
      expect(decrypted, equals(text));
    });

    test('should throw when decrypting with different key', () async {
      // Arrange
      await vault.createVerifier('123456');

      final encrypted = await vault.encrypt('Hello World');

      vault.lock();

      await vault.createVerifier('654321');

      // Act & Assert
      expect(
        () => vault.decrypt(encrypted),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );
    });
  });
}
