import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/response/auth/auth_providers.dart';
import '../failure/failure.dart';
import '../repository/auth/auth_repository.dart';
import '../repository/user/user_repository.dart';

@injectable
class DeleteAccountUseCase {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  DeleteAccountUseCase(this._userRepository, this._authRepository);

  Future<Either<Failure, Unit>> deleteAccount({
    required String password,
    required String provider,
  }) async {
    Either<Failure, String> reAuthResult;

    if (provider == AuthProviders.emailPassword) {
      reAuthResult = await _authRepository.reAuthenticateWithEmailAndPassword(
        password,
      );
    } else {
      reAuthResult = await _authRepository.reAuthenticateWithGoogle();
    }

    return reAuthResult.fold((failure) => Left(failure), (uId) async {
      var deleteUserResult = await _userRepository.deleteUser(uId: uId);
      return deleteUserResult.fold((failure) => Left(failure), (unit) async {
        var deleteAuthResult = await _authRepository.deleteAccount();
        return deleteAuthResult.fold(
          (failure) => Left(failure),
          (unit) => Right(unit),
        );
      });
    });
  }
}
