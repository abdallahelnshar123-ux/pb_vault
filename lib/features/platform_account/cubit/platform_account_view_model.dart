import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/domain/use_cases/get_account_by_id_use_case.dart';

import '../../../domain/entities/response/platform_account/login_method.dart';
import '../../../domain/entities/response/platform_account/platform_account.dart';
import '../../../domain/entities/response/platform_account/platform_data.dart';
import '../../../domain/use_cases/add_account_use_case.dart';
import '../../../domain/use_cases/delete_account_from_vault_use_case.dart';
import '../../../domain/use_cases/update_account_use_case.dart';
import 'platform_account_state.dart';

@lazySingleton
class PlatformAccountCubit extends Cubit<PlatformAccountState> {
  final AddPlatformAccountUseCase _addPlatformAccountUseCase;
  final GetAccountByIdUseCase _getAccountBtIdUseCase;
  final UpdatePlatformAccountUseCase _updatePlatformAccountUseCase;
  final DeletePlatformAccountUseCase _deletePlatformAccountUseCase;

  PlatformAccountCubit(
    this._updatePlatformAccountUseCase,
    this._deletePlatformAccountUseCase,
    this._addPlatformAccountUseCase,
    this._getAccountBtIdUseCase,
  ) : super(AddPlatformAccountInitialState());

  Future<void> addPlatformAccount({
    required String userId,
    required PlatformData platform,
    String? identifier,
    String? password,
    String? notes,
    List<LoginMethod>? loginMethods,
    String? recoveryCodes,
    String? passkey,
  }) async {
    emit(AddPlatformAccountLoadingState());

    final account = PlatformAccount(
      platform: platform,
      identifier: identifier ?? '',
      password: password,
      loginMethods: loginMethods ?? const [],
      notes: notes,
      recoveryCodes: recoveryCodes,
      passkey: passkey,
      createdAt: DateTime.now(),
    );

    final result = await _addPlatformAccountUseCase.invoke(userId, account);
    result.fold(
      (failure) => emit(AddPlatformAccountErrorState(failure.message)),
      (_) => emit(AddPlatformAccountSuccessState()),
    );
  }

  Future<void> getAccountById({
    required String userId,
    required String accountId,
  }) async {
    emit(GetPlatformAccountLoadingState());
    var result = await _getAccountBtIdUseCase.invoke(
      userId: userId,
      accountId: accountId,
    );
    result.fold(
      (l) => emit(GetPlatformAccountErrorState(l.message)),
      (platformAccount) =>
          emit(GetPlatformAccountSuccessState(platformAccount)),
    );
  }

  Future<void> updatePlatformAccount({
    required String userId,
    required String accountId,
    required PlatformData platform,
    String? identifier,
    String? password,
    String? notes,
    List<LoginMethod>? loginMethods,
    String? recoveryCodes,
    String? passkey,
  }) async {
    emit(EditPlatformAccountLoadingState());
    final account = PlatformAccount(
      id: accountId,
      platform: platform,
      identifier: identifier ?? '',
      password: password,
      loginMethods: loginMethods ?? const [],
      notes: notes,
      recoveryCodes: recoveryCodes,
      passkey: passkey,
      createdAt: DateTime.now(),
    );

    final result = await _updatePlatformAccountUseCase.invoke(userId, account);
    result.fold(
      (failure) => emit(EditPlatformAccountErrorState(failure.message)),
      (_) => emit(EditPlatformAccountSuccessState()),
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
              account.identifier.toLowerCase().trim().contains(
                searchTerm.toLowerCase().trim(),
              ) ||
              account.platform.name.toLowerCase().trim().contains(
                searchTerm.toLowerCase().trim(),
              ),
        )
        .toList();
  }
}
