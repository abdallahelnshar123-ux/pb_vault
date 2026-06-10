import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/core/services/vault_crypto_service/vault_crypto_service.dart';

import '../../../domain/entities/response/user/my_user.dart';
import '../../../domain/use_cases/set_master_password_use_case.dart';
import 'master_password_state.dart';

@injectable
class MasterPasswordCubit extends Cubit<MasterPasswordState> {
  final SetMasterPasswordUseCase _setMasterPasswordUseCase;
  final VaultCryptoService _vaultCryptoService;

  MasterPasswordCubit(this._setMasterPasswordUseCase, this._vaultCryptoService)
    : super(MasterPasswordInitial());

  Future<void> setMasterPassword({
    required MyUser user,
    required String masterPassword,
  }) async {
    emit(MasterPasswordSetupLoading());

    final verifier = await _vaultCryptoService.createVerifier(
      password: masterPassword,
    );

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
    if (await _vaultCryptoService.verifyMasterPassword(
      masterPassword: masterPassword,
      salt: salt,
      passwordVerifier: passwordVerifier,
    )) {
      emit(MasterPasswordVerifySuccess());
    } else {
      emit(MasterPasswordVerifyError('invalid_master_password'.tr()));
    }
  }

  List<int> generateSalt([int length = 94]) {
    final Random random = Random.secure();
    return List<int>.generate(length, (i) => random.nextInt(256));
    // return base64Url.encode(values);
  }
}

/*
    final secretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(masterPassword)),
      nonce: salt,
    );
    final nonce = generateSalt(12);

    final encrypted = await cryptography.aesGcm().encrypt(
      utf8.encode(masterPassword),
      secretKey: secretKey,
      nonce: nonce,
    );

      final decrypted =  await Cryptography.instance.aesGcm().decrypt(
      encrypted,
      secretKey: secretKey,
    );

 */
