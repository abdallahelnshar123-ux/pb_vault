import 'package:dartz/dartz.dart';

import '../../entities/response/user/my_user.dart';
import '../../failure/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, MyUser>> continueWithGoogle();

  Future<Either<Failure, MyUser>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, MyUser>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required int avatarIndex,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, String>> reAuthenticateWithEmailAndPassword(
    String password,
  );

  Future<Either<Failure, String>> reAuthenticateWithGoogle();

  Future<Either<Failure, Unit>> resetPassword({required String email});

  Future<Either<Failure, Unit>> deleteAccount();
}
