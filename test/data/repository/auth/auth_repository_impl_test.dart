import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/data/data_sources/local/user/user_local_data_source.dart';
import 'package:pb_vault/data/data_sources/remote/auth/auth_remote_data_source.dart';
import 'package:pb_vault/data/data_sources/remote/user/user_remote_data_source.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';
import 'package:pb_vault/data/mapper/my_user_mapper.dart';
import 'package:pb_vault/data/model/response/auth_user_dto.dart';
import 'package:pb_vault/data/model/response/my_user_dto.dart';
import 'package:pb_vault/data/repository/auth/auth_repository_impl.dart';
import 'package:pb_vault/domain/entities/response/user/auth_providers.dart';
import 'package:pb_vault/domain/failure/failure.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

void main() {
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockUserLocalDataSource mockUserLocalDataSource;
  late MockUserRemoteDataSource mockUserRemoteDataSource;
  late AuthRepositoryImpl authRepositoryImpl;

  setUpAll(() {
    registerFallbackValue(
      const MyUserDto(id: '', email: '', name: '', provider: ''),
    );
  });

  setUp(() {
    mockUserRemoteDataSource = MockUserRemoteDataSource();
    mockUserLocalDataSource = MockUserLocalDataSource();
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    authRepositoryImpl = AuthRepositoryImpl(
      mockAuthRemoteDataSource,
      mockUserRemoteDataSource,
      mockUserLocalDataSource,
    );
  });

  const tAuthUserDto = AuthUserDto(
    id: '123',
    email: 'test@gmail.com',
    name: 'Test User',
  );
  const tMyUserDto = MyUserDto(
    id: '123',
    email: 'test@gmail.com',
    name: 'Test User',
    provider: AuthProviders.google,
  );

  group('continueWithGoogle', () {
    test('should return Right(MyUser) when user exists in database', () async {
      // Arrange
      when(
        () => mockAuthRemoteDataSource.continueWithGoogle(),
      ).thenAnswer((_) async => tAuthUserDto);
      when(
        () => mockUserRemoteDataSource.getUser(any()),
      ).thenAnswer((_) async => tMyUserDto);
      when(
        () => mockUserLocalDataSource.saveUser(user: any(named: 'user')),
      ).thenAnswer((_) async => {});

      // Act
      final result = await authRepositoryImpl.continueWithGoogle();

      // Assert
      expect(result, Right(tMyUserDto.toUser()));
      verify(() => mockAuthRemoteDataSource.continueWithGoogle()).called(1);
      verify(() => mockUserRemoteDataSource.getUser(tAuthUserDto.id)).called(1);
      verify(
        () => mockUserLocalDataSource.saveUser(user: tMyUserDto),
      ).called(1);
      verifyNoMoreInteractions(mockUserRemoteDataSource);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockUserLocalDataSource);
    });

    test(
      'should create new user and return Right(MyUser) when user does not exist in database',
      () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.continueWithGoogle(),
        ).thenAnswer((_) async => tAuthUserDto);
        when(
          () => mockUserRemoteDataSource.getUser(any()),
        ).thenAnswer((_) async => null);
        when(
          () => mockUserRemoteDataSource.createUser(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockUserLocalDataSource.saveUser(user: any(named: 'user')),
        ).thenAnswer((_) async => {});

        // Act
        final result = await authRepositoryImpl.continueWithGoogle();

        // Assert
        expect(result, Right(tMyUserDto.toUser()));
        verify(() => mockAuthRemoteDataSource.continueWithGoogle()).called(1);
        verify(
          () => mockUserRemoteDataSource.getUser(tAuthUserDto.id),
        ).called(1);
        verify(() => mockUserRemoteDataSource.createUser(tMyUserDto)).called(1);
        verify(
          () => mockUserLocalDataSource.saveUser(user: tMyUserDto),
        ).called(1);
        verifyNoMoreInteractions(mockUserRemoteDataSource);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
        verifyNoMoreInteractions(mockUserLocalDataSource);
      },
    );

    test(
      'should return Left(Failure) when continueWithGoogle throws AppException',
      () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.continueWithGoogle(),
        ).thenThrow(const ServerException(message: 'Server Error'));

        // Act
        final result = await authRepositoryImpl.continueWithGoogle();

        // Assert
        expect(result, const Left(ServerFailure('Server Error')));
        verify(() => mockAuthRemoteDataSource.continueWithGoogle()).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
        verifyZeroInteractions(mockUserRemoteDataSource);
        verifyZeroInteractions(mockUserLocalDataSource);
      },
    );

    test(
      'should return Left(UnexpectedFailure) when an unexpected error occurs',
      () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.continueWithGoogle(),
        ).thenThrow(Exception('Unexpected Error'));

        // Act
        final result = await authRepositoryImpl.continueWithGoogle();

        // Assert
        expect(result, Left(UnexpectedFailure('Exception: Unexpected Error')));
        verify(() => mockAuthRemoteDataSource.continueWithGoogle()).called(1);
        verifyZeroInteractions(mockUserRemoteDataSource);
        verifyZeroInteractions(mockUserLocalDataSource);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );
  });

  group('registerWithEmailAndPassword', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tName = 'Test User';
    const tAvatarIndex = 1;

    test(
      'should return Right(MyUser) when registration is successful',
      () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.registerWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => tAuthUserDto);
        when(
          () => mockUserRemoteDataSource.createUser(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockUserLocalDataSource.saveUser(user: any(named: 'user')),
        ).thenAnswer((_) async => {});

        // Act
        final result = await authRepositoryImpl.registerWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
          name: tName,
          avatarIndex: tAvatarIndex,
        );

        // Assert
        final expectedUserDto = MyUserDto(
          id: tAuthUserDto.id,
          email: tAuthUserDto.email,
          name: tName,
          provider: AuthProviders.emailPassword,
        );
        expect(result, Right(expectedUserDto.toUser()));
        verify(
          () => mockAuthRemoteDataSource.registerWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verify(
          () => mockUserRemoteDataSource.createUser(expectedUserDto),
        ).called(1);
        verify(
          () => mockUserLocalDataSource.saveUser(user: expectedUserDto),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
        verifyNoMoreInteractions(mockUserRemoteDataSource);
        verifyNoMoreInteractions(mockUserLocalDataSource);
      },
    );

    test(
      'should return Left(Failure) when registerWithEmailAndPassword throws AppException',
      () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.registerWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(const ServerException(message: 'Registration Error'));

        // Act
        final result = await authRepositoryImpl.registerWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
          name: tName,
          avatarIndex: tAvatarIndex,
        );

        // Assert
        expect(result, const Left(ServerFailure('Registration Error')));
        verify(
          () => mockAuthRemoteDataSource.registerWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
        verifyZeroInteractions(mockUserRemoteDataSource);
        verifyZeroInteractions(mockUserLocalDataSource);
      },
    );
  });

  group('loginWithEmailAndPassword', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    test('should return Right(MyUser) when login is successful', () async {
      // Arrange
      when(
        () => mockAuthRemoteDataSource.loginWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => tAuthUserDto);
      when(
        () => mockUserRemoteDataSource.getUser(any()),
      ).thenAnswer((_) async => tMyUserDto);
      when(
        () => mockUserLocalDataSource.saveUser(user: any(named: 'user')),
      ).thenAnswer((_) async => {});

      // Act
      final result = await authRepositoryImpl.loginWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      // Assert
      expect(result, Right(tMyUserDto.toUser()));
      verify(
        () => mockAuthRemoteDataSource.loginWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verify(() => mockUserRemoteDataSource.getUser(tAuthUserDto.id)).called(1);
      verify(
        () => mockUserLocalDataSource.saveUser(user: tMyUserDto),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockUserRemoteDataSource);
      verifyNoMoreInteractions(mockUserLocalDataSource);
    });

    test(
      'should return Left(UnauthorizedFailure) when user is not found in database after login',
      () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.loginWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => tAuthUserDto);
        when(
          () => mockUserRemoteDataSource.getUser(any()),
        ).thenAnswer((_) async => null);

        // Act
        final result = await authRepositoryImpl.loginWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(
          result,
          const Left(UnauthorizedFailure('some thing went wrong')),
        );
        verify(
          () => mockAuthRemoteDataSource.loginWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verify(
          () => mockUserRemoteDataSource.getUser(tAuthUserDto.id),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
        verifyNoMoreInteractions(mockUserRemoteDataSource);
        verifyZeroInteractions(mockUserLocalDataSource);
      },
    );
  });

  group('logout', () {
    test('should return Right(unit) when logout is successful', () async {
      // Arrange
      when(
        () => mockAuthRemoteDataSource.logout(),
      ).thenAnswer((_) async => unit);
      when(
        () => mockUserLocalDataSource.deleteUser(),
      ).thenAnswer((_) async => {});

      // Act
      final result = await authRepositoryImpl.logout();

      // Assert
      expect(result, const Right(unit));
      verify(() => mockAuthRemoteDataSource.logout()).called(1);
      verify(() => mockUserLocalDataSource.deleteUser()).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockUserLocalDataSource);
      verifyZeroInteractions(mockUserRemoteDataSource);
    });
  });

  group('deleteAuthUser', () {
    test('should return Right(unit) when deletion is successful', () async {
      // Arrange
      when(
        () => mockAuthRemoteDataSource.deleteAuthUser(),
      ).thenAnswer((_) async => unit);

      // Act
      final result = await authRepositoryImpl.deleteAuthUser();

      // Assert
      expect(result, const Right(unit));
      verify(() => mockAuthRemoteDataSource.deleteAuthUser()).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyZeroInteractions(mockUserLocalDataSource);
      verifyZeroInteractions(mockUserRemoteDataSource);
    });
  });

  group('reAuthenticateWithEmailAndPassword', () {
    const tPassword = 'password123';

    test(
      'should return Right(id) when re-authentication is successful',
      () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.reAuthenticateWithEmailAndPassword(
            tPassword,
          ),
        ).thenAnswer((_) async => tAuthUserDto);

        // Act
        final result = await authRepositoryImpl
            .reAuthenticateWithEmailAndPassword(tPassword);

        // Assert
        expect(result, Right(tAuthUserDto.id));
        verify(
          () => mockAuthRemoteDataSource.reAuthenticateWithEmailAndPassword(
            tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
        verifyZeroInteractions(mockUserLocalDataSource);
        verifyZeroInteractions(mockUserRemoteDataSource);
      },
    );
  });

  group('reAuthenticateWithGoogle', () {
    test(
      'should return Right(id) when re-authentication is successful',
      () async {
        // Arrange
        when(
          () => mockAuthRemoteDataSource.reAuthenticateWithGoogle(),
        ).thenAnswer((_) async => tAuthUserDto);

        // Act
        final result = await authRepositoryImpl.reAuthenticateWithGoogle();

        // Assert
        expect(result, Right(tAuthUserDto.id));
        verify(
          () => mockAuthRemoteDataSource.reAuthenticateWithGoogle(),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
        verifyZeroInteractions(mockUserLocalDataSource);
        verifyZeroInteractions(mockUserRemoteDataSource);
      },
    );
  });

  group('resetPassword', () {
    const tEmail = 'test@example.com';

    test('should return Right(unit) when reset is successful', () async {
      // Arrange
      when(
        () => mockAuthRemoteDataSource.resetPassword(email: tEmail),
      ).thenAnswer((_) async => {});

      // Act
      final result = await authRepositoryImpl.resetPassword(email: tEmail);

      // Assert
      expect(result, const Right(unit));
      verify(
        () => mockAuthRemoteDataSource.resetPassword(email: tEmail),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyZeroInteractions(mockUserLocalDataSource);
      verifyZeroInteractions(mockUserRemoteDataSource);
    });
  });
}
