import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/entities/vault/encrypted_data.dart';
import 'package:pb_vault/domain/use_cases/vault/decrypt_password_use_case.dart';

import '../../../domain/entities/response/platform_account/platform_account.dart';
import '../../../domain/use_cases/get_accounts_use_case.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetAccountsUseCase _getAccountsUseCase;
  final DecryptPasswordUseCase _decryptPasswordUseCase;
  StreamSubscription? _subscription;

  HomeCubit(this._getAccountsUseCase, this._decryptPasswordUseCase)
    : super(HomeInitial());
  List<PlatformAccount> accountsList = [];

  void getAccounts(String userId) {
    emit(HomeLoading());
    _subscription?.cancel();
    _subscription = _getAccountsUseCase
        .invoke(userId)
        .listen(
          (result) {
            result.fold((failure) => emit(HomeError(failure.message)), (
              accounts,
            ) {
              accountsList = accounts;
              emit(HomeSuccess(accounts));
            });
          },
          onError: (error) {
            if (!error.toString().contains('permission-denied')) {
              emit(HomeError(error.toString()));
            }
          },
        );
  }

  Future<void> copyAccountPassword({required PlatformAccount account}) async {
    final encryptedData = EncryptedData(
      cipherText: account.encryptedPassword,
      mac: account.mac,
      nonce: account.nonce,
    );

    final result = await _decryptPasswordUseCase.invoke(encryptedData);
    result.fold(
      (failure) {},
      (password) async =>
          await Clipboard.setData(ClipboardData(text: password)),
    );
  }

  Future<void> clearHomeAccounts() async {
    emit(HomeInitial());
    await _subscription?.cancel();
    accountsList.clear();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
