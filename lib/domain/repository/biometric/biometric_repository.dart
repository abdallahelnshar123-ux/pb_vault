import 'package:dartz/dartz.dart';

import '../../failure/failure.dart';

abstract class BiometricRepository {
  Future<Either<Failure, bool>> isBiometricSupported();

  Future<Either<Failure, bool>> authenticate();

  Future<Either<Failure, Unit>> saveSecretKey(List<int> secretKey);

  Future<Either<Failure, Option<List<int>>>> getSecretKey();

  Future<Either<Failure, Unit>> deleteSecretKey();

  Future<Either<Failure, Unit>> setBiometricEnabled(bool enabled);

  Either<Failure, bool> isBiometricEnabled();

  Either<Failure, bool> isBiometricRejected();

  Future<Either<Failure, Unit>> setBiometricRejected(bool enabled);
}
