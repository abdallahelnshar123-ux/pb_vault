import 'package:dartz/dartz.dart';
import '../../entities/response/account/account.dart';
import '../../failure/failure.dart';

abstract class AccountRepository {
  Future<Either<Failure, Unit>> addAccount(String userId, Account account);
  Stream<Either<Failure, List<Account>>> getAccounts(String userId);
}
