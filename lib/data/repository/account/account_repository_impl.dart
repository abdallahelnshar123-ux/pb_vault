import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/data/mapper/account_dto_mapper.dart';
import 'package:pb_vault/data/mapper/account_mapper.dart';
import '../../../../core/services/firebase_services/firestore_service.dart';
import '../../../domain/entities/response/account/account.dart';
import '../../../domain/failure/failure.dart';
import '../../../domain/repository/account/account_repository.dart';

@Injectable(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final FirestoreService _firestoreService;

  AccountRepositoryImpl(this._firestoreService);

  @override
  Future<Either<Failure, Unit>> addAccount(String userId, Account account) async {
    try {
      await _firestoreService.addAccount(
        account: account.toAccountDto(),
        uId: userId,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Account>>> getAccounts(String userId) {
    return _firestoreService
        .getAccountsStream(uId: userId)
        .map<Either<Failure, List<Account>>>((accountDto) {
      try {
        final accounts = accountDto.map((dto) => dto.toAccount()).toList();
        return Right(accounts);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }).handleError((error) {
      return Left(ServerFailure(error.toString()));
    });
  }
}
