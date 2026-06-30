import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/user/auth_providers.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/auth/auth_repository.dart';
import 'package:pb_vault/domain/repository/user/user_repository.dart';
import 'package:pb_vault/domain/use_cases/delete_account_use_case.dart';

class MockUserRepository extends Mock implements UserRepository {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockAuthRepository mockAuthRepository;
  late DeleteUserUseCase useCase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockAuthRepository = MockAuthRepository();
    useCase = DeleteUserUseCase(mockUserRepository, mockAuthRepository);
  });

  const tPassword = 'password';
  const tUid = '123';

  group('DeleteUserUseCase', () {
    test('should re-authenticate with email/password and delete user successfully', () async {
      // Arrange
      when(() => mockAuthRepository.reAuthenticateWithEmailAndPassword(any()))
          .thenAnswer((_) async => const Right(tUid));
      when(() => mockUserRepository.deleteDatabaseUser(uId: any(named: 'uId')))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockAuthRepository.deleteAuthUser())
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await useCase.invoke(
        password: tPassword,
        provider: AuthProviders.emailPassword,
      );

      // Assert
      expect(result, const Right(unit));
      verify(() => mockAuthRepository.reAuthenticateWithEmailAndPassword(tPassword)).called(1);
      verify(() => mockUserRepository.deleteDatabaseUser(uId: tUid)).called(1);
      verify(() => mockAuthRepository.deleteAuthUser()).called(1);
    });

    test('should re-authenticate with google and delete user successfully', () async {
      // Arrange
      when(() => mockAuthRepository.reAuthenticateWithGoogle())
          .thenAnswer((_) async => const Right(tUid));
      when(() => mockUserRepository.deleteDatabaseUser(uId: any(named: 'uId')))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockAuthRepository.deleteAuthUser())
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await useCase.invoke(
        password: '',
        provider: AuthProviders.google,
      );

      // Assert
      expect(result, const Right(unit));
      verify(() => mockAuthRepository.reAuthenticateWithGoogle()).called(1);
      verify(() => mockUserRepository.deleteDatabaseUser(uId: tUid)).called(1);
      verify(() => mockAuthRepository.deleteAuthUser()).called(1);
    });

    test('should return Failure when re-authentication fails', () async {
      // Arrange
      const tFailure = ServerFailure('Auth Error');
      when(() => mockAuthRepository.reAuthenticateWithGoogle())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.invoke(
        password: '',
        provider: AuthProviders.google,
      );

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockAuthRepository.reAuthenticateWithGoogle()).called(1);
      verifyZeroInteractions(mockUserRepository);
    });

    test('should return Failure when database deletion fails', () async {
      // Arrange
      const tFailure = ServerFailure('DB Error');
      when(() => mockAuthRepository.reAuthenticateWithGoogle())
          .thenAnswer((_) async => const Right(tUid));
      when(() => mockUserRepository.deleteDatabaseUser(uId: any(named: 'uId')))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.invoke(
        password: '',
        provider: AuthProviders.google,
      );

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockAuthRepository.reAuthenticateWithGoogle()).called(1);
      verify(() => mockUserRepository.deleteDatabaseUser(uId: tUid)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
