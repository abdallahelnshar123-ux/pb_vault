import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/biometric/biometric_repository.dart';
import 'package:pb_vault/domain/repository/vault/vault_repository.dart';
import 'package:pb_vault/domain/use_cases/biometric/enable_biometric_use_case.dart';

class MockBiometricRepository extends Mock implements BiometricRepository {}

class MockVaultRepository extends Mock implements VaultRepository {}

void main() {
  late MockBiometricRepository mockBiometricRepository;
  late MockVaultRepository mockVaultRepository;
  late EnableBiometricUseCase useCase;

  setUp(() {
    mockBiometricRepository = MockBiometricRepository();
    mockVaultRepository = MockVaultRepository();
    useCase = EnableBiometricUseCase(mockBiometricRepository, mockVaultRepository);
  });

  group('EnableBiometricUseCase', () {
    const tSecretKey = [1, 2, 3];
    const tFailure = UnexpectedFailure('Error');

    group('invoke(true) - Enabling Biometrics', () {
      test('should successfully enable biometrics', () async {
        // arrange
        when(() => mockBiometricRepository.authenticate())
            .thenAnswer((_) async => const Right(true));
        when(() => mockVaultRepository.getSecretKeyBytes())
            .thenAnswer((_) async => const Right(tSecretKey));
        when(() => mockBiometricRepository.saveSecretKey(any()))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockBiometricRepository.setBiometricEnabled(any()))
            .thenAnswer((_) async => const Right(unit));

        // act
        final result = await useCase.invoke(true);

        // assert
        expect(result, const Right(unit));
        verify(() => mockBiometricRepository.authenticate()).called(1);
        verify(() => mockVaultRepository.getSecretKeyBytes()).called(1);
        verify(() => mockBiometricRepository.saveSecretKey(tSecretKey)).called(1);
        verify(() => mockBiometricRepository.setBiometricEnabled(true)).called(1);
      });

      test('should return failure when authentication fails', () async {
        // arrange
        when(() => mockBiometricRepository.authenticate())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase.invoke(true);

        // assert
        expect(result, const Left(tFailure));
        verify(() => mockBiometricRepository.authenticate()).called(1);
        verifyZeroInteractions(mockVaultRepository);
      });

      test('should return UnexpectedFailure when authentication returns false', () async {
        // arrange
        when(() => mockBiometricRepository.authenticate())
            .thenAnswer((_) async => const Right(false));

        // act
        final result = await useCase.invoke(true);

        // assert
        expect(
          result,
          const Left(UnexpectedFailure('Biometric authentication failed')),
        );
      });

      test('should return failure when getting secret key fails', () async {
        // arrange
        when(() => mockBiometricRepository.authenticate())
            .thenAnswer((_) async => const Right(true));
        when(() => mockVaultRepository.getSecretKeyBytes())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase.invoke(true);

        // assert
        expect(result, const Left(tFailure));
      });

      test('should return failure when saving secret key fails', () async {
        // arrange
        when(() => mockBiometricRepository.authenticate())
            .thenAnswer((_) async => const Right(true));
        when(() => mockVaultRepository.getSecretKeyBytes())
            .thenAnswer((_) async => const Right(tSecretKey));
        when(() => mockBiometricRepository.saveSecretKey(any()))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase.invoke(true);

        // assert
        expect(result, const Left(tFailure));
      });

      test('should return failure when setting biometric enabled fails', () async {
        // arrange
        when(() => mockBiometricRepository.authenticate())
            .thenAnswer((_) async => const Right(true));
        when(() => mockVaultRepository.getSecretKeyBytes())
            .thenAnswer((_) async => const Right(tSecretKey));
        when(() => mockBiometricRepository.saveSecretKey(any()))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockBiometricRepository.setBiometricEnabled(any()))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase.invoke(true);

        // assert
        expect(result, const Left(tFailure));
      });
    });

    group('invoke(false) - Disabling Biometrics', () {
      test('should successfully disable biometrics', () async {
        // arrange
        when(() => mockBiometricRepository.deleteSecretKey())
            .thenAnswer((_) async => const Right(unit));
        when(() => mockBiometricRepository.setBiometricEnabled(any()))
            .thenAnswer((_) async => const Right(unit));

        // act
        final result = await useCase.invoke(false);

        // assert
        expect(result, const Right(unit));
        verify(() => mockBiometricRepository.deleteSecretKey()).called(1);
        verify(() => mockBiometricRepository.setBiometricEnabled(false)).called(1);
        verifyZeroInteractions(mockVaultRepository);
      });

      test('should return failure when deleting secret key fails', () async {
        // arrange
        when(() => mockBiometricRepository.deleteSecretKey())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase.invoke(false);

        // assert
        expect(result, const Left(tFailure));
        verifyZeroInteractions(mockVaultRepository);
      });

      test('should return failure when setting biometric disabled fails', () async {
        // arrange
        when(() => mockBiometricRepository.deleteSecretKey())
            .thenAnswer((_) async => const Right(unit));
        when(() => mockBiometricRepository.setBiometricEnabled(any()))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase.invoke(false);

        // assert
        expect(result, const Left(tFailure));
      });
    });
   group('Strict Verification', () {
      test('should not call vaultRepository when disabling biometrics', () async {
        when(() => mockBiometricRepository.deleteSecretKey())
            .thenAnswer((_) async => const Right(unit));
        when(() => mockBiometricRepository.setBiometricEnabled(any()))
            .thenAnswer((_) async => const Right(unit));

        await useCase.invoke(false);

        verifyZeroInteractions(mockVaultRepository);
      });
    });
  });
}
