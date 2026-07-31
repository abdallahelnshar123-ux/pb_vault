import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_data.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/account/account_repository.dart';
import 'package:pb_vault/domain/use_cases/get_account_by_id_use_case.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late GetAccountByIdUseCase useCase;
  late MockAccountRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountRepository();
    useCase = GetAccountByIdUseCase(mockRepository);
  });

  const tUserId = 'user_123';
  const tAccountId = 'acc_456';
  final tPlatformAccount = PlatformAccount(
    id: tAccountId,
    platform: const PlatformData(
      name: 'Google',
      icon: 'google_icon',
      website: 'google.com',
    ),
    identifier: 'user@gmail.com',
    createdAt: DateTime(2023, 1, 1),
  );

  group('GetAccountBtIdUseCase', () {
    test(
      'should return Right(PlatformAccount) when repository call is successful',
      () async {
        // Arrange
        when(() => mockRepository.getAccountById(any(), any()))
            .thenAnswer((_) async => Right(tPlatformAccount));

        // Act
        final result = await useCase.invoke(
          userId: tUserId,
          accountId: tAccountId,
        );

        // Assert
        expect(result, Right(tPlatformAccount));
        verify(() => mockRepository.getAccountById(tUserId, tAccountId))
            .called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return Left(Failure) when repository call fails',
      () async {
        // Arrange
        const tFailure = ServerFailure('Account not found');
        when(() => mockRepository.getAccountById(any(), any()))
            .thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase.invoke(
          userId: tUserId,
          accountId: tAccountId,
        );

        // Assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.getAccountById(tUserId, tAccountId))
            .called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
