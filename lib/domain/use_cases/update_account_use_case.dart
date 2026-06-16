import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/response/platform_account/platform_account.dart';
import '../failure/failure.dart';
import '../repository/account/account_repository.dart';

@injectable
class UpdatePlatformAccountUseCase {
  final AccountRepository _repository;

  UpdatePlatformAccountUseCase(this._repository);

  Future<Either<Failure, Unit>> invoke(String userId, PlatformAccount account) {
    return _repository.updateAccount(userId, account);
  }
}
