abstract class BiometricAuthService {
  Future<bool> canCheckBiometrics();

  Future<bool> isDeviceSupported();

  Future<bool> authenticate();
}
