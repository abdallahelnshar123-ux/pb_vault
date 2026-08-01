import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/response/user/my_user.dart';
import '../failure/failure.dart';
import '../repository/user/user_repository.dart';

@injectable
class UpdateUserDetailsUseCase {
  final UserRepository _userRepository;

  UpdateUserDetailsUseCase(this._userRepository);

  Future<Either<Failure, Unit>> updateAccountDetails({
    required MyUser user,
  }) async {
    return await _userRepository.updateDatabaseUser(user: user);
  }
}
