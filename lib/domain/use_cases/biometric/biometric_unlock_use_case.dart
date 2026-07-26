import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../failure/failure.dart';
import '../../repository/biometric/biometric_repository.dart';
import '../../repository/vault/vault_repository.dart';

@injectable
class BiometricUnlockUseCase {
  final BiometricRepository _biometricRepository;
  final VaultRepository _vaultRepository;

  BiometricUnlockUseCase(this._biometricRepository, this._vaultRepository);

  Future<Either<Failure, bool>> invoke() async {
    final authResult = await _biometricRepository.authenticate();
    return await authResult.fold((failure) => Left(failure), (
      authenticated,
    ) async {
      if (authenticated) {
        final keyResult = await _biometricRepository.getSecretKey();
        return await keyResult.fold((failure) => Left(failure), (
          keyOption,
        ) async {
          return await keyOption.fold(
            () => const Left(UnexpectedFailure('No secret key found')),
            (keyBytes) async {
              final unlockResult = await _vaultRepository.unlockWithKey(
                keyBytes,
              );
              return unlockResult.fold(
                (failure) => Left(failure),
                (_) => const Right(true),
              );
            },
          );
        });
      }
      return const Right(false);
    });
  }
}
