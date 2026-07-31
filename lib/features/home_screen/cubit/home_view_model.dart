import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/response/platform_account/platform_account.dart';
import '../../../domain/use_cases/get_accounts_use_case.dart';
import 'home_state.dart';

@lazySingleton
class HomeCubit extends Cubit<HomeState> {
  final GetAccountsUseCase _getAccountsUseCase;
  StreamSubscription? _subscription;

  HomeCubit(this._getAccountsUseCase) : super(HomeInitial());
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
    if (account.password == null) return;
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
