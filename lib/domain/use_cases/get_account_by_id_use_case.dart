import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/response/platform_account/platform_account.dart';
import '../failure/failure.dart';
import '../repository/account/account_repository.dart';

@injectable
class GetAccountByIdUseCase {
  final AccountRepository _repository;

  GetAccountByIdUseCase(this._repository);

  Future<Either<Failure, PlatformAccount>> invoke({
    required String userId,
    required String accountId,
  }) async {
    return await _repository.getAccountById(userId, accountId);
  }
}
