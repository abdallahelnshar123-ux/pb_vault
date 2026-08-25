import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/core/services/firebase_services/firebase_auth_service.dart';
import 'package:pb_vault/data/data_sources/remote/auth/impl/auth_remote_data_source_impl.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/model/response/auth_user_dto.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuthService mockFirebaseAuthService;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockFirebaseAuthService = MockFirebaseAuthService();
    dataSource = AuthRemoteDataSourceImpl(mockFirebaseAuthService);
  });

  const tUid = 'uid123';
  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tDisplayName = 'Test User';

  const tAuthUserDto = AuthUserDto(id: tUid, email: tEmail, name: tDisplayName);

  final tMockUser = MockUser();
  final tMockUserCredential = MockUserCredential();

  void setupMockUser() {
    when(() => tMockUser.uid).thenReturn(tUid);
    when(() => tMockUser.email).thenReturn(tEmail);
    when(() => tMockUser.displayName).thenReturn(tDisplayName);
    when(() => tMockUserCredential.user).thenReturn(tMockUser);
  }

  group('continueWithGoogle', () {
    test('should return AuthUserDto when successful', () async {
      // Arrange
      setupMockUser();
      when(
        () => mockFirebaseAuthService.signInWithGoogle(),
      ).thenAnswer((_) async => tMockUserCredential);

      // Act
      final result = await dataSource.continueWithGoogle();

      // Assert
      expect(result, tAuthUserDto);
      verify(() => mockFirebaseAuthService.signInWithGoogle()).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthService);
    });

    test(
      'should throw CancelledByUserException when FirebaseAuthException code is cancelled',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuthService.signInWithGoogle(),
        ).thenThrow(FirebaseAuthException(code: 'cancelled'));

        // Act & Assert
        await expectLater(
          () => dataSource.continueWithGoogle(),
          throwsA(isA<CancelledByUserException>()),
        );
      },
    );

    test(
      'should throw CancelledByUserException when FirebaseAuthException code is web-user-interaction-failed',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuthService.signInWithGoogle(),
        ).thenThrow(FirebaseAuthException(code: 'web-user-interaction-failed'));

        // Act & Assert
        await expectLater(
          () => dataSource.continueWithGoogle(),
          throwsA(isA<CancelledByUserException>()),
        );
      },
    );

    test(
      'should throw ServerException when FirebaseAuthException occurs',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuthService.signInWithGoogle(),
        ).thenThrow(FirebaseAuthException(code: 'error', message: 'error_msg'));

        // Act & Assert
        await expectLater(
          () => dataSource.continueWithGoogle(),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'error_msg',
            ),
          ),
        );
      },
    );

    test('should throw NetworkException when SocketException occurs', () async {
      // Arrange
      when(
        () => mockFirebaseAuthService.signInWithGoogle(),
      ).thenThrow(const SocketException('no internet'));

      // Act & Assert
      await expectLater(
        () => dataSource.continueWithGoogle(),
        throwsA(
          isA<NetworkException>().having(
            (e) => e.message,
            'message',
            'no_internet',
          ),
        ),
      );
    });
  });

  group('registerWithEmailAndPassword', () {
    test('should return AuthUserDto when successful', () async {
      // Arrange
      setupMockUser();
      when(
        () => mockFirebaseAuthService.registerWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => tMockUserCredential);

      // Act
      final result = await dataSource.registerWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      // Assert
      expect(result, tAuthUserDto);
      verify(
        () => mockFirebaseAuthService.registerWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthService);
    });

    test(
      'should throw ServerException with custom message when email-already-in-use',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuthService.registerWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

        // Act & Assert
        await expectLater(
          () => dataSource.registerWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'the_email_address_is_already_in_use_by_another_account',
            ),
          ),
        );
      },
    );
  });

  group('loginWithEmailAndPassword', () {
    test('should return AuthUserDto when successful', () async {
      // Arrange
      setupMockUser();
      when(
        () => mockFirebaseAuthService.loginWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => tMockUserCredential);

      // Act
      final result = await dataSource.loginWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      // Assert
      expect(result, tAuthUserDto);
      verify(
        () => mockFirebaseAuthService.loginWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthService);
    });

    test(
      'should throw ServerException with custom message when invalid-credential',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuthService.loginWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(FirebaseAuthException(code: 'invalid-credential'));

        // Act & Assert
        await expectLater(
          () => dataSource.loginWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              'the_email_or_password_is_incorrect',
            ),
          ),
        );
      },
    );
  });

  group('logout', () {
    test('should call logout and complete', () async {
      // Arrange
      when(() => mockFirebaseAuthService.logout()).thenAnswer((_) async => {});

      // Act
      await dataSource.logout();

      // Assert
      verify(() => mockFirebaseAuthService.logout()).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthService);
    });
  });

  group('deleteAuthUser', () {
    test('should call deleteAccount and complete', () async {
      // Arrange
      when(
        () => mockFirebaseAuthService.deleteAccount(),
      ).thenAnswer((_) async => {});

      // Act
      await dataSource.deleteAuthUser();

      // Assert
      verify(() => mockFirebaseAuthService.deleteAccount()).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthService);
    });
  });

  group('reAuthenticateWithEmailAndPassword', () {
    test('should return AuthUserDto when successful', () async {
      // Arrange
      setupMockUser();
      when(
        () => mockFirebaseAuthService.reAuthenticate(password: tPassword),
      ).thenAnswer((_) async => tMockUserCredential);

      // Act
      final result = await dataSource.reAuthenticateWithEmailAndPassword(
        tPassword,
      );

      // Assert
      expect(result, tAuthUserDto);
      verify(
        () => mockFirebaseAuthService.reAuthenticate(password: tPassword),
      ).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthService);
    });
  });

  group('reAuthenticateWithGoogle', () {
    test('should return AuthUserDto when successful', () async {
      // Arrange
      setupMockUser();
      when(
        () => mockFirebaseAuthService.reAuthenticateWithGoogle(),
      ).thenAnswer((_) async => tMockUserCredential);

      // Act
      final result = await dataSource.reAuthenticateWithGoogle();

      // Assert
      expect(result, tAuthUserDto);
      verify(
        () => mockFirebaseAuthService.reAuthenticateWithGoogle(),
      ).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthService);
    });
  });

  group('resetPassword', () {
    test('should call sendPasswordResetEmail and complete', () async {
      // Arrange
      when(
        () => mockFirebaseAuthService.sendPasswordResetEmail(email: tEmail),
      ).thenAnswer((_) async => {});

      // Act
      await dataSource.resetPassword(email: tEmail);

      // Assert
      verify(
        () => mockFirebaseAuthService.sendPasswordResetEmail(email: tEmail),
      ).called(1);
      verifyNoMoreInteractions(mockFirebaseAuthService);
    });
  });
}
