import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/response/user/my_user.dart';
import '../../../domain/failure/failure.dart';
import '../../../domain/repository/user/user_repository.dart';
import '../../data_sources/local/user/user_local_data_source.dart';
import '../../data_sources/remote/user/user_remote_data_source.dart';
import '../../exceptions/app_exceptions.dart';
import '../../mapper/exception_mapper.dart';
import '../../mapper/my_user_dto_mapper.dart';
import '../../mapper/my_user_mapper.dart';
import '../../model/response/my_user_dto.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;

  UserRepositoryImpl(this._userRemoteDataSource, this._userLocalDataSource);

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
  Future<Either<Failure, Unit>> createDatabaseUser({required MyUser user}) async {
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
  Future<Either<Failure, Unit>> deleteDatabaseUser({required String uId}) async {
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
  Future<Either<Failure, Unit>> updateDatabaseUser({required MyUser user}) async {
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
}
