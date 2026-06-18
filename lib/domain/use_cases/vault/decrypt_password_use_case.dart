import 'package:injectable/injectable.dart';
import '../../entities/vault/encrypted_data.dart';
import '../../repository/vault/vault_repository.dart';

@injectable
class DecryptPasswordUseCase {
  final VaultRepository _repository;

  DecryptPasswordUseCase(this._repository);

  Future<String> invoke(EncryptedData data) {
    return _repository.decrypt(data);
  }
}
