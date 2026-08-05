import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/repository/account/account_repository.dart';
import 'package:pb_vault/domain/repository/biometric/biometric_repository.dart';
import 'package:pb_vault/domain/repository/user/user_repository.dart';
import 'package:pb_vault/domain/repository/vault/vault_repository.dart';
import 'package:pb_vault/domain/use_cases/vault/change_master_password_use_case.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

class MockVaultRepository extends Mock implements VaultRepository {}

class MockBiometricRepository extends Mock implements BiometricRepository {}

void main() {
  late ChangeMasterPasswordUseCase useCase;
  late MockUserRepository mockUserRepository;
  late MockAccountRepository mockAccountRepository;
  late MockVaultRepository mockVaultRepository;
  late MockBiometricRepository mockBiometricRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockAccountRepository = MockAccountRepository();
    mockVaultRepository = MockVaultRepository();
    mockBiometricRepository = MockBiometricRepository();
    useCase = ChangeMasterPasswordUseCase(
      mockUserRepository,
      mockAccountRepository,
      mockVaultRepository,
      mockBiometricRepository,
    );
  });

  const tNewPassword = 'newPassword123';
  const tOldVerifier = 'old_verifier';
  const tOldSalt = [1, 1, 1];
  const tUser = MyUser(
    id: 'user123',
    email: 'test@example.com',
    name: 'Test User',
    provider: 'google',
    passwordVerifier: tOldVerifier,
    salt: tOldSalt,
  );

  final tAccounts = [
    PlatformAccount(
      id: 'acc1',
      platformId: 'plat1',
      identifier: 'id1',
      createdAt: DateTime(2023),
    ),
  ];

  const tNewSalt = [2, 2, 2];
  const tNewVerifier = 'new_verifier';
  final tVerifierData = {
    'salt': tNewSalt,
    'hash': tNewVerifier,
  };

  final tUpdatedUser = tUser.copyWith(
    salt: tNewSalt,
    passwordVerifier: tNewVerifier,
  );

  group('invoke', () {
    test('should change master password successfully when all steps succeed',
        () async {
      // Arrange
      when(() => mockUserRepository.getUserFromCache())
          .thenReturn(const Right(Some(tUser)));
      when(() => mockVaultRepository.calculateVerifier(
            password: tNewPassword,
            salt: tOldSalt,
          )).thenAnswer((_) async => const Right('different_verifier'));
      when(() => mockAccountRepository.getAllAccounts(tUser.id))
          .thenAnswer((_) async => Right(tAccounts));
      when(() => mockVaultRepository.createVerifier(tNewPassword))
          .thenAnswer((_) async => Right(tVerifierData));
      when(() => mockUserRepository.changeMasterPassword(
            user: tUpdatedUser,
            accounts: tAccounts,
          )).thenAnswer((_) async => const Right(unit));
      when(() => mockBiometricRepository.isBiometricEnabled())
          .thenReturn(const Right(false));

      // Act
      final result = await useCase.invoke(newPassword: tNewPassword);

      // Assert
      expect(result, Right(tUpdatedUser));
      verify(() => mockUserRepository.getUserFromCache()).called(1);
      verify(() => mockVaultRepository.calculateVerifier(
            password: tNewPassword,
            salt: tOldSalt,
          )).called(1);
      verify(() => mockAccountRepository.getAllAccounts(tUser.id)).called(1);
      verify(() => mockVaultRepository.createVerifier(tNewPassword)).called(1);
      verify(() => mockUserRepository.changeMasterPassword(
            user: tUpdatedUser,
            accounts: tAccounts,
          )).called(1);
      verify(() => mockBiometricRepository.isBiometricEnabled()).called(1);

      verifyNoMoreInteractions(mockUserRepository);
      verifyNoMoreInteractions(mockAccountRepository);
      verifyNoMoreInteractions(mockVaultRepository);
      verifyNoMoreInteractions(mockBiometricRepository);
    });
    test('should return Left(Failure) when getUserFromCache fails', () async {
      // Arrange
      const tFailure = CacheFailure('cache_error');

      when(() => mockUserRepository.getUserFromCache())
          .thenReturn(const Left(tFailure));

      // Act
      final result = await useCase.invoke(newPassword: tNewPassword);

      // Assert
      expect(result, const Left(tFailure));

      verify(() => mockUserRepository.getUserFromCache()).called(1);

      verifyZeroInteractions(mockAccountRepository);
      verifyZeroInteractions(mockVaultRepository);
      verifyZeroInteractions(mockBiometricRepository);
    });
    test('should update biometrics when enabled', () async {
      // Arrange
      const tKeyBytes = [3, 3, 3];
      when(() => mockUserRepository.getUserFromCache())
          .thenReturn(const Right(Some(tUser)));
      when(() => mockVaultRepository.calculateVerifier(
            password: tNewPassword,
            salt: tOldSalt,
          )).thenAnswer((_) async => const Right('different_verifier'));
      when(() => mockAccountRepository.getAllAccounts(tUser.id))
          .thenAnswer((_) async => Right(tAccounts));
      when(() => mockVaultRepository.createVerifier(tNewPassword))
          .thenAnswer((_) async => Right(tVerifierData));
      when(() => mockUserRepository.changeMasterPassword(
            user: tUpdatedUser,
            accounts: tAccounts,
          )).thenAnswer((_) async => const Right(unit));
      when(() => mockBiometricRepository.isBiometricEnabled())
          .thenReturn(const Right(true));
      when(() => mockVaultRepository.getSecretKeyBytes())
          .thenAnswer((_) async => const Right(tKeyBytes));
      when(() => mockBiometricRepository.saveSecretKey(tKeyBytes))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await useCase.invoke(newPassword: tNewPassword);

      // Assert
      expect(result, Right(tUpdatedUser));
      verify(() => mockVaultRepository.getSecretKeyBytes()).called(1);
      verify(() => mockBiometricRepository.saveSecretKey(tKeyBytes)).called(1);
    });

    test('should return Left(Failure) when user is not in cache', () async {
      // Arrange
      when(() => mockUserRepository.getUserFromCache())
          .thenReturn(const Right(None()));

      // Act
      final result = await useCase.invoke(newPassword: tNewPassword);

      // Assert
      expect(result,
          const Left(UnexpectedFailure('error_while_getting_data')));
      verify(() => mockUserRepository.getUserFromCache()).called(1);
      verifyZeroInteractions(mockVaultRepository);
      verifyZeroInteractions(mockAccountRepository);
      verifyZeroInteractions(mockBiometricRepository);
    });

    test('should return Left(UnexpectedFailure) with same_as_old_password message when password is the same', () async {
      // Arrange
      when(() => mockUserRepository.getUserFromCache())
          .thenReturn(const Right(Some(tUser)));
      when(() => mockVaultRepository.calculateVerifier(
            password: tNewPassword,
            salt: tOldSalt,
          )).thenAnswer((_) async => const Right(tOldVerifier));

      // Act
      final result = await useCase.invoke(newPassword: tNewPassword);

      // Assert
      expect(result, const Left(UnexpectedFailure('same_as_old_password')));
      verify(() => mockUserRepository.getUserFromCache()).called(1);
      verify(() => mockVaultRepository.calculateVerifier(
            password: tNewPassword,
            salt: tOldSalt,
          )).called(1);
      verifyZeroInteractions(mockAccountRepository);
    });

    test('should return Left(Failure) when fetching accounts fails', () async {
      // Arrange
      const tFailure = ServerFailure('error');
      when(() => mockUserRepository.getUserFromCache())
          .thenReturn(const Right(Some(tUser)));
      when(() => mockVaultRepository.calculateVerifier(
            password: tNewPassword,
            salt: tOldSalt,
          )).thenAnswer((_) async => const Right('different'));
      when(() => mockAccountRepository.getAllAccounts(tUser.id))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.invoke(newPassword: tNewPassword);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockAccountRepository.getAllAccounts(tUser.id)).called(1);
      verifyZeroInteractions(mockBiometricRepository);
    });
    test('should return Left(Failure) when createVerifier fails', () async {
      // Arrange
      const tFailure = ServerFailure('create_verifier_error');

      when(() => mockUserRepository.getUserFromCache())
          .thenReturn(const Right(Some(tUser)));

      when(() => mockVaultRepository.calculateVerifier(
        password: tNewPassword,
        salt: tOldSalt,
      )).thenAnswer((_) async => const Right('different'));

      when(() => mockAccountRepository.getAllAccounts(tUser.id))
          .thenAnswer((_) async => Right(tAccounts));

      when(() => mockVaultRepository.createVerifier(tNewPassword))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.invoke(newPassword: tNewPassword);

      // Assert
      expect(result, const Left(tFailure));

      verify(() => mockVaultRepository.createVerifier(tNewPassword)).called(1);

      verifyZeroInteractions(mockBiometricRepository);
    });

    test(
        'should continue when calculateVerifier fails because _isSamePassword returns false',
            () async {
          // Arrange
          when(() => mockUserRepository.getUserFromCache())
              .thenReturn(const Right(Some(tUser)));

          when(() => mockVaultRepository.calculateVerifier(
            password: tNewPassword,
            salt: tOldSalt,
          )).thenAnswer((_) async => const Left(ServerFailure('error')));

          when(() => mockAccountRepository.getAllAccounts(tUser.id))
              .thenAnswer((_) async => Right(tAccounts));

          when(() => mockVaultRepository.createVerifier(tNewPassword))
              .thenAnswer((_) async => Right(tVerifierData));

          when(() => mockUserRepository.changeMasterPassword(
            user: tUpdatedUser,
            accounts: tAccounts,
          )).thenAnswer((_) async => const Right(unit));

          when(() => mockBiometricRepository.isBiometricEnabled())
              .thenReturn(const Right(false));

          // Act
          final result = await useCase.invoke(newPassword: tNewPassword);

          // Assert
          expect(result, Right(tUpdatedUser));
        });
    test('should return Left(Failure) when getSecretKeyBytes fails', () async {
      // Arrange
      const tFailure = ServerFailure('key_error');

      when(() => mockUserRepository.getUserFromCache())
          .thenReturn(const Right(Some(tUser)));

      when(() => mockVaultRepository.calculateVerifier(
        password: tNewPassword,
        salt: tOldSalt,
      )).thenAnswer((_) async => const Right('different'));

      when(() => mockAccountRepository.getAllAccounts(tUser.id))
          .thenAnswer((_) async => Right(tAccounts));

      when(() => mockVaultRepository.createVerifier(tNewPassword))
          .thenAnswer((_) async => Right(tVerifierData));

      when(() => mockUserRepository.changeMasterPassword(
        user: tUpdatedUser,
        accounts: tAccounts,
      )).thenAnswer((_) async => const Right(unit));

      when(() => mockBiometricRepository.isBiometricEnabled())
          .thenReturn(const Right(true));

      when(() => mockVaultRepository.getSecretKeyBytes())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.invoke(newPassword: tNewPassword);

      // Assert
      expect(result, const Left(tFailure));

      verify(() => mockVaultRepository.getSecretKeyBytes()).called(1);

      verifyNever(() => mockBiometricRepository.saveSecretKey(any()));
    });
     test('should return Left(Failure) when changeMasterPassword fails', () async {
      // Arrange
      const tFailure = ServerFailure('update_error');
      when(() => mockUserRepository.getUserFromCache())
          .thenReturn(const Right(Some(tUser)));
      when(() => mockVaultRepository.calculateVerifier(
            password: tNewPassword,
            salt: tOldSalt,
          )).thenAnswer((_) async => const Right('different'));
      when(() => mockAccountRepository.getAllAccounts(tUser.id))
          .thenAnswer((_) async => Right(tAccounts));
      when(() => mockVaultRepository.createVerifier(tNewPassword))
          .thenAnswer((_) async => Right(tVerifierData));
      when(() => mockUserRepository.changeMasterPassword(
            user: tUpdatedUser,
            accounts: tAccounts,
          )).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.invoke(newPassword: tNewPassword);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockUserRepository.changeMasterPassword(
            user: tUpdatedUser,
            accounts: tAccounts,
          )).called(1);
      verifyZeroInteractions(mockBiometricRepository);
    });
  });
}
