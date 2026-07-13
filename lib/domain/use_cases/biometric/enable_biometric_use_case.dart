import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../failure/failure.dart';
import '../../repository/biometric/biometric_repository.dart';
import '../../repository/vault/vault_repository.dart';

@injectable
class EnableBiometricUseCase {
  final BiometricRepository _biometricRepository;
  final VaultRepository _vaultRepository;

  EnableBiometricUseCase(this._biometricRepository, this._vaultRepository);

  Future<Either<Failure, Unit>> invoke(bool enable) async {
    if (enable) {
      final authResult = await _biometricRepository.authenticate();
      return await authResult.fold((failure) => Left(failure), (
        authenticated,
      ) async {
        if (authenticated) {
          final keyResult = await _vaultRepository.getSecretKeyBytes();
          return await keyResult.fold((failure) => Left(failure), (
            keyBytes,
          ) async {
            final saveResult = await _biometricRepository.saveSecretKey(
              keyBytes,
            );
            return await saveResult.fold((failure) => Left(failure), (_) async {
              return await _biometricRepository.setBiometricEnabled(true);
            });
          });
        }
        return const Left(UnexpectedFailure('Biometric authentication failed'));
      });
    } else {
      final deleteResult = await _biometricRepository.deleteSecretKey();
      return await deleteResult.fold((failure) => Left(failure), (_) async {
        return await _biometricRepository.setBiometricEnabled(false);
      });
    }
  }
}
