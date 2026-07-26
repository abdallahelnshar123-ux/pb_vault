import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/failure/failure.dart';

import '../../entities/vault/encrypted_data.dart';
import '../../repository/vault/vault_repository.dart';

@injectable
class DecryptPasswordUseCase {
  final VaultRepository _repository;

  DecryptPasswordUseCase(this._repository);

  Future<Either<Failure, String>> invoke(EncryptedData data) {
    return _repository.decrypt(data);
  }
}
