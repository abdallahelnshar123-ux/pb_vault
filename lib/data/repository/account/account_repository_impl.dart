import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/data/mapper/account_dto_mapper.dart';
import 'package:pb_vault/data/mapper/account_mapper.dart';
import '../../../../core/services/firebase_services/firestore_service.dart';
import '../../../domain/entities/response/platform_account/platform_account.dart';
import '../../../domain/failure/failure.dart';
import '../../../domain/repository/account/account_repository.dart';

@Injectable(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final FirestoreService _firestoreService;

  AccountRepositoryImpl(this._firestoreService);

  @override
  Future<Either<Failure, Unit>> addAccount(String userId, PlatformAccount account) async {
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
  Stream<Either<Failure, List<PlatformAccount>>> getAccounts(String userId) {
    return _firestoreService
        .getAccountsStream(uId: userId)
        .map<Either<Failure, List<PlatformAccount>>>((accountDto) {
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

  @override
  Future<Either<Failure, Unit>> updateAccount(String userId, PlatformAccount account) async {
    try {
      await _firestoreService.updateAccount(uId: userId, account: account.toAccountDto());
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount(String userId, String accountId) async{
    try {
      await _firestoreService.deleteAccount(uId: userId, accountId: accountId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
