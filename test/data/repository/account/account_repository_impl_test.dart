import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/data/data_sources/remote/account/account_remote_data_source.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/mapper/account_dto_mapper.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_account_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_data_dto.dart';
import 'package:pb_vault/data/repository/account/account_repository_impl.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_data.dart';
import 'package:pb_vault/domain/failure/failure.dart';

class MockAccountRemoteDataSource extends Mock
    implements AccountRemoteDataSource {}

void main() {
  late MockAccountRemoteDataSource mockRemoteDataSource;
  late AccountRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      PlatformAccountDto(
        platform: const PlatformDataDto(name: '', icon: '', website: ''),
        emailOrUsername: '',
        encryptedPassword: [],
        createdAt: DateTime.now(),
        nonce: [],
        mac: [],
      ),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockAccountRemoteDataSource();
    repository = AccountRepositoryImpl(mockRemoteDataSource);
  });

  const tUserId = 'user123';
  final tPlatformData = const PlatformData(
    name: 'Google',
    icon: 'icon',
    website: 'google.com',
  );
  final tAccount1 = PlatformAccount(
    id: 'acc123',
    platform: tPlatformData,
    emailOrUsername: 'test@gmail.com',
    encryptedPassword: const [1, 2, 3],
    mac: const [4, 5, 6],
    nonce: const [7, 8, 9],
    createdAt: DateTime(2023, 1, 1),
  );
  final tAccount2 = PlatformAccount(
    id: 'acc1234',
    platform: tPlatformData,
    emailOrUsername: 'test1@gmail.com',
    encryptedPassword: const [1, 2, 5],
    mac: const [4, 11, 6],
    nonce: const [7, 10, 9],
    createdAt: DateTime(2023, 3, 1),
  );

  final tAccountDto1 = tAccount1.toAccountDto();
  final tAccountDto2 = tAccount2.toAccountDto();

  group('addAccount', () {
    test(
      'should call remoteDataSource.addAccount and return Right(unit)',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.addAccount(
            account: any(named: 'account'),
            uId: any(named: 'uId'),
          ),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.addAccount(tUserId, tAccount1);

        // Assert
        expect(result, const Right(unit));
        verify(
          () => mockRemoteDataSource.addAccount(
            account: tAccountDto1,
            uId: tUserId,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return Left(ServerFailure) when remoteDataSource.addAccount throws AppException',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.addAccount(
            account: any(named: 'account'),
            uId: any(named: 'uId'),
          ),
        ).thenThrow(const ServerException(message: 'Server Error'));

        // Act
        final result = await repository.addAccount(tUserId, tAccount1);

        // Assert
        expect(result, const Left(ServerFailure('Server Error')));
        verify(
          () => mockRemoteDataSource.addAccount(
            account: tAccountDto1,
            uId: tUserId,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('getAccounts', () {
    test('should emit mapped accounts when remote stream emits data', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getAccountsStream(uId: any(named: 'uId')),
      ).thenAnswer(
        (_) => Stream.fromIterable([
          [tAccountDto1],
          [tAccountDto1, tAccountDto2],
        ]),
      );

      // Act
      final stream = repository.getAccounts(tUserId);

      final actual = await stream.toList();

      expect(actual.length, 2);

      actual[0].fold(
        (_) => fail('Expected Right'),
        (accounts) => expect(accounts, [tAccount1]),
      );

      actual[1].fold(
        (_) => fail('Expected Right'),
        (accounts) => expect(accounts, [tAccount1, tAccount2]),
      );

      verify(
        () => mockRemoteDataSource.getAccountsStream(uId: tUserId),
      ).called(1);

      verifyNoMoreInteractions(mockRemoteDataSource);
    });
    test(
      'should emit Left(ServerFailure) when remote stream throws AppException',
      () async {
        when(
          () => mockRemoteDataSource.getAccountsStream(uId: any(named: 'uId')),
        ).thenAnswer(
          (_) => Stream.error(const ServerException(message: 'Stream error')),
        );

        final stream = repository.getAccounts(tUserId);
        final actual = await stream.toList();

        expect(actual.length, 1);
        actual[0].fold(
          (failure) => expect(failure, ServerFailure('Stream error')),
          (accounts) => fail('test fail'),
        );

        verify(
          () => mockRemoteDataSource.getAccountsStream(uId: tUserId),
        ).called(1);

        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('updateAccount', () {
    test(
      'should call remoteDataSource.updateAccount and return Right(unit)',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.updateAccount(
            account: any(named: 'account'),
            uId: any(named: 'uId'),
          ),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.updateAccount(tUserId, tAccount1);

        // Assert
        expect(result, const Right(unit));
        verify(
          () => mockRemoteDataSource.updateAccount(
            account: tAccountDto1,
            uId: tUserId,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('deleteAccount', () {
    test(
      'should call remoteDataSource.deleteAccount and return Right(unit)',
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
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}
