import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/response/platform_account/platform_account.dart';
import '../../../domain/entities/response/user/my_user.dart';
import '../../../domain/failure/failure.dart';
import '../../../domain/repository/user/user_repository.dart';
import '../../data_sources/local/user/user_local_data_source.dart';
import '../../data_sources/remote/user/user_remote_data_source.dart';
import '../../data_sources/remote/vault/vault_remote_data_source.dart';
import '../../exceptions/app_exceptions.dart';
import '../../mapper/custom_field_dto_mapper.dart';
import '../../mapper/exception_mapper.dart';
import '../../mapper/login_method_dto_mapper.dart';
import '../../mapper/my_user_dto_mapper.dart';
import '../../mapper/my_user_mapper.dart';
import '../../model/response/my_user_dto.dart';
import '../../model/response/platform_account_dto/platform_account_dto.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;
  final VaultRemoteDataSource _vaultRemoteDataSource;

  UserRepositoryImpl(
    this._userRemoteDataSource,
    this._userLocalDataSource,
    this._vaultRemoteDataSource,
  );

  @override
  Future<Either<Failure, Option<MyUser>>> getUserFromRemoteDataBase({
    required String uId,
  }) async {
    try {
      final MyUserDto? userDto = await _userRemoteDataSource.getUser(uId);
      return userDto != null ? Right(Some(userDto.toUser())) : Right(None());
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createDatabaseUser({
    required MyUser user,
  }) async {
    try {
      await _userRemoteDataSource.createUser(user.toMyUserDto());
      return Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDatabaseUser({
    required String uId,
  }) async {
    try {
      await _userRemoteDataSource.deleteUser(uId);
      await _userLocalDataSource.deleteUser();
      return Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateDatabaseUser({
    required MyUser user,
  }) async {
    try {
      await _userRemoteDataSource.updateUser(user.toMyUserDto());
      await _userLocalDataSource.saveUser(user: user.toMyUserDto());
      return Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Either<Failure, Option<MyUser>> getUserFromCache() {
    try {
      final MyUserDto? userDto = _userLocalDataSource.getUserFromCache();
      return userDto != null ? Right(Some(userDto.toUser())) : Right(None());
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setMasterPassword({
    required MyUser user,
  }) async {
    try {
      await _userRemoteDataSource.updateUser(user.toMyUserDto());
      await _userLocalDataSource.saveUser(user: user.toMyUserDto());

      return Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> changeMasterPassword({
    required MyUser user,
    required List<PlatformAccount> accounts,
  }) async {
    try {
      if (accounts.isEmpty) {
        await _userRemoteDataSource.changeMasterPassword(
          uId: user.id,
          userDto: user.toMyUserDto(),
          accounts: [],
        );
        await _userLocalDataSource.saveUser(user: user.toMyUserDto());
        return const Right(unit);
      }

      // Flatten sensitive fields for bulk encryption
      final List<String?> flattenedTexts = [];
      for (final account in accounts) {
        flattenedTexts.addAll([
          account.password,
          account.notes,
          account.recoveryCodes,
          account.passkey,
          account.twoFactorSecret,
        ]);
      }

      final encryptedDtos = await _vaultRemoteDataSource.encryptMultiple(
        flattenedTexts,
      );

      final List<PlatformAccountDto> accountDtos = [];
      for (int i = 0; i < accounts.length; i++) {
        final account = accounts[i];
        final startIndex = i * 5;

        accountDtos.add(
          PlatformAccountDto(
            id: account.id,
            platformId: account.platformId,
            identifier: account.identifier,
            createdAt: account.createdAt,
            password: encryptedDtos[startIndex],
            notes: encryptedDtos[startIndex + 1],
            recoveryCodes: encryptedDtos[startIndex + 2],
            passkey: encryptedDtos[startIndex + 3],
            twoFactorSecret: encryptedDtos[startIndex + 4],
            customFields: account.customFields
                .map((customField) => customField.toCustomFieldDto())
                .toList(),
            loginMethods: account.loginMethods
                .map((loginMethod) => loginMethod.toLoginMethodDto())
                .toList(),
          ),
        );
      }

      await _userRemoteDataSource.changeMasterPassword(
        uId: user.id,
        userDto: user.toMyUserDto(),
        accounts: accountDtos,
      );

      await _userLocalDataSource.saveUser(user: user.toMyUserDto());

      return const Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
