import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/entities/settings/settings.dart';
import 'package:pb_vault/domain/repository/biometric/biometric_repository.dart';

@injectable
class GetAppSettingsUseCase {
  final BiometricRepository _biometricRepository;

  GetAppSettingsUseCase(this._biometricRepository);

  Future<AppSettings> invoke() async {
    final bool isBiometricEnabled = _biometricRepository
        .isBiometricEnabled()
        .getOrElse(() => false);
    var isBiometricSupported = await _biometricRepository
        .isBiometricSupported();

    return AppSettings(
      isBiometricEnabled: isBiometricEnabled,
      isBiometricSupported: isBiometricSupported.getOrElse(() => false),
    );
  }
}
