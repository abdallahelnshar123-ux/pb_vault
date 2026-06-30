import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/data/mapper/account_dto_mapper.dart';
import 'package:pb_vault/data/mapper/account_mapper.dart';
import '../../../domain/entities/response/platform_account/platform_account.dart';
import '../../../domain/failure/failure.dart';
import '../../../domain/repository/account/account_repository.dart';
import '../../data_sources/remote/account/account_remote_data_source.dart';
import '../../exceptions/app_exceptions.dart';
import '../../mapper/exception_mapper.dart';

@Injectable(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _accountRemoteDataSource;

  AccountRepositoryImpl(this._accountRemoteDataSource);

  @override
  Future<Either<Failure, Unit>> addAccount(String userId, PlatformAccount account) async {
    try {
      await _accountRemoteDataSource.addAccount(
        account: account.toAccountDto(),
        uId: userId,
      );
      return const Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<PlatformAccount>>> getAccounts(String userId) async* {
    try {
      await for (final accountDto in _accountRemoteDataSource.getAccountsStream(uId: userId)) {
        final accounts = accountDto.map((dto) => dto.toAccount()).toList();
        yield Right(accounts);
      }
    } on AppException catch (e) {
      yield Left(e.toFailure());
    } catch (e) {
      yield Left(UnexpectedFailure(e.toString()));

    }
  }

  @override
  Future<Either<Failure, Unit>> updateAccount(String userId, PlatformAccount account) async {
    try {
      await _accountRemoteDataSource.updateAccount(uId: userId, account: account.toAccountDto());
      return const Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount(String userId, String accountId) async {
    try {
      await _accountRemoteDataSource.deleteAccount(uId: userId, accountId: accountId);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
