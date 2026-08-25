import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/account/account_repository.dart';
import 'package:pb_vault/domain/use_cases/get_accounts_use_case.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late MockAccountRepository mockAccountRepo;
  late GetAccountsUseCase useCase;

  setUp(() {
    mockAccountRepo = MockAccountRepository();
    useCase = GetAccountsUseCase(mockAccountRepo);
  });

  const tUserId = '1';
  final tAccounts = <PlatformAccount>[];

  test('should return a Stream from AccountRepository.getAccounts', () async {
    // Arrange
    when(() => mockAccountRepo.getAccounts(any()))
        .thenAnswer((_) => Stream.value(Right(tAccounts)));

    // Act
    final result = useCase.invoke(tUserId);

    // Assert
    expect(result, emits(Right(tAccounts)));
    verify(() => mockAccountRepo.getAccounts(tUserId)).called(1);
    verifyNoMoreInteractions(mockAccountRepo);
  });

  test('should emit Failure when AccountRepository.getAccounts fails', () async {
    // Arrange
    const tFailure = ServerFailure('Stream Error');
    when(() => mockAccountRepo.getAccounts(any()))
        .thenAnswer((_) => Stream.value(const Left(tFailure)));

    // Act
    final result = useCase.invoke(tUserId);

    // Assert
    expect(result, emits(const Left(tFailure)));
    verify(() => mockAccountRepo.getAccounts(tUserId)).called(1);
    verifyNoMoreInteractions(mockAccountRepo);
  });
}
