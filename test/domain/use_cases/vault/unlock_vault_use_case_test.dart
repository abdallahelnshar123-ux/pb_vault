import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/repository/vault/vault_repository.dart';
import 'package:pb_vault/domain/use_cases/vault/unlock_vault_use_case.dart';

class MockVaultRepository extends Mock implements VaultRepository {}

void main() {
  late MockVaultRepository mockVaultRepo;
  late UnlockVaultUseCase useCase;

  setUp(() {
    mockVaultRepo = MockVaultRepository();
    useCase = UnlockVaultUseCase(mockVaultRepo);
  });

  const tPassword = 'password';
  final tSalt = [1, 2, 3];
  const tVerifier = 'verifier';

  test('should call VaultRepository.unlock and return true', () async {
    // Arrange
    when(() => mockVaultRepo.unlock(
      password: any(named: 'password'),
      salt: any(named: 'salt'),
      verifier: any(named: 'verifier'),
    )).thenAnswer((_) async => true);

    // Act
    final result = await useCase.invoke(
      password: tPassword,
      salt: tSalt,
      verifier: tVerifier,
    );

    // Assert
    expect(result, true);
    verify(() => mockVaultRepo.unlock(
      password: tPassword,
      salt: tSalt,
      verifier: tVerifier,
    )).called(1);
    verifyNoMoreInteractions(mockVaultRepo);
  });

  test('should return false when VaultRepository.unlock fails', () async {
    // Arrange
    when(() => mockVaultRepo.unlock(
      password: any(named: 'password'),
      salt: any(named: 'salt'),
      verifier: any(named: 'verifier'),
    )).thenAnswer((_) async => false);

    // Act
    final result = await useCase.invoke(
      password: tPassword,
      salt: tSalt,
      verifier: tVerifier,
    );

    // Assert
    expect(result, false);
    verify(() => mockVaultRepo.unlock(
      password: tPassword,
      salt: tSalt,
      verifier: tVerifier,
    )).called(1);
    verifyNoMoreInteractions(mockVaultRepo);
  });
}
