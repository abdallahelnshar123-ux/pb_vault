import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../failure/failure.dart';
import '../repository/auth/auth_repository.dart';

@injectable
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, Unit>> invoke() async {
    return await repository.logout();
  }
}
