import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/response/user/my_user.dart';
import '../failure/failure.dart';
import '../repository/auth/auth_repository.dart';

@injectable
class ContinueWithGoogleUseCases {
  final AuthRepository _authRepository;

  ContinueWithGoogleUseCases(this._authRepository);

  Future<Either<Failure, MyUser>> invoke() {
    return _authRepository.continueWithGoogle();
  }
}
