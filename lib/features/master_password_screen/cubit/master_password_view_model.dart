import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/response/user/my_user.dart';
import '../../../domain/use_cases/set_master_password_use_case.dart';
import 'master_password_state.dart';

@injectable
class MasterPasswordCubit extends Cubit<MasterPasswordState> {
  final SetMasterPasswordUseCase _setMasterPasswordUseCase;

  MasterPasswordCubit(this._setMasterPasswordUseCase)
    : super(MasterPasswordInitial());

  Future<void> setMasterPassword({
    required MyUser user,
    required String masterPassword,
  }) async {
    emit(MasterPasswordSetupLoading());
    final MyUser updatedUser = user.copyWith(
      masterPassword: hashPassword(masterPassword),
    );

    final result = await _setMasterPasswordUseCase.invoke(user: updatedUser);
    result.fold(
      (failure) => emit(MasterPasswordSetupError(failure.message.tr())),
      (_) {
        emit(MasterPasswordSetupSuccess(updatedUser));
      },
    );
  }

  void verifyMasterPassword({
    required String input,
    required String? savedPassword,
  }) {
    emit(MasterPasswordVerifyLoading());
    if (savedPassword == hashPassword(input)) {
      emit(MasterPasswordVerifySuccess());
    } else {
      emit(MasterPasswordVerifyError('invalid_master_password'.tr()));
    }
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
