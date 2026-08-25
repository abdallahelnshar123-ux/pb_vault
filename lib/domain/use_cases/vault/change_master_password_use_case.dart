import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';

import '../../failure/failure.dart';
import '../../repository/account/account_repository.dart';
import '../../repository/biometric/biometric_repository.dart';
import '../../repository/user/user_repository.dart';
import '../../repository/vault/vault_repository.dart';

@injectable
class ChangeMasterPasswordUseCase {
  final UserRepository _userRepository;
  final AccountRepository _accountRepository;
  final VaultRepository _vaultRepository;
  final BiometricRepository _biometricRepository;

  ChangeMasterPasswordUseCase(
    this._userRepository,
    this._accountRepository,
    this._vaultRepository,
    this._biometricRepository,
  );

  Future<Either<Failure, MyUser>> invoke({required String newPassword}) async {
    // 1. Get current user from cache
    final userResult = _userRepository.getUserFromCache();
    return await userResult.fold((failure) => Left(failure), (
      userOption,
    ) async {
      return await userOption.fold(
        () => const Left(UnexpectedFailure('error_while_getting_data')),
        (user) async {
          // 2. Check if new password is same as old password
          final isSame = await _isSamePassword(
            password: newPassword,
            salt: user.salt!,
            verifier: user.passwordVerifier!,
          );

          if (isSame) {
            return const Left(UnexpectedFailure('same_as_old_password'));
          }

          // 3. Fetch and decrypt all accounts
          final accountsResult = await _accountRepository.getAllAccounts(
            user.id,
          );
          return await accountsResult.fold((failure) => Left(failure), (
            accounts,
          ) async {
            // 4. Create new verifier and salt (this also updates VaultCryptoService secret key)
            final verifierResult = await _vaultRepository.createVerifier(
              newPassword,
            );
            return await verifierResult.fold((failure) => Left(failure), (
              verifierData,
            ) async {
              final newSalt = verifierData['salt'] as List<int>;
              final newVerifier = verifierData['hash'] as String;

              final updatedUser = user.copyWith(
                salt: newSalt,
                passwordVerifier: newVerifier,
              );

              // 5. Re-encrypt accounts and update in batch
              final updateResult = await _userRepository.changeMasterPassword(
                user: updatedUser,
                accounts: accounts,
              );

              return await updateResult.fold((failure) => Left(failure), (
                _,
              ) async {
                // 6. Update biometrics if enabled
                if (_biometricRepository.isBiometricEnabled().getOrElse(
                  () => false,
                )) {
                  final keyResult = await _vaultRepository.getSecretKeyBytes();
                  return await keyResult.fold((failure) => Left(failure), (
                    keyBytes,
                  ) async {
                    await _biometricRepository.saveSecretKey(keyBytes);
                    return Right(updatedUser);
                  });
                }
                return Right(updatedUser);
              });
            });
          });
        },
      );
    });
  }

  Future<bool> _isSamePassword({
    required String password,
    required List<int> salt,
    required String verifier,
  }) async {
    final result = await _vaultRepository.calculateVerifier(
      password: password,
      salt: salt,
    );

    return result.fold(
      (failure) => false,
      (calculatedVerifier) => verifier == calculatedVerifier,
    );
  }
}
