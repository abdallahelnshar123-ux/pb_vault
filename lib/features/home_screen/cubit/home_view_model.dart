import 'dart:async';

import 'package:cryptography/cryptography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/entities/response/account/account.dart';

import '../../../core/services/vault_crypto_service/vault_crypto_service.dart';
import '../../../core/utils/snack_bar_utils.dart';
import '../../../domain/use_cases/get_accounts_use_case.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetAccountsUseCase _getAccountsUseCase;
  StreamSubscription? _subscription;
  final VaultCryptoService _vaultCryptoService;

  HomeCubit(this._getAccountsUseCase, this._vaultCryptoService)
    : super(HomeInitial());

  void getAccounts(String userId) {
    emit(HomeLoading());
    _subscription?.cancel();
    _subscription = _getAccountsUseCase.invoke(userId).listen((result) {
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (accounts) => emit(HomeSuccess(accounts)),
      );
    });
  }

  Future<void> copyAccountPassword({
    required Account account,
    required BuildContext context,
  }) async {
    var password = await _vaultCryptoService.decryptPassword(
      mac: Mac(account.mac),
      cipherText: account.encryptedPassword,
      nonce: account.nonce,
    );
    Clipboard.setData(ClipboardData(text: password)).then((_) {
      if (!context.mounted) return;
      SnackBarUtils.showSuccessSnackBar(
        context: context,
        message: 'password_copied_to_clipboard'.tr(),
      );
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
