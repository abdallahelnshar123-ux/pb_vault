import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/data/data_sources/remote/vault/vault_remote_data_source.dart';
import 'package:pb_vault/data/mapper/custom_field_dto_mapper.dart';
import 'package:pb_vault/data/mapper/login_method_dto_mapper.dart';
import 'package:pb_vault/data/mapper/platform_data_dto_mapper.dart';
import 'package:pb_vault/data/mapper/platform_data_mapper.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_account_dto.dart';

import '../../../domain/entities/response/platform_account/platform_account.dart';
import '../../../domain/failure/failure.dart';
import '../../../domain/repository/account/account_repository.dart';
import '../../data_sources/remote/account/account_remote_data_source.dart';
import '../../exceptions/app_exceptions.dart';
import '../../mapper/exception_mapper.dart';
import '../../model/response/platform_account_dto/encrypted_data_dto.dart';

@Injectable(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _accountRemoteDataSource;
  final VaultRemoteDataSource _vaultRemoteDataSource;

  AccountRepositoryImpl(
    this._accountRemoteDataSource,
    this._vaultRemoteDataSource,
  );

  @override
  Future<Either<Failure, Unit>> addAccount(
    String userId,
    PlatformAccount account,
  ) async {
    try {
      // final passwordFuture =
      // account.password?.isNotEmpty == true
      //     ? _vaultRemoteDataSource.encrypt(account.password!)
      //     : null;
      //
      // final notesFuture =
      // account.notes?.isNotEmpty == true
      //     ? _vaultRemoteDataSource.encrypt(account.notes!)
      //     : null;
      // final recoveryCodesFuture =
      // account.recoveryCodes?.isNotEmpty == true
      //     ? _vaultRemoteDataSource.encrypt(account.recoveryCodes!)
      //     : null;
      // final passKeyFuture =
      // account.passkey?.isNotEmpty == true
      //     ? _vaultRemoteDataSource.encrypt(account.passkey!)
      //     : null;
      //
      // final twoFactorSecretFuture =
      // account.twoFactorSecret?.isNotEmpty == true
      //     ? _vaultRemoteDataSource.encrypt(account.twoFactorSecret!)
      //     : null;

      final results = await Future.wait([
        _encryptIfNotEmpty(account.password),
        _encryptIfNotEmpty(account.notes),
        _encryptIfNotEmpty(account.recoveryCodes),
        _encryptIfNotEmpty(account.passkey),
        _encryptIfNotEmpty(account.twoFactorSecret),
      ]);

      await _accountRemoteDataSource.addAccount(
        account: PlatformAccountDto(
          platform: account.platform.toPlatformDataDto(),
          identifier: account.identifier,
          createdAt: account.createdAt,
          password: results[0],
          notes: results[1],
          recoveryCodes: results[2],
          passkey: results[3],
          twoFactorSecret: results[4],
          customFields: account.customFields
              .map((customField) => customField.toCustomFieldDto())
              .toList(),
          loginMethods: account.loginMethods
              .map((loginMethode) => loginMethode.toLoginMethodDto())
              .toList(),
        ),
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
  Stream<Either<Failure, List<PlatformAccount>>> getAccounts(
    String userId,
  ) async* {
    try {
      await for (final accountDto in _accountRemoteDataSource.getAccountsStream(
        uId: userId,
      )) {
        final accounts = accountDto
            .map(
              (dto) => PlatformAccount(
                platform: dto.platform.toPlatformData(),
                identifier: dto.identifier,
                createdAt: dto.createdAt,
              ),
            )
            .toList();
        yield Right(accounts);
      }
    } on AppException catch (e) {
      yield Left(e.toFailure());
    } catch (e) {
      yield Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAccount(
    String userId,
    PlatformAccount account,
  ) async {
    try {
      // await _accountRemoteDataSource.updateAccount(
      //   uId: userId,
      //   account: account,
      // );
      return const Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount(
    String userId,
    String accountId,
  ) async {
    try {
      await _accountRemoteDataSource.deleteAccount(
        uId: userId,
        accountId: accountId,
      );
      return const Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<EncryptedDataDto?> _encryptIfNotEmpty(String? value) async {
    if (value == null || value.trim().isEmpty) return null;

    return await _vaultRemoteDataSource.encrypt(value);
  }
}
