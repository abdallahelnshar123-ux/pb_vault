import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/use_cases/vault/encrypt_password_use_case.dart';

import '../../../domain/entities/response/platform_account/platform_account.dart';
import '../../../domain/entities/response/platform_account/platform_data.dart';
import '../../../domain/use_cases/add_account_use_case.dart';
import '../../../domain/use_cases/delete_account_from_vault_use_case.dart';
import '../../../domain/use_cases/update_account_use_case.dart';
import 'platform_account_state.dart';

@lazySingleton
class PlatformAccountCubit extends Cubit<PlatformAccountState> {
  final AddPlatformAccountUseCase _addPlatformAccountUseCase;
  final EncryptPasswordUseCase _encryptPasswordUseCase;
  final UpdatePlatformAccountUseCase _updatePlatformAccountUseCase;
  final DeletePlatformAccountUseCase _deletePlatformAccountUseCase;

  PlatformAccountCubit(
    this._updatePlatformAccountUseCase,
    this._deletePlatformAccountUseCase,
    this._addPlatformAccountUseCase,
    this._encryptPasswordUseCase,
  ) : super(AddPlatformAccountInitialState());

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

  Future<void> addPlatformAccount({
    required String userId,
    required PlatformData platform,
    required String emailOrUsername,
    required String password,
    String? notes,
  }) async {
    emit(AddPlatformAccountLoadingState());

    final encryptResult = await _encryptPasswordUseCase.invoke(password);

    encryptResult.fold(
      (failure) => emit(AddPlatformAccountErrorState(failure.message)),
      (encryptedData) async {
        final account = PlatformAccount(
          platform: platform,
          emailOrUsername: emailOrUsername,
          encryptedPassword: encryptedData.cipherText,
          mac: encryptedData.mac,
          nonce: encryptedData.nonce,
          notes: notes,
          createdAt: DateTime.now(),
        );

        final result = await _addPlatformAccountUseCase.invoke(userId, account);
        result.fold(
          (failure) => emit(AddPlatformAccountErrorState(failure.message)),
          (_) => emit(AddPlatformAccountSuccessState()),
        );
      },
    );
  }

  Future<void> updatePlatformAccount({
    required String userId,
    required PlatformAccount originalAccount,
    required String emailOrUsername,
    required String password,
    String? notes,
  }) async {
    emit(EditPlatformAccountLoadingState());

    final encryptResult = await _encryptPasswordUseCase.invoke(password);
    encryptResult.fold(
      (failure) => emit(EditPlatformAccountErrorState(failure.message)),
      (encryptedData) async {
        final updatedAccount = PlatformAccount(
          id: originalAccount.id,
          platform: originalAccount.platform,
          emailOrUsername: emailOrUsername,
          encryptedPassword: encryptedData.cipherText,
          notes: notes,
          createdAt: originalAccount.createdAt,
          mac: encryptedData.mac,
          nonce: encryptedData.nonce,
        );

        final result = await _updatePlatformAccountUseCase.invoke(
          userId,
          updatedAccount,
        );
        result.fold(
          (failure) => emit(EditPlatformAccountErrorState(failure.message)),
          (_) => emit(EditPlatformAccountSuccessState()),
        );
      },
    );
  }

  Future<void> deletePlatformAccount({
    required String userId,
    required String accountId,
  }) async {
    emit(DeletePlatformAccountLoadingState());
    final result = await _deletePlatformAccountUseCase.invoke(
      userId,
      accountId,
    );
    result.fold(
      (failure) => emit(DeletePlatformAccountErrorState(failure.message)),
      (_) => emit(DeletePlatformAccountSuccessState()),
    );
  }

  List<PlatformAccount> searchPlatformAccounts({
    required List<PlatformAccount> accountsList,
    required String searchTerm,
  }) {
    return accountsList
        .where(
          (account) =>
              account.emailOrUsername.toLowerCase().trim().contains(
                searchTerm.toLowerCase().trim(),
              ) ||
              account.platform.name.toLowerCase().trim().contains(
                searchTerm.toLowerCase().trim(),
              ),
        )
        .toList();
  }
}
