import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/data/data_sources/remote/vault/vault_remote_data_source.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/repository/vault/vault_repository_impl.dart';
import 'package:pb_vault/domain/entities/response/platform_account/encrypted_data.dart';
import 'package:pb_vault/domain/failure/failure.dart';

class MockVaultRemoteDataSource extends Mock implements VaultRemoteDataSource {}

void main() {
  late MockVaultRemoteDataSource mockVaultRemoteDataSource;
  late VaultRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      const EncryptedData(cipherText: [], mac: [], nonce: []),
    );
  });

  setUp(() {
    mockVaultRemoteDataSource = MockVaultRemoteDataSource();
    repository = VaultRepositoryImpl(mockVaultRemoteDataSource);
  });

  group('VaultRepositoryImpl', () {
    const tText = 'test text';
    const tPassword = 'password123';
    const tSalt = [1, 2, 3];
    const tVerifier = 'verifier_hash';
    const tEncryptedData = EncryptedData(
      cipherText: [4, 5, 6],
      mac: [7, 8],
      nonce: [9, 10],
    );
    const tMessage = 'Error message';
    final tException = Exception(tMessage);
    const tUnexpectedException = UnexpectedException(message: tMessage, statusCode: null);

    group('encrypt', () {
      test('should return Right(EncryptedData) when data source succeeds', () async {
        // arrange
        when(() => mockVaultRemoteDataSource.encrypt(any()))
            .thenAnswer((_) async => tEncryptedData);

        // act
        final result = await repository.encrypt(tText);

        // assert
        expect(result, equals(const Right(tEncryptedData)));
        verify(() => mockVaultRemoteDataSource.encrypt(tText)).called(1);
        verifyNoMoreInteractions(mockVaultRemoteDataSource);
      });

      test('should return Left(UnexpectedFailure) when data source throws AppException', () async {
        // arrange
        when(() => mockVaultRemoteDataSource.encrypt(any())).thenThrow(tUnexpectedException);

        // act
        final result = await repository.encrypt(tText);

        // assert
        expect(result, const Left(UnexpectedFailure(tMessage)));
      });

      test('should return Left(UnexpectedFailure) when data source throws unexpected exception', () async {
        // arrange
        when(() => mockVaultRemoteDataSource.encrypt(any())).thenThrow(tException);

        // act
        final result = await repository.encrypt(tText);

        // assert
        expect(result, Left(UnexpectedFailure(tException.toString())));
      });
    });

    group('decrypt', () {
      test('should return Right(String) when data source succeeds', () async {
        // arrange
        when(() => mockVaultRemoteDataSource.decrypt(any()))
            .thenAnswer((_) async => tText);

        // act
        final result = await repository.decrypt(tEncryptedData);

        // assert
        expect(result, equals(const Right(tText)));
        verify(() => mockVaultRemoteDataSource.decrypt(tEncryptedData)).called(1);
      });

      test('should return Left(UnexpectedFailure) when data source throws AppException', () async {
        // arrange
        when(() => mockVaultRemoteDataSource.decrypt(any())).thenThrow(tUnexpectedException);

        // act
        final result = await repository.decrypt(tEncryptedData);

        // assert
        expect(result, const Left(UnexpectedFailure(tMessage)));
      });
    });

    group('createVerifier', () {
      test('should return Right(Map) when data source succeeds', () async {
        // arrange
        final tVerifierMap = {'salt': tSalt, 'hash': tVerifier};
        when(() => mockVaultRemoteDataSource.createVerifier(any()))
            .thenAnswer((_) async => tVerifierMap);

        // act
        final result = await repository.createVerifier(tPassword);

        // assert
        expect(result, equals(Right(tVerifierMap)));
        verify(() => mockVaultRemoteDataSource.createVerifier(tPassword)).called(1);
      });

      test('should return Left(UnexpectedFailure) when data source throws AppException', () async {
        // arrange
        when(() => mockVaultRemoteDataSource.createVerifier(any())).thenThrow(tUnexpectedException);

        // act
        final result = await repository.createVerifier(tPassword);

        // assert
        expect(result, const Left(UnexpectedFailure(tMessage)));
      });
    });

    group('getSecretKeyBytes', () {
      test('should return Right(List<int>) when data source succeeds', () async {
        // arrange
        const tBytes = [1, 1, 1];
        when(() => mockVaultRemoteDataSource.getSecretKeyBytes())
            .thenAnswer((_) async => tBytes);

        // act
        final result = await repository.getSecretKeyBytes();

        // assert
        expect(result, equals(const Right(tBytes)));
        verify(() => mockVaultRemoteDataSource.getSecretKeyBytes()).called(1);
      });

      test('should return Left(UnexpectedFailure) when data source throws AppException', () async {
        // arrange
        when(() => mockVaultRemoteDataSource.getSecretKeyBytes()).thenThrow(tUnexpectedException);

        // act
        final result = await repository.getSecretKeyBytes();

        // assert
        expect(result, const Left(UnexpectedFailure(tMessage)));
      });
    });

    group('unlock', () {
      test('should return Right(bool) when data source succeeds', () async {
        // arrange
        when(() => mockVaultRemoteDataSource.unlock(
              password: any(named: 'password'),
              salt: any(named: 'salt'),
              verifier: any(named: 'verifier'),
            )).thenAnswer((_) async => true);

        // act
        final result = await repository.unlock(
          password: tPassword,
          salt: tSalt,
          verifier: tVerifier,
        );

        // assert
        expect(result, const Right(true));
        verify(() => mockVaultRemoteDataSource.unlock(
              password: tPassword,
              salt: tSalt,
              verifier: tVerifier,
            )).called(1);
      });

      test('should return Left(UnexpectedFailure) when data source throws AppException', () async {
        // arrange
        when(() => mockVaultRemoteDataSource.unlock(
              password: any(named: 'password'),
              salt: any(named: 'salt'),
              verifier: any(named: 'verifier'),
            )).thenThrow(tUnexpectedException);

        // act
        final result = await repository.unlock(
          password: tPassword,
          salt: tSalt,
          verifier: tVerifier,
        );

        // assert
        expect(result, const Left(UnexpectedFailure(tMessage)));
      });
    });

    group('lock', () {
      test('should call data source lock', () {
        // act
        repository.lock();

        // assert
        verify(() => mockVaultRemoteDataSource.lock()).called(1);
      });
    });

    group('isLocked', () {
      test('should return value from data source isLocked', () {
        // arrange
        when(() => mockVaultRemoteDataSource.isLocked).thenReturn(true);

        // act
        final result = repository.isLocked;

        // assert
        expect(result, isTrue);
        verify(() => mockVaultRemoteDataSource.isLocked).called(1);
      });
    });
  });
}
