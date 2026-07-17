import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../failure/failure.dart';
import '../../repository/vault/vault_repository.dart';

@injectable
class UnlockVaultUseCase {
  final VaultRepository _repository;

  UnlockVaultUseCase(this._repository);

  Future<Either<Failure, bool>> invoke({
    required String password,
    required List<int> salt,
    required String verifier,
  }) {
    return _repository.unlock(
      password: password,
      salt: salt,
      verifier: verifier,
    );
  }
}
