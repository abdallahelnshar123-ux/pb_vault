import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../failure/failure.dart';
import '../../repository/biometric/biometric_repository.dart';

@injectable
class SetBiometricRejectedUseCase {
  final BiometricRepository _biometricRepository;

  SetBiometricRejectedUseCase(this._biometricRepository);

  Future<Either<Failure, Unit>> invoke(bool enable) {
    return _biometricRepository.setBiometricRejected(enable);
  }
}
