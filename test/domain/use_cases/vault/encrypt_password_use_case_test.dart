import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/vault/encrypted_data.dart';
import 'package:pb_vault/domain/repository/vault/vault_repository.dart';
import 'package:pb_vault/domain/use_cases/vault/encrypt_password_use_case.dart';

class MockVaultRepository extends Mock implements VaultRepository {}

void main() {
  late MockVaultRepository mockVaultRepo;
  late EncryptPasswordUseCase useCase;

  setUp(() {
    mockVaultRepo = MockVaultRepository();
    useCase = EncryptPasswordUseCase(mockVaultRepo);
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
        .thenAnswer((_) async => tEncryptedData);

    // Act
    final result = await useCase.invoke(tPassword);

    // Assert
    expect(result, tEncryptedData);
    verify(() => mockVaultRepo.encrypt(tPassword)).called(1);
    verifyNoMoreInteractions(mockVaultRepo);
  });
}
