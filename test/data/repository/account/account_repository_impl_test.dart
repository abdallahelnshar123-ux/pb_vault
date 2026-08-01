import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/data/data_sources/remote/account/account_remote_data_source.dart';
import 'package:pb_vault/data/data_sources/remote/vault/vault_remote_data_source.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/encrypted_data_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_account_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_data_dto.dart';
import 'package:pb_vault/data/repository/account/account_repository_impl.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_data.dart';
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
        platform: const PlatformDataDto(name: '', icon: '', website: ''),
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
  final tPlatformData = const PlatformData(
    name: 'Google',
    icon: 'icon',
    website: 'google.com',
  );
  final tAccount = PlatformAccount(
    id: 'acc123',
    platform: tPlatformData,
    identifier: 'test@gmail.com',
    password: 'testPassword',
    createdAt: DateTime(2023, 1, 1),
  );

  const tEncryptedDataDto = EncryptedDataDto(
    cipherText: [1, 2, 3],
    mac: [4, 5, 6],
    nonce: [7, 8, 9],
  );

  final tAccountDto = PlatformAccountDto(
    id: 'acc123',
    platform: const PlatformDataDto(
      name: 'Google',
      icon: 'icon',
      website: 'google.com',
    ),
    identifier: 'test@gmail.com',
    password: tEncryptedDataDto,
    createdAt: DateTime(2023, 1, 1),
    customFields: const [],
    loginMethods: const [],
  );

  group('addAccount', () {
    test(
      'should encrypt password and call remoteDataSource.addAccount',
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
        verify(() => mockVaultRemoteDataSource.encrypt(tAccount.password!))
            .called(1);
        verify(
          () => mockRemoteDataSource.addAccount(
            account: any(named: 'account'),
            uId: tUserId,
          ),
        ).called(1);
      },
    );

    test(
      'should return Left(ServerFailure) when remoteDataSource.addAccount throws AppException',
      () async {
        // Arrange
        when(() => mockVaultRemoteDataSource.encrypt(any()))
            .thenAnswer((_) async => tEncryptedDataDto);
        when(
          () => mockRemoteDataSource.addAccount(
            account: any(named: 'account'),
            uId: any(named: 'uId'),
          ),
        ).thenThrow(const ServerException(message: 'Server Error'));

        // Act
        final result = await repository.addAccount(tUserId, tAccount);

        // Assert
        expect(result, const Left(ServerFailure('Server Error')));
      },
    );
  });

  group('getAccounts', () {
    test('should emit accounts when remote stream emits data', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getAccountsStream(uId: any(named: 'uId')),
      ).thenAnswer(
        (_) => Stream.fromIterable([
          [tAccountDto],
        ]),
      );

      // Act
      final stream = repository.getAccounts(tUserId);

      final actual = await stream.toList();

      expect(actual.length, 1);

      actual[0].fold(
        (_) => fail('Expected Right'),
        (accounts) {
          expect(accounts[0].id, tAccount.id);
          expect(accounts[0].identifier, tAccount.identifier);
        },
      );

      verify(
        () => mockRemoteDataSource.getAccountsStream(uId: tUserId),
      ).called(1);
    });
  });

  group('updateAccount', () {
    test(
      'should encrypt and call remoteDataSource.updateAccount',
      () async {
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
        verify(() => mockVaultRemoteDataSource.encrypt(tAccount.password!))
            .called(1);
        verify(
          () => mockRemoteDataSource.updateAccount(
            account: any(named: 'account'),
            uId: tUserId,
          ),
        ).called(1);
      },
    );
  });

  group('deleteAccount', () {
    test(
      'should call remoteDataSource.deleteAccount',
      () async {
        // Arrange
        const tAccountId = 'acc123';
        when(
          () => mockRemoteDataSource.deleteAccount(
            uId: any(named: 'uId'),
            accountId: any(named: 'accountId'),
          ),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.deleteAccount(tUserId, tAccountId);

        // Assert
        expect(result, const Right(unit));
        verify(
          () => mockRemoteDataSource.deleteAccount(
            uId: tUserId,
            accountId: tAccountId,
          ),
        ).called(1);
      },
    );
  });

  group('getAccountById', () {
    test(
      'should return decrypted account when data source succeeds',
      () async {
        // Arrange
        when(() => mockRemoteDataSource.getAccountById(
              uId: any(named: 'uId'),
              accountId: any(named: 'accountId'),
            )).thenAnswer((_) async => tAccountDto);
        when(() => mockVaultRemoteDataSource.decrypt(any()))
            .thenAnswer((_) async => 'testPassword');

        // Act
        final result = await repository.getAccountById(tUserId, 'acc123');

        // Assert
        result.fold(
          (failure) => fail('Should return Right'),
          (account) {
            expect(account.id, tAccount.id);
            expect(account.password, 'testPassword');
          },
        );
        verify(() => mockVaultRemoteDataSource.decrypt(tEncryptedDataDto))
            .called(1);
      },
    );

    test(
      'should return Left(ServerFailure) when data source throws AppException',
      () async {
        // Arrange
        when(() => mockRemoteDataSource.getAccountById(
              uId: any(named: 'uId'),
              accountId: any(named: 'accountId'),
            )).thenThrow(const ServerException(message: 'Not found'));

        // Act
        final result = await repository.getAccountById(tUserId, 'acc123');

        // Assert
        expect(result, const Left(ServerFailure('Not found')));
      },
    );
  });
}
