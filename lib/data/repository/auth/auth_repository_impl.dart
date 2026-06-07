import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/response/auth/auth_providers.dart';
import '../../../domain/entities/response/user/my_user.dart';
import '../../../domain/failure/failure.dart';
import '../../../domain/repository/auth/auth_repository.dart';
import '../../data_sources/local/user/user_local_data_source.dart';
import '../../data_sources/remote/auth/auth_remote_data_source.dart';
import '../../data_sources/remote/user/user_remote_data_source.dart';
import '../../exceptions/app_exceptions.dart';
import '../../mapper/exception_mapper.dart';
import '../../mapper/my_user_dto_mapper.dart';
import '../../mapper/my_user_mapper.dart';
import '../../model/response/auth_user_dto.dart';
import '../../model/response/my_user_dto.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final UserRemoteDataSource _userRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;

  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._userRemoteDataSource,
    this._userLocalDataSource,
  );

  @override
  Future<Either<Failure, MyUser>> continueWithGoogle() async {
    try {
      final AuthUserDto authUserDto = await _authRemoteDataSource
          .continueWithGoogle();
      final MyUserDto? databaseUser = await _userRemoteDataSource.getUser(
        authUserDto.id,
      );

      if (databaseUser == null) {
        final newUser = MyUserDto(
          provider: AuthProviders.google,
          id: authUserDto.id,
          name: authUserDto.name,
          email: authUserDto.email,
        );
        await _userRemoteDataSource.createUser(newUser);
        await _userLocalDataSource.saveUser(user: newUser);

        return Right(newUser.toUser());
      }
      await _userLocalDataSource.saveUser(user: databaseUser);

      return Right(databaseUser.toUser());
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MyUser>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required int avatarIndex,
  }) async {
    try {
      final authUserDto = await _authRemoteDataSource
          .registerWithEmailAndPassword(email: email, password: password);

      final newUser = MyUser(
        provider: AuthProviders.emailPassword,
        id: authUserDto.id,
        name: name,
        email: authUserDto.email,
      );
      await _userRemoteDataSource.createUser(newUser.toMyUserDto());
      await _userLocalDataSource.saveUser(user: newUser.toMyUserDto());

      return Right(newUser);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MyUser>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authUserDto = await _authRemoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      final MyUserDto? databaseUser = await _userRemoteDataSource.getUser(
        authUserDto.id,
      );
      if (databaseUser == null) {
        return Left(UnauthorizedFailure('some thing went wrong'));
      }

      await _userLocalDataSource.saveUser(user: databaseUser);
      return Right(databaseUser.toUser());
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _authRemoteDataSource.logout();
      await _userLocalDataSource.deleteUser();

      return Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      await _authRemoteDataSource.deleteAccount();

      return Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> reAuthenticateWithEmailAndPassword(
    String password,
  ) async {
    try {
      var authUserDto = await _authRemoteDataSource
          .reAuthenticateWithEmailAndPassword(password);

      return Right(authUserDto.id);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> reAuthenticateWithGoogle() async {
    try {
      final authUserDto = await _authRemoteDataSource
          .reAuthenticateWithGoogle();

      return Right(authUserDto.id);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({required String email}) async {
    try {
      await _authRemoteDataSource.resetPassword(email: email);

      return Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
