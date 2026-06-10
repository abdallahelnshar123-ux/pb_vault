import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/response/account/account.dart';
import '../failure/failure.dart';
import '../repository/account/account_repository.dart';

@injectable
class AddAccountUseCase {
  final AccountRepository _repository;

  AddAccountUseCase(this._repository);

  Future<Either<Failure, Unit>> invoke(String userId, Account account) {
    return _repository.addAccount(userId, account);
  }
}
