import 'package:dartz/dartz.dart';

import '../../entities/vault/encrypted_data.dart';
import '../../failure/failure.dart';

abstract class VaultRepository {
  Future<Either<Failure, EncryptedData>> encrypt(String text);

  Future<Either<Failure, String>> decrypt(EncryptedData data);

  Future<Either<Failure, Map<String, dynamic>>> createVerifier(String password);

  Future<Either<Failure, List<int>>> getSecretKeyBytes();

  Future<Either<Failure, bool>> unlock({
    required String password,
    required List<int> salt,
    required String verifier,
  });

  Future<Either<Failure, Unit>> unlockWithKey(List<int> keyBytes);

  void lock();

  bool get isLocked;
}
