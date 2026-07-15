import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../failure/failure.dart';
import '../repository/auth/auth_repository.dart';
import '../repository/biometric/biometric_repository.dart';
import '../repository/vault/vault_repository.dart';


@injectable
class LogoutUseCase {
  final AuthRepository _authRepository;
  final BiometricRepository _biometricRepository;
  final VaultRepository _vaultRepository;

  LogoutUseCase(
    this._authRepository,
    this._biometricRepository,
    this._vaultRepository,
  );

  Future<Either<Failure, Unit>> invoke() async {
    // 1. Clear SecretKey from memory
    _vaultRepository.lock();

    // 2. Delete SecretKey from SecureStorage
    await _biometricRepository.deleteSecretKey();

    // 3. Save useBiometric = false
    await _biometricRepository.setBiometricEnabled(false);

    // 4. Firebase signOut and clear user cache
    return await _authRepository.logout();
  }
}
