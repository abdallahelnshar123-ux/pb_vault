import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/platform_account/encrypted_data.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/vault/vault_repository.dart';
import 'package:pb_vault/domain/use_cases/vault/encrypt_value_use_case.dart';

class MockVaultRepository extends Mock implements VaultRepository {}

void main() {
  late MockVaultRepository mockVaultRepo;
  late EncryptValueUseCase useCase;

  setUp(() {
    mockVaultRepo = MockVaultRepository();
    useCase = EncryptValueUseCase(mockVaultRepo);
  });

  const tPassword = 'password123';
  final tEncryptedData = EncryptedData(
    cipherText: [1, 2, 3],
    mac: [4, 5, 6],
    nonce: [7, 8, 9],
  );

  test('should call VaultRepository.encrypt and return EncryptedData', () async {
    // Arrange
    when(() => mockVaultRepo.encrypt(any()))
        .thenAnswer((_) async => Right(tEncryptedData));

    // Act
    final result = await useCase.invoke(tPassword);

    // Assert
    expect(result, Right(tEncryptedData));
    verify(() => mockVaultRepo.encrypt(tPassword)).called(1);
    verifyNoMoreInteractions(mockVaultRepo);
  });
  test('should call VaultRepository.encrypt and return EncryptedData', () async {
    // Arrange
    when(() => mockVaultRepo.encrypt(any()))
        .thenAnswer((_) async => Left(UnexpectedFailure('error')));

    // Act
    final result = await useCase.invoke(tPassword);

    // Assert
    expect(result, Left(UnexpectedFailure('error')));
    verify(() => mockVaultRepo.encrypt(tPassword)).called(1);
    verifyNoMoreInteractions(mockVaultRepo);
  });
}
