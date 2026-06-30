import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/repository/vault/vault_repository.dart';
import 'package:pb_vault/domain/use_cases/vault/create_vault_verifier_use_case.dart';

class MockVaultRepository extends Mock implements VaultRepository {}

void main() {
  late MockVaultRepository mockVaultRepo;
  late CreateVaultVerifierUseCase useCase;

  setUp(() {
    mockVaultRepo = MockVaultRepository();
    useCase = CreateVaultVerifierUseCase(mockVaultRepo);
  });

  const tPassword = 'password123';
  final tVerifierMap = {'salt': [1, 2, 3], 'verifier': 'verifier_string'};

  test('should call VaultRepository.createVerifier and return verifier map', () async {
    // Arrange
    when(() => mockVaultRepo.createVerifier(any()))
        .thenAnswer((_) async => tVerifierMap);

    // Act
    final result = await useCase.invoke(tPassword);

    // Assert
    expect(result, tVerifierMap);
    verify(() => mockVaultRepo.createVerifier(tPassword)).called(1);
    verifyNoMoreInteractions(mockVaultRepo);
  });
}
