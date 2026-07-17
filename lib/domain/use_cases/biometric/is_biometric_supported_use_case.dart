import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../failure/failure.dart';
import '../../repository/biometric/biometric_repository.dart';

@injectable
class IsBiometricSupportedUseCase {
  final BiometricRepository _biometricRepository;

  IsBiometricSupportedUseCase(this._biometricRepository);

  Future<Either<Failure, bool>> invoke() {
    return _biometricRepository.isBiometricSupported();
  }
}
