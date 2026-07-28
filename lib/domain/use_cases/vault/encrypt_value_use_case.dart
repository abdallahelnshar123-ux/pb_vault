import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/failure/failure.dart';

import '../../entities/response/platform_account/encrypted_data.dart';
import '../../repository/vault/vault_repository.dart';

@injectable
class EncryptValueUseCase {
  final VaultRepository _repository;

  EncryptValueUseCase(this._repository);

  Future<Either<Failure, EncryptedData>> invoke(String value) {
    return _repository.encrypt(value);
  }
}
