import 'package:dartz/dartz.dart';

import '../../entities/response/platform_account/platform_account.dart';
import '../../entities/response/user/my_user.dart';
import '../../failure/failure.dart';

abstract class UserRepository {
  Future<Either<Failure, Option<MyUser>>> getUserFromRemoteDataBase({
    required String uId,
  });

  Either<Failure, Option<MyUser>> getUserFromCache();

  Future<Either<Failure, Unit>> createDatabaseUser({required MyUser user});

  Future<Either<Failure, Unit>> updateDatabaseUser({required MyUser user});

  Future<Either<Failure, Unit>> deleteDatabaseUser({required String uId});

  Future<Either<Failure, Unit>> setMasterPassword({required MyUser user});

  Future<Either<Failure, Unit>> changeMasterPassword({
    required MyUser user,
    required List<PlatformAccount> accounts,
  });
}
