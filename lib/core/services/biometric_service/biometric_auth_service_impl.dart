import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pb_vault/data/exceptions/app_exceptions.dart';

import 'biometric_auth_service.dart';

@Injectable(as: BiometricAuthService)
class BiometricAuthServiceImpl implements BiometricAuthService {
  final LocalAuthentication _localAuth;

  BiometricAuthServiceImpl(this._localAuth);

  @override
  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to unlock your vault',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.userCanceled) {
        throw CancelledByUserException();
      } else if (e.code == LocalAuthExceptionCode.noBiometricsEnrolled || e.code == LocalAuthExceptionCode.noBiometricHardware) {
        throw BiometricException(message: 'no_biometric_found');
      }
      else{
        throw BiometricException(message: 'error_while_trying_to_authenticate');
      }
    }
  }

  @override
  Future<bool> canCheckBiometrics() async {
    return await _localAuth.canCheckBiometrics;
  }

  @override
  Future<bool> isDeviceSupported() async {
    return await _localAuth.isDeviceSupported();
  }
}
