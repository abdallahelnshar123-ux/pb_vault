import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/response/platform_account/platform_account.dart';
import '../failure/failure.dart';
import '../repository/account/account_repository.dart';

@injectable
class AddPlatformAccountUseCase {
  final AccountRepository _repository;

  AddPlatformAccountUseCase(this._repository);

  Future<Either<Failure, Unit>> invoke(String userId, PlatformAccount account) {
    return _repository.addAccount(userId, account);
  }
}
