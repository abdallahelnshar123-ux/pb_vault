import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/data/data_sources/remote/vault/vault_remote_data_source.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/mapper/encrypted_data_dto_mapper.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/encrypted_data_dto.dart';
import 'package:pb_vault/data/repository/vault/vault_repository_impl.dart';
import 'package:pb_vault/domain/entities/response/platform_account/encrypted_data.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/vault/vault_repository.dart';

class MockVaultRemoteDataSource extends Mock implements VaultRemoteDataSource {}

void main() {
  late VaultRepository repository;
  late MockVaultRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    registerFallbackValue(
      const EncryptedDataDto(cipherText: [], mac: [], nonce: []),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockVaultRemoteDataSource();
    repository = VaultRepositoryImpl(mockRemoteDataSource);
  });

  const tText = 'test text';
  const tPassword = 'password123';
  const tSalt = [1, 2, 3];
  const tVerifier = 'verifier_hash';
  const tEncryptedDataDto = EncryptedDataDto(
    cipherText: [4, 5, 6],
    mac: [7, 8],
    nonce: [9, 10],
  );
  const tEncryptedData = EncryptedData(
    cipherText: [4, 5, 6],
    mac: [7, 8],
    nonce: [9, 10],
  );
  const tErrorMessage = 'error message';

  group('encrypt', () {
    test('should return Right(EncryptedData) when remote call is successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.encrypt(any()))
          .thenAnswer((_) async => tEncryptedDataDto);

      // Act
      final result = await repository.encrypt(tText);

      // Assert
      expect(result, equals(const Right(tEncryptedData)));
      verify(() => mockRemoteDataSource.encrypt(tText)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
        'should return Left(ServerFailure) when remote call throws ServerException',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.encrypt(any())).thenThrow(
          const ServerException(message: tErrorMessage, statusCode: 500));

      // Act
      final result = await repository.encrypt(tText);

      // Assert
      expect(result, const Left(ServerFailure(tErrorMessage)));
      verify(() => mockRemoteDataSource.encrypt(tText)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
        'should return Left(UnexpectedFailure) when remote call throws generic Exception',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.encrypt(any()))
          .thenThrow(Exception(tErrorMessage));

      // Act
      final result = await repository.encrypt(tText);

      // Assert
      expect(result, const Left(UnexpectedFailure('Exception: $tErrorMessage')));
      verify(() => mockRemoteDataSource.encrypt(tText)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('decrypt', () {
    test('should return Right(String) when remote call is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.decrypt(any()))
          .thenAnswer((_) async => tText);

      // Act
      final result = await repository.decrypt(tEncryptedData);

      // Assert
      expect(result, equals(const Right(tText)));
      verify(() => mockRemoteDataSource.decrypt(tEncryptedData.toEncryptedDataDto()))
          .called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return Left(Failure) when remote call fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.decrypt(any())).thenThrow(
          const ServerException(message: tErrorMessage, statusCode: 500));

      // Act
      final result = await repository.decrypt(tEncryptedData);

      // Assert
      expect(result, const Left(ServerFailure(tErrorMessage)));
      verify(() => mockRemoteDataSource.decrypt(any())).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('createVerifier', () {
    final tVerifierMap = {'salt': tSalt, 'hash': tVerifier};

    test('should return Right(Map) when remote call is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.createVerifier(any()))
          .thenAnswer((_) async => tVerifierMap);

      // Act
      final result = await repository.createVerifier(tPassword);

      // Assert
      expect(result, Right(tVerifierMap));
      verify(() => mockRemoteDataSource.createVerifier(tPassword)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return Left(Failure) when remote call fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.createVerifier(any())).thenThrow(
          const ServerException(message: tErrorMessage, statusCode: 500));

      // Act
      final result = await repository.createVerifier(tPassword);

      // Assert
      expect(result, const Left(ServerFailure(tErrorMessage)));
      verify(() => mockRemoteDataSource.createVerifier(tPassword)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('calculateVerifier', () {
    test('should return Right(String) when remote call is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.calculateVerifier(
            password: any(named: 'password'),
            salt: any(named: 'salt'),
          )).thenAnswer((_) async => tVerifier);

      // Act
      final result = await repository.calculateVerifier(
        password: tPassword,
        salt: tSalt,
      );

      // Assert
      expect(result, const Right(tVerifier));
      verify(() => mockRemoteDataSource.calculateVerifier(
            password: tPassword,
            salt: tSalt,
          )).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return Left(Failure) when remote call fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.calculateVerifier(
            password: any(named: 'password'),
            salt: any(named: 'salt'),
          )).thenThrow(
          const ServerException(message: tErrorMessage, statusCode: 500));

      // Act
      final result = await repository.calculateVerifier(
        password: tPassword,
        salt: tSalt,
      );

      // Assert
      expect(result, const Left(ServerFailure(tErrorMessage)));
      verify(() => mockRemoteDataSource.calculateVerifier(
            password: any(named: 'password'),
            salt: any(named: 'salt'),
          )).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('getSecretKeyBytes', () {
    const tBytes = [1, 1, 1];

    test('should return Right(List<int>) when remote call is successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.getSecretKeyBytes())
          .thenAnswer((_) async => tBytes);

      // Act
      final result = await repository.getSecretKeyBytes();

      // Assert
      expect(result, const Right(tBytes));
      verify(() => mockRemoteDataSource.getSecretKeyBytes()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return Left(Failure) when remote call fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.getSecretKeyBytes()).thenThrow(
          const ServerException(message: tErrorMessage, statusCode: 500));

      // Act
      final result = await repository.getSecretKeyBytes();

      // Assert
      expect(result, const Left(ServerFailure(tErrorMessage)));
      verify(() => mockRemoteDataSource.getSecretKeyBytes()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('unlock', () {
    test('should return Right(bool) when remote call is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.unlock(
            password: any(named: 'password'),
            salt: any(named: 'salt'),
            verifier: any(named: 'verifier'),
          )).thenAnswer((_) async => true);

      // Act
      final result = await repository.unlock(
        password: tPassword,
        salt: tSalt,
        verifier: tVerifier,
      );

      // Assert
      expect(result, const Right(true));
      verify(() => mockRemoteDataSource.unlock(
            password: tPassword,
            salt: tSalt,
            verifier: tVerifier,
          )).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return Left(Failure) when remote call fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.unlock(
            password: any(named: 'password'),
            salt: any(named: 'salt'),
            verifier: any(named: 'verifier'),
          )).thenThrow(
          const ServerException(message: tErrorMessage, statusCode: 500));

      // Act
      final result = await repository.unlock(
        password: tPassword,
        salt: tSalt,
        verifier: tVerifier,
      );

      // Assert
      expect(result, const Left(ServerFailure(tErrorMessage)));
      verify(() => mockRemoteDataSource.unlock(
            password: any(named: 'password'),
            salt: any(named: 'salt'),
            verifier: any(named: 'verifier'),
          )).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('unlockWithKey', () {
    const tKeyBytes = [1, 2, 3];

    test('should return Right(unit) when remote call is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.unlockWithKey(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.unlockWithKey(tKeyBytes);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockRemoteDataSource.unlockWithKey(tKeyBytes)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return Left(Failure) when remote call fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.unlockWithKey(any())).thenThrow(
          const ServerException(message: tErrorMessage, statusCode: 500));

      // Act
      final result = await repository.unlockWithKey(tKeyBytes);

      // Assert
      expect(result, const Left(ServerFailure(tErrorMessage)));
      verify(() => mockRemoteDataSource.unlockWithKey(tKeyBytes)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('lock', () {
    test('should call remoteDataSource.lock', () {
      // Act
      repository.lock();

      // Assert
      verify(() => mockRemoteDataSource.lock()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('isLocked', () {
    test('should return isLocked from remoteDataSource', () {
      // Arrange
      when(() => mockRemoteDataSource.isLocked).thenReturn(true);

      // Act
      final result = repository.isLocked;

      // Assert
      expect(result, isTrue);
      verify(() => mockRemoteDataSource.isLocked).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
