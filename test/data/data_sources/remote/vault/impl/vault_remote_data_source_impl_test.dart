import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/core/services/vault_crypto_service/vault_crypto_service.dart';
import 'package:pb_vault/data/data_sources/remote/vault/impl/vault_remote_data_source_impl.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/encrypted_data_dto.dart';

class MockVaultCryptoService extends Mock implements VaultCryptoService {}

void main() {
  late MockVaultCryptoService mockVaultCryptoService;
  late VaultRemoteDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(
      const EncryptedDataDto(cipherText: [], mac: [], nonce: []),
    );
  });

  setUp(() {
    mockVaultCryptoService = MockVaultCryptoService();
    dataSource = VaultRemoteDataSourceImpl(mockVaultCryptoService);
  });

  group('VaultRemoteDataSourceImpl', () {
    const tText = 'test text';
    const tPassword = 'password123';
    const tSalt = [1, 2, 3];
    const tVerifier = 'verifier_hash';
    const tEncryptedDataDto = EncryptedDataDto(
      cipherText: [4, 5, 6],
      mac: [7, 8],
      nonce: [9, 10],
    );
    final tException = Exception('Crypto error');

    group('encrypt', () {
      test('should call vaultCryptoService.encrypt and return EncryptedData', () async {
        // arrange
        when(() => mockVaultCryptoService.encrypt(any()))
            .thenAnswer((_) async => tEncryptedDataDto);

        // act
        final result = await dataSource.encrypt(tText);

        // assert
        expect(result, tEncryptedDataDto);
        verify(() => mockVaultCryptoService.encrypt(tText)).called(1);
        verifyNoMoreInteractions(mockVaultCryptoService);
      });

      test('should throw UnexpectedException when crypto service fails', () async {
        // arrange
        when(() => mockVaultCryptoService.encrypt(any())).thenThrow(tException);

        // act
        final call = dataSource.encrypt;

        // assert
        expect(
          () => call(tText),
          throwsA(
            isA<UnexpectedException>().having(
              (e) => e.message,
              'message',
              contains(tException.toString()),
            ),
          ),
        );
      });
    });

    group('decrypt', () {
      test('should call vaultCryptoService.decrypt and return decrypted string', () async {
        // arrange
        when(() => mockVaultCryptoService.decrypt(any()))
            .thenAnswer((_) async => tText);

        // act
        final result = await dataSource.decrypt(tEncryptedDataDto);

        // assert
        expect(result, equals(tText));
        verify(() => mockVaultCryptoService.decrypt(tEncryptedDataDto)).called(1);
      });

      test('should throw UnexpectedException when decryption fails', () async {
        // arrange
        when(() => mockVaultCryptoService.decrypt(any())).thenThrow(tException);

        // act
        final call = dataSource.decrypt;

        // assert
        expect(
          () => call(tEncryptedDataDto),
          throwsA(
            isA<UnexpectedException>().having(
              (e) => e.message,
              'message',
              contains(tException.toString()),
            ),
          ),
        );
      });
    });

    group('createVerifier', () {
      test('should return verifier map from crypto service', () async {
        // arrange
        final tVerifierMap = {'salt': tSalt, 'hash': tVerifier};
        when(() => mockVaultCryptoService.createVerifier(any()))
            .thenAnswer((_) async => tVerifierMap);

        // act
        final result = await dataSource.createVerifier(tPassword);

        // assert
        expect(result, equals(tVerifierMap));
        verify(() => mockVaultCryptoService.createVerifier(tPassword)).called(1);
      });

      test('should throw UnexpectedException when creation fails', () async {
        // arrange
        when(() => mockVaultCryptoService.createVerifier(any())).thenThrow(tException);

        // act
        final call = dataSource.createVerifier;

        // assert
        expect(
          () => call(tPassword),
          throwsA(
            isA<UnexpectedException>().having(
              (e) => e.message,
              'message',
              contains(tException.toString()),
            ),
          ),
        );
      });
    });

    group('getSecretKeyBytes', () {
      test('should return bytes from crypto service', () async {
        // arrange
        const tBytes = [1, 1, 1];
        when(() => mockVaultCryptoService.getSecretKeyBytes())
            .thenAnswer((_) async => tBytes);

        // act
        final result = await dataSource.getSecretKeyBytes();

        // assert
        expect(result, equals(tBytes));
        verify(() => mockVaultCryptoService.getSecretKeyBytes()).called(1);
      });

      test('should throw UnexpectedException when retrieval fails', () async {
        // arrange
        when(() => mockVaultCryptoService.getSecretKeyBytes()).thenThrow(tException);

        // act
        final call = dataSource.getSecretKeyBytes;

        // assert
        expect(
          () => call(),
          throwsA(
            isA<UnexpectedException>().having(
              (e) => e.message,
              'message',
              contains(tException.toString()),
            ),
          ),
        );
      });
    });

    group('unlock', () {
      test('should return true when unlock is successful', () async {
        // arrange
        when(() => mockVaultCryptoService.unlock(
              password: any(named: 'password'),
              salt: any(named: 'salt'),
              verifier: any(named: 'verifier'),
            )).thenAnswer((_) async => true);

        // act
        final result = await dataSource.unlock(
          password: tPassword,
          salt: tSalt,
          verifier: tVerifier,
        );

        // assert
        expect(result, isTrue);
        verify(() => mockVaultCryptoService.unlock(
              password: tPassword,
              salt: tSalt,
              verifier: tVerifier,
            )).called(1);
      });

      test('should throw UnexpectedException when unlock throws exception', () async {
        // arrange
        when(() => mockVaultCryptoService.unlock(
              password: any(named: 'password'),
              salt: any(named: 'salt'),
              verifier: any(named: 'verifier'),
            )).thenThrow(tException);

        // act
        final call = dataSource.unlock;

        // assert
        expect(
          () => call(password: tPassword, salt: tSalt, verifier: tVerifier),
          throwsA(
            isA<UnexpectedException>().having(
              (e) => e.message,
              'message',
              contains(tException.toString()),
            ),
          ),
        );
      });
    });

    group('unlockWithKey', () {
      test('should call vaultCryptoService.unlockWithKey', () async {
        // arrange
        const tKeyBytes = [1, 2, 3];

        // act
        await dataSource.unlockWithKey(tKeyBytes);

        // assert
        verify(() => mockVaultCryptoService.unlockWithKey(tKeyBytes)).called(1);
      });

      test('should throw UnexpectedException when unlockWithKey throws exception', () async {
        // arrange
        const tKeyBytes = [1, 2, 3];
        when(() => mockVaultCryptoService.unlockWithKey(any())).thenThrow(tException);

        // act
        final call = dataSource.unlockWithKey;

        // assert
        expect(
          () => call(tKeyBytes),
          throwsA(
            isA<UnexpectedException>().having(
              (e) => e.message,
              'message',
              contains(tException.toString()),
            ),
          ),
        );
      });
    });

    group('lock', () {
      test('should call vaultCryptoService.lock', () {
        // arrange
        // void return, no need to stub unless using verify

        // act
        dataSource.lock();

        // assert
        verify(() => mockVaultCryptoService.lock()).called(1);
      });
    });

    group('isLocked', () {
      test('should return isLocked status from crypto service', () {
        // arrange
        when(() => mockVaultCryptoService.isLocked).thenReturn(true);

        // act
        final result = dataSource.isLocked;

        // assert
        expect(result, isTrue);
        verify(() => mockVaultCryptoService.isLocked).called(1);
      });
    });
  });
}
