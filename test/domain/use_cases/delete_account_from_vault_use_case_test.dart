import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/account/account_repository.dart';
import 'package:pb_vault/domain/use_cases/delete_account_from_vault_use_case.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late MockAccountRepository mockAccountRepo;
  late DeletePlatformAccountUseCase useCase;

  setUp(() {
    mockAccountRepo = MockAccountRepository();
    useCase = DeletePlatformAccountUseCase(mockAccountRepo);
  });

  const tUserId = '1';
  const tAccountId = 'acc123';

  test('should call AccountRepository.deleteAccount and return Right(unit)', () async {
    // Arrange
    when(() => mockAccountRepo.deleteAccount(any(), any()))
        .thenAnswer((_) async => const Right(unit));

    // Act
    final result = await useCase.invoke(tUserId, tAccountId);

    // Assert
    expect(result, const Right(unit));
    verify(() => mockAccountRepo.deleteAccount(tUserId, tAccountId)).called(1);
    verifyNoMoreInteractions(mockAccountRepo);
  });

  test('should return Failure when AccountRepository.deleteAccount fails', () async {
    // Arrange
    const tFailure = ServerFailure('Delete Error');
    when(() => mockAccountRepo.deleteAccount(any(), any()))
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase.invoke(tUserId, tAccountId);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockAccountRepo.deleteAccount(tUserId, tAccountId)).called(1);
    verifyNoMoreInteractions(mockAccountRepo);
  });
}
