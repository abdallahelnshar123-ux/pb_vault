import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/auth/auth_repository.dart';
import 'package:pb_vault/domain/use_cases/logout_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late LogoutUseCase useCase;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    useCase = LogoutUseCase(mockAuthRepo);
  });

  test('should call AuthRepository.logout and return Right(unit)', () async {
    // Arrange
    when(() => mockAuthRepo.logout()).thenAnswer((_) async => const Right(unit));

    // Act
    final result = await useCase.invoke();

    // Assert
    expect(result, const Right(unit));
    verify(() => mockAuthRepo.logout()).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });

  test('should return Failure when AuthRepository.logout fails', () async {
    // Arrange
    const tFailure = ServerFailure('Logout Failed');
    when(() => mockAuthRepo.logout()).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase.invoke();

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockAuthRepo.logout()).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });
}
