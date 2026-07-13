import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/use_cases/biometric/enable_biometric_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/is_biometric_supported_use_case.dart';
import 'package:pb_vault/domain/use_cases/vault/create_vault_verifier_use_case.dart';
import 'package:pb_vault/domain/use_cases/vault/unlock_vault_use_case.dart';

import '../../../domain/entities/response/user/my_user.dart';
import '../../../domain/use_cases/set_master_password_use_case.dart';
import 'master_password_state.dart';

@injectable
class MasterPasswordCubit extends Cubit<MasterPasswordState> {
  final SetMasterPasswordUseCase _setMasterPasswordUseCase;
  final CreateVaultVerifierUseCase _createVaultVerifierUseCase;
  final UnlockVaultUseCase _unlockVaultUseCase;
  final IsBiometricSupportedUseCase _isBiometricSupportedUseCase;
  final EnableBiometricUseCase _enableBiometricUseCase;

  MasterPasswordCubit(
    this._setMasterPasswordUseCase,
    this._createVaultVerifierUseCase,
    this._unlockVaultUseCase,
    this._isBiometricSupportedUseCase,
    this._enableBiometricUseCase,
  ) : super(MasterPasswordInitial());

  Future<void> setMasterPassword({
    required MyUser user,
    required String masterPassword,
  }) async {
    emit(MasterPasswordSetupLoading());

    final verifierResult = await _createVaultVerifierUseCase.invoke(
      masterPassword,
    );

    await verifierResult.fold(
      (failure) async => emit(MasterPasswordSetupError(failure.message.tr())),
      (verifier) async {
        final MyUser updatedUser = user.copyWith(
          passwordVerifier: verifier['hash'] as String,
          salt: verifier['salt'] as List<int>,
        );

        final result = await _setMasterPasswordUseCase.invoke(
          user: updatedUser,
        );
        await result.fold(
          (failure) async =>
              emit(MasterPasswordSetupError(failure.message.tr())),
          (_) async {
            final biometricResult = await _isBiometricSupportedUseCase.invoke();
            final bool isSupported = biometricResult.getOrElse(() => false);

            emit(
              MasterPasswordSetupSuccess(
                updatedUser,
                offerBiometric: isSupported,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> verifyMasterPassword({
    required List<int> salt,
    required String masterPassword,
    required String passwordVerifier,
  }) async {
    emit(MasterPasswordVerifyLoading());
    final result = await _unlockVaultUseCase.invoke(
      password: masterPassword,
      salt: salt,
      verifier: passwordVerifier,
    );

    result.fold(
      (failure) => emit(MasterPasswordVerifyError(failure.message.tr())),
      (isUnlocked) {
        if (isUnlocked) {
          emit(MasterPasswordVerifySuccess());
        } else {
          emit(MasterPasswordVerifyError('invalid_master_password'.tr()));
        }
      },
    );
  }

  Future<void> enableBiometric(bool enable) async {
    final result = await _enableBiometricUseCase.invoke(enable);
    result.fold(
      (failure) => emit(BiometricErrorState(failure.message)),
      (_) {},
    );
  }
}
