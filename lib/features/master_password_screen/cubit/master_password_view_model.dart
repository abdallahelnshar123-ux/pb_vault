import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
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

  MasterPasswordCubit(
    this._setMasterPasswordUseCase,
    this._createVaultVerifierUseCase,
    this._unlockVaultUseCase,
  ) : super(MasterPasswordInitial());

  Future<void> setMasterPassword({
    required MyUser user,
    required String masterPassword,
  }) async {
    emit(MasterPasswordSetupLoading());

    final verifier = await _createVaultVerifierUseCase.invoke(masterPassword);

    final MyUser updatedUser = user.copyWith(
      passwordVerifier: verifier['hash'] as String,
      salt: verifier['salt'] as List<int>,
    );

    final result = await _setMasterPasswordUseCase.invoke(user: updatedUser);
    result.fold(
      (failure) => emit(MasterPasswordSetupError(failure.message.tr())),
      (_) {
        emit(MasterPasswordSetupSuccess(updatedUser));
      },
    );
  }

  Future<void> verifyMasterPassword({
    required List<int> salt,
    required String masterPassword,
    required String passwordVerifier,
  }) async {
    emit(MasterPasswordVerifyLoading());
    final isUnlocked = await _unlockVaultUseCase.invoke(
      password: masterPassword,
      salt: salt,
      verifier: passwordVerifier,
    );

    if (isUnlocked) {
      emit(MasterPasswordVerifySuccess());
    } else {
      emit(MasterPasswordVerifyError('invalid_master_password'.tr()));
    }
  }
}
