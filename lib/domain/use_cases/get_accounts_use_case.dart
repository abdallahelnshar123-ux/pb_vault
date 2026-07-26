import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/response/platform_account/platform_account.dart';
import '../failure/failure.dart';
import '../repository/account/account_repository.dart';

@injectable
class GetAccountsUseCase {
  final AccountRepository _repository;

  GetAccountsUseCase(this._repository);

  Stream<Either<Failure, List<PlatformAccount>>> invoke(String userId) {
    return _repository.getAccounts(userId);
  }
}
