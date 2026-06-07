import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/response/user/my_user.dart';
import '../failure/failure.dart';
import '../repository/auth/auth_repository.dart';

@injectable
class LoginWithEmailAndPasswordUseCase {
  final AuthRepository _authRepository;

  LoginWithEmailAndPasswordUseCase(this._authRepository);

  Future<Either<Failure, MyUser>> invoke({
    required String email,
    required String password,
  }) async {
    final Either<Failure, MyUser> authResult = await _authRepository
        .loginWithEmailAndPassword(email: email, password: password);
    return authResult;
  }
}
