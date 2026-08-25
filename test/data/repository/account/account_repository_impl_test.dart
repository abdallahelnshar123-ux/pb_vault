import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/data/data_sources/remote/account/account_remote_data_source.dart';
import 'package:pb_vault/data/data_sources/remote/vault/vault_remote_data_source.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/encrypted_data_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_account_dto.dart';
import 'package:pb_vault/data/repository/account/account_repository_impl.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/failure/failure.dart';

class MockAccountRemoteDataSource extends Mock
    implements AccountRemoteDataSource {}

class MockVaultRemoteDataSource extends Mock implements VaultRemoteDataSource {}

void main() {
  late MockAccountRemoteDataSource mockRemoteDataSource;
  late MockVaultRemoteDataSource mockVaultRemoteDataSource;
  late AccountRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      PlatformAccountDto(
        id: '',
        platformId: '',
        identifier: '',
        createdAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      const EncryptedDataDto(cipherText: [], mac: [], nonce: []),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockAccountRemoteDataSource();
    mockVaultRemoteDataSource = MockVaultRemoteDataSource();
    repository = AccountRepositoryImpl(
      mockRemoteDataSource,
      mockVaultRemoteDataSource,
    );
  });

  const tUserId = 'user123';
  const tPlatformId = 'google_id';
  final tAccount = PlatformAccount(
    id: 'acc123',
    platformId: tPlatformId,
    identifier: 'test@gmail.com',
    password: 'testPassword',
    notes: 'some notes',
    recoveryCodes: 'rec1,rec2',
    passkey: 'pk123',
    twoFactorSecret: '2fa123',
    createdAt: DateTime(2023, 1, 1),
    customFields: const [],
    loginMethods: const [],
  );

  const tEncryptedDataDto = EncryptedDataDto(
    cipherText: [1, 2, 3],
    mac: [4, 5, 6],
    nonce: [7, 8, 9],
  );

  final tAccountDto = PlatformAccountDto(
    id: 'acc123',
    platformId: tPlatformId,
    identifier: 'test@gmail.com',
    password: tEncryptedDataDto,
    notes: tEncryptedDataDto,
    recoveryCodes: tEncryptedDataDto,
    passkey: tEncryptedDataDto,
    twoFactorSecret: tEncryptedDataDto,
    createdAt: DateTime(2023, 1, 1),
    customFields: const [],
    loginMethods: const [],
  );

  group('addAccount', () {
    test(
      'should encrypt all sensitive fields and call remoteDataSource.addAccount when successful',
      () async {
        // Arrange
        when(() => mockVaultRemoteDataSource.encrypt(any()))
            .thenAnswer((_) async => tEncryptedDataDto);
        when(
          () => mockRemoteDataSource.addAccount(
            account: any(named: 'account'),
            uId: any(named: 'uId'),
          ),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.addAccount(tUserId, tAccount);

        // Assert
        expect(result, const Right(unit));
        verify(() => mockVaultRemoteDataSource.encrypt(tAccount.password!)).called(1);
        verify(() => mockVaultRemoteDataSource.encrypt(tAccount.notes!)).called(1);
        verify(() => mockVaultRemoteDataSource.encrypt(tAccount.recoveryCodes!)).called(1);
        verify(() => mockVaultRemoteDataSource.encrypt(tAccount.passkey!)).called(1);
        verify(() => mockVaultRemoteDataSource.encrypt(tAccount.twoFactorSecret!)).called(1);
        
        verify(
          () => mockRemoteDataSource.addAccount(
            account: any(named: 'account'),
            uId: tUserId,
          ),
        ).called(1);
        
        verifyNoMoreInteractions(mockVaultRemoteDataSource);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test('should return Failure when an exception occurs during encryption', () async {
      // Arrange
      when(() => mockVaultRemoteDataSource.encrypt(any())).thenThrow(Exception('Crypto error'));

      // Act
      final result = await repository.addAccount(tUserId, tAccount);

      // Assert
      expect(
        result,
        const Left(UnexpectedFailure('Exception: Crypto error')),
      );      verifyZeroInteractions(mockRemoteDataSource);
    });
  });

  group('updateAccount', () {
    test('should encrypt and call remoteDataSource.updateAccount', () async {
      // Arrange
      when(() => mockVaultRemoteDataSource.encrypt(any()))
          .thenAnswer((_) async => tEncryptedDataDto);
      when(
        () => mockRemoteDataSource.updateAccount(
          account: any(named: 'account'),
          uId: any(named: 'uId'),
        ),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.updateAccount(tUserId, tAccount);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockVaultRemoteDataSource.encrypt(any())).called(5);
      verify(() => mockRemoteDataSource.updateAccount(
            account: any(named: 'account'),
            uId: tUserId,
          )).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockVaultRemoteDataSource);
    });

    test('should return Failure when remoteDataSource throws AppException', () async {
      // Arrange
      when(() => mockVaultRemoteDataSource.encrypt(any()))
          .thenAnswer((_) async => tEncryptedDataDto);
      when(() => mockRemoteDataSource.updateAccount(
            account: any(named: 'account'),
            uId: any(named: 'uId'),
          )).thenThrow(const ServerException(message: 'error'));

      // Act
      final result = await repository.updateAccount(tUserId, tAccount);

      // Assert
      expect(result, const Left(ServerFailure('error')));
    });
  });

  group('deleteAccount', () {
    test('should call remoteDataSource.deleteAccount', () async {
      // Arrange
      when(() => mockRemoteDataSource.deleteAccount(
            uId: any(named: 'uId'),
            accountId: any(named: 'accountId'),
          )).thenAnswer((_) async => {});

      // Act
      final result = await repository.deleteAccount(tUserId, 'acc_id');

      // Assert
      expect(result, const Right(unit));
      verify(() => mockRemoteDataSource.deleteAccount(uId: tUserId, accountId: 'acc_id')).called(1);
      verifyZeroInteractions(mockVaultRemoteDataSource);
    });

    test('should return Left(ServerFailure) when deleteAccount throws AppException', () async {
      // Arrange
      when(() => mockRemoteDataSource.deleteAccount(
            uId: any(named: 'uId'),
            accountId: any(named: 'accountId'),
          )).thenThrow(const ServerException(message: 'delete_error'));

      // Act
      final result = await repository.deleteAccount(tUserId, 'acc_id');

      // Assert
      expect(result, const Left(ServerFailure('delete_error')));
    });
  });

  group('getAccounts', () {
    test('should emit accounts stream with only basic fields mapped', () async {
      // Arrange
      when(() => mockRemoteDataSource.getAccountsStream(uId: any(named: 'uId')))
          .thenAnswer((_) => Stream.value([tAccountDto]));

      // Act & Assert
      final stream = repository.getAccounts(tUserId);
      final result = await stream.first;

      expect(result.isRight(), isTrue);
      final list = result.getOrElse(() => []);
      expect(list.length, 1);
      expect(list[0].id, tAccountDto.id);
      expect(list[0].password, isNull); // Streams only map basic info
      
      verify(() => mockRemoteDataSource.getAccountsStream(uId: tUserId)).called(1);
      verifyZeroInteractions(mockVaultRemoteDataSource);
    });
    test(
      'should emit Left(ServerFailure) when getAccountsStream throws ServerException',
          () async {
        // Arrange
        when(
              () => mockRemoteDataSource.getAccountsStream(
            uId: any(named: 'uId'),
          ),
        ).thenAnswer(
              (_) => Stream.error(
            const ServerException(message: 'error'),
          ),
        );

        // Act
        final result = await repository.getAccounts(tUserId).first;

        // Assert
        expect(result, const Left(ServerFailure('error')));

        verify(
              () => mockRemoteDataSource.getAccountsStream(
            uId: tUserId,
          ),
        ).called(1);

        verifyZeroInteractions(mockVaultRemoteDataSource);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('getAccountById', () {
    test('should decrypt all sensitive fields when successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.getAccountById(
            uId: any(named: 'uId'),
            accountId: any(named: 'accountId'),
          )).thenAnswer((_) async => tAccountDto);

      when(() => mockVaultRemoteDataSource.decrypt(any()))
          .thenAnswer((_) async => 'decrypted');

      // Act
      final result = await repository.getAccountById(tUserId, 'acc123');

      // Assert
      expect(result.isRight(), isTrue);
      final account = result.getOrElse(() => throw Exception());
      expect(account.password, 'decrypted');
      expect(account.notes, 'decrypted');
      expect(account.recoveryCodes, 'decrypted');
      expect(account.passkey, 'decrypted');
      expect(account.twoFactorSecret, 'decrypted');

      verify(() => mockVaultRemoteDataSource.decrypt(any())).called(5);
      verifyNoMoreInteractions(mockVaultRemoteDataSource);
    });

    test('should return Failure when getAccountById fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.getAccountById(
            uId: any(named: 'uId'),
            accountId: any(named: 'accountId'),
          )).thenThrow(const ServerException(message: 'error'));

      // Act
      final result = await repository.getAccountById(tUserId, 'acc123');

      // Assert
      expect(result, const Left(ServerFailure('error')));
      verifyZeroInteractions(mockVaultRemoteDataSource);
    });
  });

  group('getAllAccounts', () {
    test('should perform bulk decryption when accounts list is not empty', () async {
      // Arrange
      final tDtos = [tAccountDto, tAccountDto];
      when(() => mockRemoteDataSource.getAllAccounts(uId: any(named: 'uId')))
          .thenAnswer((_) async => tDtos);
      
      final tDecryptedValues = List.generate(10, (i) => 'decrypted_$i');
      when(() => mockVaultRemoteDataSource.decryptMultiple(any()))
          .thenAnswer((_) async => tDecryptedValues);

      // Act
      final result = await repository.getAllAccounts(tUserId);

      // Assert
      expect(result.isRight(), isTrue);
      final accounts = result.getOrElse(() => []);
      expect(accounts.length, 2);
      expect(accounts[0].password, 'decrypted_0');
      expect(accounts[0].notes, 'decrypted_1');
      expect(accounts[1].password, 'decrypted_5');
      
      verify(() => mockRemoteDataSource.getAllAccounts(uId: tUserId)).called(1);
      verify(() => mockVaultRemoteDataSource.decryptMultiple(any())).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockVaultRemoteDataSource);
    });

    test('should return empty list without calling vault if dtos are empty', () async {
      // Arrange
      when(() => mockRemoteDataSource.getAllAccounts(uId: any(named: 'uId')))
          .thenAnswer((_) async => []);

      // Act
      final result = await repository.getAllAccounts(tUserId);

      // Assert
      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => throw Exception()), isEmpty);
      verify(() => mockRemoteDataSource.getAllAccounts(uId: tUserId)).called(1);
      verifyZeroInteractions(mockVaultRemoteDataSource);
    });

    test('should return Failure when bulk decryption fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.getAllAccounts(uId: any(named: 'uId')))
          .thenAnswer((_) async => [tAccountDto]);
      when(() => mockVaultRemoteDataSource.decryptMultiple(any()))
          .thenThrow(Exception('bulk error'));

      // Act
      final result = await repository.getAllAccounts(tUserId);

      // Assert
      expect(result, const Left(UnexpectedFailure('Exception: bulk error')));
    });

    test('should return Left(ServerFailure) when getAllAccounts throws AppException', () async {
      // Arrange
      when(() => mockRemoteDataSource.getAllAccounts(uId: any(named: 'uId')))
          .thenThrow(const ServerException(message: 'error'));

      // Act
      final result = await repository.getAllAccounts(tUserId);

      // Assert
      expect(result, const Left(ServerFailure('error')));
    });
    test(
      'should map null decrypted values correctly when decryptMultiple returns nulls',
          () async {
        // Arrange
        when(
              () => mockRemoteDataSource.getAllAccounts(
            uId: any(named: 'uId'),
          ),
        ).thenAnswer((_) async => [tAccountDto]);

        when(
              () => mockVaultRemoteDataSource.decryptMultiple(any()),
        ).thenAnswer(
              (_) async => <String?>[
            null, // password
            null, // notes
            null, // recoveryCodes
            null, // passkey
            null, // twoFactorSecret
          ],
        );

        // Act
        final result = await repository.getAllAccounts(tUserId);

        // Assert
        expect(result.isRight(), isTrue);

        final accounts = result.getOrElse(() => []);
        expect(accounts, hasLength(1));

        final account = accounts.first;

        expect(account.password, isNull);
        expect(account.notes, isNull);
        expect(account.recoveryCodes, isNull);
        expect(account.passkey, isNull);
        expect(account.twoFactorSecret, isNull);

        verify(
              () => mockRemoteDataSource.getAllAccounts(
            uId: tUserId,
          ),
        ).called(1);

        verify(
              () => mockVaultRemoteDataSource.decryptMultiple(any()),
        ).called(1);

        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockVaultRemoteDataSource);
      },
    );
  });
}
