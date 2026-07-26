import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../failure/failure.dart';
import '../../repository/vault/vault_repository.dart';

@injectable
class CreateVaultVerifierUseCase {
  final VaultRepository _repository;

  CreateVaultVerifierUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> invoke(String password) {
    return _repository.createVerifier(password);
  }
}
