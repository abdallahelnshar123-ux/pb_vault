import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/response/user/my_user.dart';
import '../failure/failure.dart';
import '../repository/auth/auth_repository.dart';

@injectable
class RegisterWithEmailAndPasswordUseCase {
  final AuthRepository _authRepository;

  RegisterWithEmailAndPasswordUseCase(this._authRepository);

  Future<Either<Failure, MyUser>> invoke({
    required String email,
    required String password,
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {
    final Either<Failure, MyUser> authResult = await _authRepository
        .registerWithEmailAndPassword(
          email: email,
          password: password,
          avatarIndex: avatarIndex,
          phone: phone,
          name: name,
        );
    return authResult;
  }
}
