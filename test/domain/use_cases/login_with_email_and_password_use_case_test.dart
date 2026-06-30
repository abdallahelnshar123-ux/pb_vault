import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/auth/auth_repository.dart';
import 'package:pb_vault/domain/use_cases/login_with_email_and_password_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late LoginWithEmailAndPasswordUseCase useCase;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    useCase = LoginWithEmailAndPasswordUseCase(mockAuthRepo);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tMyUser = MyUser(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
    provider: 'email',
  );

  test('should call AuthRepository.login when executed', () async {
    // Arrange
    when(() => mockAuthRepo.loginWithEmailAndPassword(
      email: tEmail,
      password: tPassword,
    )).thenAnswer((_) async => const Right(tMyUser));

    // Act
    final result = await useCase.invoke(email: tEmail, password: tPassword);

    // Assert
    expect(result, const Right(tMyUser));
    verify(() => mockAuthRepo.loginWithEmailAndPassword(
      email: tEmail,
      password: tPassword,
    )).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });

  test('should return a Failure when the repository call is unsuccessful', () async {
    // Arrange
    const tFailure = ServerFailure('Server Error');
    when(() => mockAuthRepo.loginWithEmailAndPassword(
      email: tEmail,
      password: tPassword,
    )).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase.invoke(email: tEmail, password: tPassword);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockAuthRepo.loginWithEmailAndPassword(
      email: tEmail,
      password: tPassword,
    )).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });
}
