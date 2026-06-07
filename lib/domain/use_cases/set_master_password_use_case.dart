import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/repository/user/user_repository.dart';

import '../entities/response/user/my_user.dart';
import '../failure/failure.dart';

@injectable
class SetMasterPasswordUseCase {
  final UserRepository _userRepository;

  SetMasterPasswordUseCase(this._userRepository);

  Future<Either<Failure, Unit>> invoke({required MyUser user}) {
    return _userRepository.setMasterPassword(user: user);
  }
}
