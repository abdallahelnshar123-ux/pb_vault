import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/auth/auth_repository.dart';
import 'package:pb_vault/domain/repository/biometric/biometric_repository.dart';
import 'package:pb_vault/domain/repository/vault/vault_repository.dart';
import 'package:pb_vault/domain/use_cases/logout_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockBiometricRepository extends Mock implements BiometricRepository {}

class MockVaultRepository extends Mock implements VaultRepository {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockBiometricRepository mockBiometricRepository;
  late MockVaultRepository mockVaultRepository;
  late LogoutUseCase useCase;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockVaultRepository = MockVaultRepository();
    mockBiometricRepository = MockBiometricRepository();
    useCase = LogoutUseCase(
      mockAuthRepo,
      mockBiometricRepository,
      mockVaultRepository,
    );
  });

  group('LogoutUseCase', () {
    void setUpSuccessStubs() {
      // Stubbing vault lock (void method)
      when(() => mockVaultRepository.lock()).thenReturn(null);
      
      // Stubbing biometric repository methods
      when(() => mockBiometricRepository.deleteSecretKey())
          .thenAnswer((_) async => const Right(unit));
      when(() => mockBiometricRepository.setBiometricEnabled(any()))
          .thenAnswer((_) async => const Right(unit));
    }

    test(
      'should call necessary repositories to clear data and return Right(unit) when logout succeeds',
      () async {
        // Arrange
        setUpSuccessStubs();
        when(() => mockAuthRepo.logout())
            .thenAnswer((_) async => const Right(unit));

        // Act
        final result = await useCase.invoke();

        // Assert
        expect(result, const Right(unit));
        
        verify(() => mockVaultRepository.lock()).called(1);
        verify(() => mockBiometricRepository.deleteSecretKey()).called(1);
        verify(() => mockBiometricRepository.setBiometricEnabled(false)).called(1);
        verify(() => mockAuthRepo.logout()).called(1);
        
        verifyNoMoreInteractions(mockVaultRepository);
        verifyNoMoreInteractions(mockBiometricRepository);
        verifyNoMoreInteractions(mockAuthRepo);
      },
    );

    test(
      'should still clear local data and return Failure when AuthRepository.logout fails',
      () async {
        // Arrange
        setUpSuccessStubs();
        const tFailure = ServerFailure('Logout Failed');
        when(() => mockAuthRepo.logout())
            .thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase.invoke();

        // Assert
        expect(result, const Left(tFailure));
        
        verify(() => mockVaultRepository.lock()).called(1);
        verify(() => mockBiometricRepository.deleteSecretKey()).called(1);
        verify(() => mockBiometricRepository.setBiometricEnabled(false)).called(1);
        verify(() => mockAuthRepo.logout()).called(1);
        
        verifyNoMoreInteractions(mockVaultRepository);
        verifyNoMoreInteractions(mockBiometricRepository);
        verifyNoMoreInteractions(mockAuthRepo);
      },
    );
  });
}
