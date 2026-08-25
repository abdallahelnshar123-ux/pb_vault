import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/core/services/firebase_services/firestore_service.dart';
import 'package:pb_vault/data/data_sources/remote/user/impl/user_remote_data_source_impl.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/model/response/my_user_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_account_dto.dart';

class MockFirestoreService extends Mock implements FirestoreService {}

void main() {
  late MockFirestoreService mockFirestoreService;
  late UserRemoteDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(
      const MyUserDto(id: '', email: '', name: '', provider: ''),
    );
    registerFallbackValue(PlatformAccountDto(
      platformId: '',
      identifier: '',
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    dataSource = UserRemoteDataSourceImpl(mockFirestoreService);
  });

  const tUid = 'user123';
  const tMyUserDto = MyUserDto(
    id: tUid,
    email: 'test@example.com',
    name: 'Test User',
    provider: 'google',
  );

  group('getUser', () {
    test(
      'should return MyUserDto when FirestoreService returns data',
      () async {
        // Arrange
        when(
          () => mockFirestoreService.getUserFromFireStore(any()),
        ).thenAnswer((_) async => tMyUserDto);

        // Act
        final result = await dataSource.getUser(tUid);

        // Assert
        expect(result, tMyUserDto);
        verify(() => mockFirestoreService.getUserFromFireStore(tUid)).called(1);
        verifyNoMoreInteractions(mockFirestoreService);
      },
    );

    test(
      'should throw ServerException when FirebaseException occurs',
      () async {
        // Arrange
        when(() => mockFirestoreService.getUserFromFireStore(any())).thenThrow(
          FirebaseException(plugin: 'firestore', message: 'Firebase error'),
        );

        // Act & Assert
        await expectLater(
          () => dataSource.getUser(tUid),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'Firebase error',
            ),
          ),
        );
        verify(() => mockFirestoreService.getUserFromFireStore(tUid)).called(1);
        verifyNoMoreInteractions(mockFirestoreService);
      },
    );

    test('should throw NetworkException when SocketException occurs', () async {
      // Arrange
      when(
        () => mockFirestoreService.getUserFromFireStore(any()),
      ).thenThrow(const SocketException('No internet'));

      // Act & Assert
      await expectLater(
        () => dataSource.getUser(tUid),
        throwsA(
          isA<NetworkException>().having(
            (e) => e.message,
            'message',
            'no_internet',
          ),
        ),
      );
      verify(() => mockFirestoreService.getUserFromFireStore(any())).called(1);
      verifyNoMoreInteractions(mockFirestoreService);
    });

    test('should throw UnexpectedException when an unknown error occurs', () async {
      // Arrange
      when(
        () => mockFirestoreService.getUserFromFireStore(any()),
      ).thenThrow(Exception('Unknown error'));

      // Act & Assert
      await expectLater(
        () => dataSource.getUser(tUid),
        throwsA(
          isA<UnexpectedException>().having(
            (e) => e.message,
            'message',
            'Exception: Unknown error',
          ),
        ),
      );
      verify(() => mockFirestoreService.getUserFromFireStore(any())).called(1);
      verifyNoMoreInteractions(mockFirestoreService);
    });
  });

  group('createUser', () {
    test('should call FirestoreService.addUserToFireStore', () async {
      // Arrange
      when(
        () => mockFirestoreService.addUserToFireStore(any()),
      ).thenAnswer((_) async => {});

      // Act
      await dataSource.createUser(tMyUserDto);

      // Assert
      verify(
        () => mockFirestoreService.addUserToFireStore(tMyUserDto),
      ).called(1);
      verifyNoMoreInteractions(mockFirestoreService);
    });

    test('should throw ServerException when FirebaseException occurs', () async {
      // Arrange
      when(() => mockFirestoreService.addUserToFireStore(any())).thenThrow(
        FirebaseException(plugin: 'firestore', message: 'error'),
      );

      // Act & Assert
      await expectLater(
        () => dataSource.createUser(tMyUserDto),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('deleteUser', () {
    test('should call FirestoreService.deleteUserFromFirestore', () async {
      // Arrange
      when(
        () => mockFirestoreService.deleteUserFromFirestore(any()),
      ).thenAnswer((_) async => {});

      // Act
      await dataSource.deleteUser(tUid);

      // Assert
      verify(
        () => mockFirestoreService.deleteUserFromFirestore(tUid),
      ).called(1);
      verifyNoMoreInteractions(mockFirestoreService);
    });

    test('should throw ServerException when FirebaseException occurs', () async {
      // Arrange
      when(() => mockFirestoreService.deleteUserFromFirestore(any())).thenThrow(
        FirebaseException(plugin: 'firestore', message: 'error'),
      );

      // Act & Assert
      await expectLater(
        () => dataSource.deleteUser(tUid),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('updateUser', () {
    test('should call FirestoreService.updateUserDataToFirestore', () async {
      // Arrange
      when(
        () => mockFirestoreService.updateUserDataToFirestore(any()),
      ).thenAnswer((_) async => {});

      // Act
      await dataSource.updateUser(tMyUserDto);

      // Assert
      verify(
        () => mockFirestoreService.updateUserDataToFirestore(tMyUserDto),
      ).called(1);
      verifyNoMoreInteractions(mockFirestoreService);
    });

    test('should throw ServerException when FirebaseException occurs', () async {
      // Arrange
      when(() => mockFirestoreService.updateUserDataToFirestore(any())).thenThrow(
        FirebaseException(plugin: 'firestore', message: 'error'),
      );

      // Act & Assert
      await expectLater(
        () => dataSource.updateUser(tMyUserDto),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('changeMasterPassword', () {
    final tAccounts = [
      PlatformAccountDto(platformId: '1', identifier: 'i1', createdAt: DateTime.now()),
    ];

    test('should call FirestoreService.changeMasterPasswordBatch', () async {
      // Arrange
      when(
        () => mockFirestoreService.changeMasterPasswordBatch(
          uId: any(named: 'uId'),
          userDto: any(named: 'userDto'),
          accounts: any(named: 'accounts'),
        ),
      ).thenAnswer((_) async => {});

      // Act
      await dataSource.changeMasterPassword(
        uId: tUid,
        userDto: tMyUserDto,
        accounts: tAccounts,
      );

      // Assert
      verify(
        () => mockFirestoreService.changeMasterPasswordBatch(
          uId: tUid,
          userDto: tMyUserDto,
          accounts: tAccounts,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockFirestoreService);
    });

    test('should throw ServerException when FirebaseException occurs', () async {
      // Arrange
      when(
        () => mockFirestoreService.changeMasterPasswordBatch(
          uId: any(named: 'uId'),
          userDto: any(named: 'userDto'),
          accounts: any(named: 'accounts'),
        ),
      ).thenThrow(FirebaseException(plugin: 'firestore', message: 'error'));

      // Act & Assert
      await expectLater(
        () => dataSource.changeMasterPassword(
          uId: tUid,
          userDto: tMyUserDto,
          accounts: tAccounts,
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw NetworkException when SocketException occurs', () async {
      // Arrange
      when(
        () => mockFirestoreService.changeMasterPasswordBatch(
          uId: any(named: 'uId'),
          userDto: any(named: 'userDto'),
          accounts: any(named: 'accounts'),
        ),
      ).thenThrow(const SocketException('no-internet'));

      // Act & Assert
      await expectLater(
        () => dataSource.changeMasterPassword(
          uId: tUid,
          userDto: tMyUserDto,
          accounts: tAccounts,
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should throw UnexpectedException when unknown error occurs', () async {
      // Arrange
      when(
        () => mockFirestoreService.changeMasterPasswordBatch(
          uId: any(named: 'uId'),
          userDto: any(named: 'userDto'),
          accounts: any(named: 'accounts'),
        ),
      ).thenThrow(Exception('unknown'));

      // Act & Assert
      await expectLater(
        () => dataSource.changeMasterPassword(
          uId: tUid,
          userDto: tMyUserDto,
          accounts: tAccounts,
        ),
        throwsA(isA<UnexpectedException>()),
      );
    });
  });
}
