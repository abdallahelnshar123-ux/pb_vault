import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/core/services/vault_crypto_service/vault_crypto_service.dart';

import '../../../domain/entities/response/account/account.dart';
import '../../../domain/entities/response/account/platform_data.dart';
import '../../../domain/use_cases/add_account_use_case.dart';
import 'add_account_state.dart';

@injectable
class AddAccountCubit extends Cubit<AddAccountState> {
  final AddAccountUseCase _addAccountUseCase;
  final VaultCryptoService _vaultCryptoService;

  AddAccountCubit(this._addAccountUseCase, this._vaultCryptoService)
    : super(AddAccountInitial());

  // String _encryptPassword(String password) {
  //   final bytes = utf8.encode(password);
  //   final digest = Cryptography.instance.sha256().hash(bytes);
  //   return digest.toString();
  // }

  String generateStrongPassword() {
    const length = 16;
    const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const number = "0123456789";
    const special = "@#%^&*_-+()[]{}";

    String chars = "";
    chars += letterLowerCase;
    chars += letterUpperCase;
    chars += number;
    chars += special;

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }

  Future<void> addAccount({
    required String userId,
    required PlatformData platform,
    required String emailOrUsername,
    required String password,
    String? notes,
  }) async {
    emit(AddAccountLoading());

    final secretBox = await _vaultCryptoService.encryptPassword(
      password: password,
    );
    final account = Account(
      platform: platform,
      emailOrUsername: emailOrUsername,
      encryptedPassword: secretBox.cipherText,
      mac: secretBox.mac.bytes,
      nonce: secretBox.nonce,
      notes: notes,
      createdAt: DateTime.now(),
    );

    final result = await _addAccountUseCase.invoke(userId, account);
    result.fold(
      (failure) => emit(AddAccountError(failure.message)),
      (_) => emit(AddAccountSuccess()),
    );
  }
}
