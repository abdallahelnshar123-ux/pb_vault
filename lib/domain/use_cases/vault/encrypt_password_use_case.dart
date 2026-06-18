import 'package:injectable/injectable.dart';
import '../../entities/vault/encrypted_data.dart';
import '../../repository/vault/vault_repository.dart';

@injectable
class EncryptPasswordUseCase {
  final VaultRepository _repository;

  EncryptPasswordUseCase(this._repository);

  Future<EncryptedData> invoke(String password) {
    return _repository.encrypt(password);
  }
}
