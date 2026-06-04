import 'package:dartz/dartz.dart';

import '../../entities/response/user/my_user.dart';
import '../../failure/failure.dart';

abstract class UserRepository {
  Future<Either<Failure, Option<MyUser>>> getUserFromRemoteDataSource({
    required String uId,
  });

  Either<Failure, Option<MyUser>> getUserFromCache();

  Future<Either<Failure, Unit>> createUser({required MyUser user});

  Future<Either<Failure, Unit>> updateUser({required MyUser user});

  Future<Either<Failure, Unit>> deleteUser({required String uId});
}
