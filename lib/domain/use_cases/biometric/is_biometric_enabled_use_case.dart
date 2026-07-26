import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../failure/failure.dart';
import '../../repository/biometric/biometric_repository.dart';

@injectable
class IsBiometricEnabledUseCase {
  final BiometricRepository _biometricRepository;

  IsBiometricEnabledUseCase(this._biometricRepository);

  Either<Failure, bool> invoke() {
    return _biometricRepository.isBiometricEnabled();
  }
}
