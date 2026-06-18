import 'package:injectable/injectable.dart';
import '../../repository/vault/vault_repository.dart';

@injectable
class UnlockVaultUseCase {
  final VaultRepository _repository;

  UnlockVaultUseCase(this._repository);

  Future<bool> invoke({
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
