import 'package:dartz/dartz.dart';
import '../../entities/response/platform_account/platform_account.dart';
import '../../failure/failure.dart';

abstract class AccountRepository {
  Future<Either<Failure, Unit>> addAccount(String userId, PlatformAccount account);
  Stream<Either<Failure, List<PlatformAccount>>> getAccounts(String userId);
  Future<Either<Failure, Unit>> deleteAccount(String userId, String accountId);
  Future<Either<Failure, Unit>> updateAccount(String userId, PlatformAccount account);
}
