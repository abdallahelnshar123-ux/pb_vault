import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_data.dart';
import 'package:pb_vault/domain/entities/response/platform_account/encrypted_data.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/account/account_repository.dart';
import 'package:pb_vault/domain/use_cases/update_account_use_case.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late MockAccountRepository mockAccountRepo;
  late UpdatePlatformAccountUseCase useCase;

  setUpAll(() {
    registerFallbackValue(PlatformAccount(
      platform: const PlatformData(name: 'name', icon: 'icon', website: 'icon'),
      identifier: 'email',
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockAccountRepo = MockAccountRepository();
    useCase = UpdatePlatformAccountUseCase(mockAccountRepo);
  });

  const tUserId = '1';
  final tAccount = PlatformAccount(
    platform: const PlatformData(name: 'name', icon: 'icon', website: 'icon'),
    identifier: 'email',
    password: const EncryptedData(
      cipherText: [4, 5, 6],
      mac: [3, 6, 9],
      nonce: [3, 2, 4],
    ),
    createdAt: DateTime.now(),
  );

  test('should call AccountRepository.updateAccount and return Right(unit)', () async {
    // Arrange
    when(() => mockAccountRepo.updateAccount(any(), any()))
        .thenAnswer((_) async => const Right(unit));

    // Act
    final result = await useCase.invoke(tUserId, tAccount);

    // Assert
    expect(result, const Right(unit));
    verify(() => mockAccountRepo.updateAccount(tUserId, tAccount)).called(1);
    verifyNoMoreInteractions(mockAccountRepo);
  });

  test('should return Failure when AccountRepository.updateAccount fails', () async {
    // Arrange
    const tFailure = ServerFailure('Update Error');
    when(() => mockAccountRepo.updateAccount(any(), any()))
        .thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase.invoke(tUserId, tAccount);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockAccountRepo.updateAccount(tUserId, tAccount)).called(1);
    verifyNoMoreInteractions(mockAccountRepo);
  });
}
