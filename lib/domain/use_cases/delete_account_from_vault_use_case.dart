import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../failure/failure.dart';
import '../repository/account/account_repository.dart';

@injectable
class DeletePlatformAccountUseCase {
  final AccountRepository _repository;

  DeletePlatformAccountUseCase(this._repository);

  Future<Either<Failure, Unit>> invoke(String userId, String accountId) {
    return _repository.deleteAccount(userId, accountId);
  }
}
