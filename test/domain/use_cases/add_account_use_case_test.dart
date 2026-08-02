import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/account/account_repository.dart';
import 'package:pb_vault/domain/use_cases/add_account_use_case.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late MockAccountRepository mockAccountRepo;
  late AddPlatformAccountUseCase accountUseCase;

  setUpAll(() {
    registerFallbackValue(PlatformAccount(
      platformId: 'platform_id',
      identifier: 'email',
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockAccountRepo = MockAccountRepository();
    accountUseCase = AddPlatformAccountUseCase(mockAccountRepo);
  });

  const tUserId = '1';
  final tAccount = PlatformAccount(
    platformId: 'platform_id',
    identifier: 'email',
    password: 'password123',
    createdAt: DateTime.now(),
  );

  test('should call accountRepo.addAccount and return Right(unit) when successful', () async {
    // Arrange
    when(() => mockAccountRepo.addAccount(any(), any()))
        .thenAnswer((_) async => const Right(unit));

    // Act
    final result = await accountUseCase.invoke(tUserId, tAccount);

    // Assert
    expect(result, const Right(unit));
    verify(() => mockAccountRepo.addAccount(tUserId, tAccount)).called(1);
    verifyNoMoreInteractions(mockAccountRepo);
  });

  test('should return Left(Failure) when accountRepo.addAccount fails', () async {
    // Arrange
    const tFailure = ServerFailure('Server Error');
    when(() => mockAccountRepo.addAccount(any(), any()))
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await accountUseCase.invoke(tUserId, tAccount);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockAccountRepo.addAccount(tUserId, tAccount)).called(1);
    verifyNoMoreInteractions(mockAccountRepo);
  });
}
