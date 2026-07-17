import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/vault/encrypted_data.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/vault/vault_repository.dart';
import 'package:pb_vault/domain/use_cases/vault/decrypt_password_use_case.dart';

class MockVaultRepository extends Mock implements VaultRepository {}

void main() {
  late MockVaultRepository mockVaultRepo;
  late DecryptPasswordUseCase useCase;

  setUpAll(() {
    registerFallbackValue(EncryptedData(
      cipherText: [],
      mac: [],
      nonce: [],
    ));
  });

  setUp(() {
    mockVaultRepo = MockVaultRepository();
    useCase = DecryptPasswordUseCase(mockVaultRepo);
  });

  final tEncryptedData = EncryptedData(
    cipherText: [1, 2, 3],
    mac: [4, 5, 6],
    nonce: [7, 8, 9],
  );
  const tDecryptedPassword = 'password123';

  test('should call VaultRepository.decrypt and return decrypted string', () async {
    // Arrange
    when(() => mockVaultRepo.decrypt(any()))
        .thenAnswer((_) async => Right(tDecryptedPassword));

    // Act
    final result = await useCase.invoke(tEncryptedData);

    // Assert
    expect(result, Right(tDecryptedPassword));
    verify(() => mockVaultRepo.decrypt(tEncryptedData)).called(1);
    verifyNoMoreInteractions(mockVaultRepo);
  });
  test('should call VaultRepository.decrypt and return decrypted string', () async {
    // Arrange
    when(() => mockVaultRepo.decrypt(any()))
        .thenAnswer((_) async => Left(UnexpectedFailure('error')));

    // Act
    final result = await useCase.invoke(tEncryptedData);

    // Assert
    expect(result, Left(UnexpectedFailure('error')));
    verify(() => mockVaultRepo.decrypt(tEncryptedData)).called(1);
    verifyNoMoreInteractions(mockVaultRepo);
  });
}
