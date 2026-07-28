import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/core/services/firebase_services/firestore_service.dart';
import 'package:pb_vault/data/data_sources/remote/account/impl/account_remote_data_source_impl.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/encrypted_data_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_account_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_data_dto.dart';

class MockFirestoreService extends Mock implements FirestoreService {}

void main() {
  late MockFirestoreService mockFirestoreService;
  late AccountRemoteDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(
      PlatformAccountDto(
        id: '',
        platform: const PlatformDataDto(name: '', icon: '', website: ''),
        identifier: '',
        createdAt: DateTime.now(),
      ),
    );
  });

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    dataSource = AccountRemoteDataSourceImpl(mockFirestoreService);
  });

  const tUid = 'user123';
  final tAccountDto1 = PlatformAccountDto(
    id: 'acc123',
    platform: const PlatformDataDto(
      name: 'Google',
      icon: 'icon',
      website: 'google.com',
    ),
    identifier: 'test@gmail.com',
    password: const EncryptedDataDto(
      cipherText: [1, 2, 3],
      mac: [4, 5, 6],
      nonce: [7, 8, 9],
    ),
    createdAt: DateTime(2023, 1, 1),
  );

  final tAccountDto2 = PlatformAccountDto(
    id: 'acc123',
    platform: const PlatformDataDto(
      name: 'Google',
      icon: 'icon',
      website: 'google.com',
    ),
    identifier: 'test@gmail.com',
    password: const EncryptedDataDto(
      cipherText: [1, 2, 3],
      mac: [4, 5, 6],
      nonce: [7, 8, 9],
    ),
    createdAt: DateTime(2023, 1, 1),
  );

  group('addAccount', () {
    test('should call _firestoreService.addAccount', () async {
      // Arrange
      when(
        () => mockFirestoreService.addAccount(
          account: any(named: 'account'),
          uId: any(named: 'uId'),
        ),
      ).thenAnswer((_) async => {});

      // Act
      await dataSource.addAccount(account: tAccountDto1, uId: tUid);

      // Assert
      verify(
        () => mockFirestoreService.addAccount(account: tAccountDto1, uId: tUid),
      ).called(1);
      verifyNoMoreInteractions(mockFirestoreService);
    });

    test(
      'should throw ServerException with correct message when FirebaseException occurs',
      () async {
        // Arrange
        when(
          () => mockFirestoreService.addAccount(
            account: any(named: 'account'),
            uId: any(named: 'uId'),
          ),
        ).thenThrow(
          FirebaseException(plugin: 'firestore', message: 'Firebase error'),
        );

        // Act & Assert
        await expectLater(
          () => dataSource.addAccount(account: tAccountDto1, uId: tUid),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Firebase error',
            ),
          ),
        );

        verify(
          () =>
              mockFirestoreService.addAccount(account: tAccountDto1, uId: tUid),
        ).called(1);

        verifyNoMoreInteractions(mockFirestoreService);
      },
    );
    test(
      'should throw ServerException with correct message when FirebaseException occurs with null  message ',
      () async {
        // Arrange
        when(
          () => mockFirestoreService.addAccount(
            account: any(named: 'account'),
            uId: any(named: 'uId'),
          ),
        ).thenThrow(FirebaseException(plugin: 'firestore', message: null));

        // Act & Assert
        await expectLater(
          () => dataSource.addAccount(account: tAccountDto1, uId: tUid),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'server_error',
            ),
          ),
        );

        verify(
          () =>
              mockFirestoreService.addAccount(account: tAccountDto1, uId: tUid),
        ).called(1);

        verifyNoMoreInteractions(mockFirestoreService);
      },
    );

    test('should throw NetworkException when SocketException occurs', () async {
      // Arrange
      when(
        () => mockFirestoreService.addAccount(
          account: any(named: 'account'),
          uId: any(named: 'uId'),
        ),
      ).thenThrow(const SocketException('No internet'));

      // Act & Assert
      await expectLater(
        () => dataSource.addAccount(account: tAccountDto1, uId: tUid),
        throwsA(
          isA<NetworkException>().having(
            (e) => e.message,
            'message',
            'no_internet',
          ),
        ),
      );

      verify(
        () => mockFirestoreService.addAccount(account: tAccountDto1, uId: tUid),
      ).called(1);

      verifyNoMoreInteractions(mockFirestoreService);
    });
  });

  group('updateAccount', () {
    test('should call _firestoreService.updateAccount', () async {
      // Arrange
      when(
        () => mockFirestoreService.updateAccount(
          account: any(named: 'account'),
          uId: any(named: 'uId'),
        ),
      ).thenAnswer((_) async => {});

      // Act
      await dataSource.updateAccount(account: tAccountDto1, uId: tUid);

      // Assert
      verify(
        () => mockFirestoreService.updateAccount(
          account: tAccountDto1,
          uId: tUid,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockFirestoreService);
    });
  });

  group('getAccountsStream', () {
    test(
      'should return a Stream from _firestoreService.getAccountsStream',
      () async {
        // Arrange
        when(
          () => mockFirestoreService.getAccountsStream(uId: any(named: 'uId')),
        ).thenAnswer(
          (_) => Stream.fromIterable([
            [tAccountDto1],
            [tAccountDto1, tAccountDto2],
          ]),
        );

        // Act
        final stream = dataSource.getAccountsStream(uId: tUid);
        final actual = await stream.toList();

        // Assert
        expect(actual.length, 2);
        expect(actual[0], [tAccountDto1]);
        expect(actual[1], [tAccountDto1, tAccountDto2]);

        verify(
          () => mockFirestoreService.getAccountsStream(uId: tUid),
        ).called(1);
        verifyNoMoreInteractions(mockFirestoreService);
      },
    );

    test(
      'should throw ServerException when stream emits FirebaseException',
      () async {
        // Arrange
        when(
          () => mockFirestoreService.getAccountsStream(uId: any(named: 'uId')),
        ).thenAnswer(
          (_) => Stream.error(
            FirebaseException(plugin: 'firestore', message: 'Stream error'),
          ),
        );

        // Assert
        await expectLater(
          dataSource.getAccountsStream(uId: tUid).toList(),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Stream error',
            ),
          ),
        );
      },
    );

    test(
      'should throw NetworkException when stream emits SocketException',
      () async {
        // Arrange
        when(
          () => mockFirestoreService.getAccountsStream(uId: any(named: 'uId')),
        ).thenAnswer((_) => Stream.error(SocketException('no internet')));

        // Assert
        await expectLater(
          dataSource.getAccountsStream(uId: tUid).toList(),
          throwsA(
            isA<NetworkException>().having(
              (e) => e.message,
              'message',
              'no_internet',
            ),
          ),
        );
      },
    );
  });

  group('deleteAccount', () {
    test('should call _firestoreService.deleteAccount', () async {
      // Arrange
      const tAccountId = 'acc123';
      when(
        () => mockFirestoreService.deleteAccount(
          uId: any(named: 'uId'),
          accountId: any(named: 'accountId'),
        ),
      ).thenAnswer((_) async => {});

      // Act
      await dataSource.deleteAccount(uId: tUid, accountId: tAccountId);

      // Assert
      verify(
        () => mockFirestoreService.deleteAccount(
          uId: tUid,
          accountId: tAccountId,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockFirestoreService);
    });
  });
}
