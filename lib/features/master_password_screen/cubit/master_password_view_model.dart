import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/failure/failure.dart';
import 'package:pb_vault/domain/use_cases/biometric/biometric_unlock_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/enable_biometric_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/is_biometric_enabled_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/is_biometric_supported_use_case.dart';
import 'package:pb_vault/domain/use_cases/biometric/set_biometric_rejected_use_case.dart';
import 'package:pb_vault/domain/use_cases/vault/create_vault_verifier_use_case.dart';
import 'package:pb_vault/domain/use_cases/vault/unlock_vault_use_case.dart';

import '../../../domain/entities/response/user/my_user.dart';
import '../../../domain/use_cases/biometric/is_biometric_rejected_use_case.dart';
import '../../../domain/use_cases/set_master_password_use_case.dart';
import 'master_password_state.dart';

@lazySingleton
class MasterPasswordCubit extends Cubit<MasterPasswordState> {
  final SetMasterPasswordUseCase _setMasterPasswordUseCase;
  final CreateVaultVerifierUseCase _createVaultVerifierUseCase;
  final UnlockVaultUseCase _unlockVaultUseCase;
  final IsBiometricSupportedUseCase _isBiometricSupportedUseCase;
  final EnableBiometricUseCase _enableBiometricUseCase;
  final IsBiometricEnabledUseCase _isBiometricEnabledUseCase;
  final IsBiometricRejectedUseCase _isBiometricRejectedUseCase;
  final BiometricUnlockUseCase _biometricUnlockUseCase;
  final SetBiometricRejectedUseCase _biometricRejectedUseCase;

  MasterPasswordCubit(
    this._setMasterPasswordUseCase,
    this._createVaultVerifierUseCase,
    this._unlockVaultUseCase,
    this._isBiometricSupportedUseCase,
    this._enableBiometricUseCase,
    this._isBiometricEnabledUseCase,
    this._isBiometricRejectedUseCase,
    this._biometricUnlockUseCase,
    this._biometricRejectedUseCase,
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

  Future<void> unlockVault({
    required List<int> salt,
    required String masterPassword,
    required String passwordVerifier,
  }) async {
    emit(UnlockLoadingState());
    final result = await _unlockVaultUseCase.invoke(
      password: masterPassword,
      salt: salt,
      verifier: passwordVerifier,
    );

    await result.fold(
      (failure) async => emit(UnlockErrorState(failure.message)),
      (isUnlocked) async {
        if (isUnlocked) {
          final rejectedResult = _isBiometricRejectedUseCase.invoke();
          final isRejected = rejectedResult.getOrElse(() => false);
          var offerBiometric = false;
          if (!isRejected) {
            final supportedResult = await _isBiometricSupportedUseCase.invoke();
            final isSupported = supportedResult.getOrElse(() => false);

            final enabledResult = _isBiometricEnabledUseCase.invoke();
            final isEnabled = enabledResult.getOrElse(() => false);
            offerBiometric = isSupported && !isEnabled;
          }

          emit(UnlockSuccessState(offerBiometric: offerBiometric));
        } else {
          emit(UnlockErrorState('invalid_master_password'));
        }
      },
    );
  }

  Future<void> biometricUnlock() async {
    final enabledResult = _isBiometricEnabledUseCase.invoke();
    final isEnabled = enabledResult.getOrElse(() => false);

    if (isEnabled) {
      emit(UnlockLoadingState());
      final result = await _biometricUnlockUseCase.invoke();
      result.fold(
        (failure) {
          emit(UnlockErrorState(failure.message));
        },
        (success) {
          if (success) {
            emit(UnlockSuccessState());
          } else {
            // If biometric fails, we stay on the screen to allow manual entry
            // but we might want to clear the loading state.
            emit(MasterPasswordInitial());
          }
        },
      );
    }
  }

  Future<bool> enableBiometric(bool enable) async {
    final result = await _enableBiometricUseCase.invoke(enable);
    return result.fold((failure) {
      if (failure is! CancelledByUserFailure) {
        emit(BiometricErrorState(failure.message));
      }
      return false;
    }, (_) => true);
  }

  void rejectBiometric(bool enable) {
    _biometricRejectedUseCase.invoke(enable);
  }

  void lockVault() {
    emit(MasterPasswordInitial());
  }
}
