import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/auth/auth_repository.dart';
import 'package:pb_vault/domain/use_cases/reset_password_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late ResetPasswordUseCase useCase;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    useCase = ResetPasswordUseCase(mockAuthRepo);
  });

  const tEmail = 'test@example.com';

  test('should call AuthRepository.resetPassword and return Right(unit)', () async {
    // Arrange
    when(() => mockAuthRepo.resetPassword(email: any(named: 'email')))
        .thenAnswer((_) async => const Right(unit));

    // Act
    final result = await useCase.invoke(email: tEmail);

    // Assert
    expect(result, const Right(unit));
    verify(() => mockAuthRepo.resetPassword(email: tEmail)).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });

  test('should return Failure when AuthRepository.resetPassword fails', () async {
    // Arrange
    const tFailure = ServerFailure('Reset Error');
    when(() => mockAuthRepo.resetPassword(email: any(named: 'email')))
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase.invoke(email: tEmail);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockAuthRepo.resetPassword(email: tEmail)).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });
}
