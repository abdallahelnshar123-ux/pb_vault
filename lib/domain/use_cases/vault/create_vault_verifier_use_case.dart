import 'package:injectable/injectable.dart';
import '../../repository/vault/vault_repository.dart';

@injectable
class CreateVaultVerifierUseCase {
  final VaultRepository _repository;

  CreateVaultVerifierUseCase(this._repository);

  Future<Map<String, dynamic>> invoke(String password) {
    return _repository.createVerifier(password);
  }
}
