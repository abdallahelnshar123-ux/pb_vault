import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/features/home_screen/cubit/home_view_model.dart';
import 'package:pb_vault/features/master_password_screen/cubit/master_password_view_model.dart';

import '../../../core/utils/app_routes.dart';
import '../../../domain/entities/response/user/my_user.dart';
import '../../../domain/entities/startup_result/startup_result.dart';
import '../../../domain/use_cases/check_app_startup_use_case.dart';
import '../../../domain/use_cases/delete_account_use_case.dart';
import '../../../domain/use_cases/login_with_email_and_password_use_case.dart';
import '../../../domain/use_cases/logout_use_case.dart';
import '../../../domain/use_cases/register_with_email_and_password_use_case.dart';
import '../../../domain/use_cases/reset_password_use_case.dart';
import '../../../domain/use_cases/sign_in_with_google_use_cases.dart';
import '../../../domain/use_cases/update_account_details_use_case.dart';
import 'user_state.dart';

@lazySingleton
class UserCubit extends Cubit<UserState> {
  final ContinueWithGoogleUseCases _signInWithGoogleUseCases;
  final RegisterWithEmailAndPasswordUseCase
  _registerWithEmailAndPasswordUseCases;
  final LoginWithEmailAndPasswordUseCase _loginWithEmailAndPasswordUseCase;
  final LogoutUseCase _logoutUseCase;
  final DeleteUserUseCase _deleteAccountUseCase;
  final UpdateUserDetailsUseCase _updateUserDetailsUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final CheckAppStartupUseCase _checkAppStartupUseCase;
  final HomeCubit _homeCubit;
  final MasterPasswordCubit _masterPasswordCubit;

  UserCubit(
    this._signInWithGoogleUseCases,
    this._registerWithEmailAndPasswordUseCases,
    this._loginWithEmailAndPasswordUseCase,
    this._logoutUseCase,
    this._deleteAccountUseCase,
    this._updateUserDetailsUseCase,
    this._resetPasswordUseCase,
    this._checkAppStartupUseCase,
    this._homeCubit,
    this._masterPasswordCubit,
  ) : super(UserInitial());

  MyUser? currentUser;

  bool isAccountJustCreated = false;

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    emit(LoginWithEmailPasswordLoadingState());
    final result = await _loginWithEmailAndPasswordUseCase.invoke(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(LoginWithEmailPasswordErrorState(failure.message.tr())),
      (user) {
        currentUser = user;
        emit(UserAuthenticatedState(user));
      },
    );
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required int avatarIndex,
  }) async {
    emit(RegisterWithEmailPasswordLoadingState());
    final result = await _registerWithEmailAndPasswordUseCases.invoke(
      name: name,
      avatarIndex: avatarIndex,
      password: password,
      email: email,
    );

    result.fold(
      (failure) =>
          emit(RegisterWithEmailPasswordErrorState(failure.message.tr())),
      (user) {
        currentUser = user;
        isAccountJustCreated = true;
        emit(UserAuthenticatedState(user));
      },
    );
  }

  Future<void> continueWithGoogle() async {
    emit(ContinueWithGoogleLoadingState());
    final result = await _signInWithGoogleUseCases.invoke();

    result.fold(
      (failure) {
        emit(ContinueWithGoogleErrorState(failure.message.tr()));
      },
      (user) {
        currentUser = user;
        emit(UserAuthenticatedState(user));
      },
    );
  }

  Future<void> logout() async {
    emit(LogoutLoadingState());

    var result = await _logoutUseCase.invoke();
    result.fold((failure) => emit(LogoutErrorState(failure.message.tr())), (
      _,
    ) async {
      _masterPasswordCubit.lockVault();
      await _homeCubit.clearHomeAccounts();
      emit(UserUnauthenticatedState());
      currentUser = null;
      isAccountJustCreated = false;
    });
  }

  Future<void> deleteUser({required String password}) async {
    emit(UserDeleteLoadingState());

    var result = await _deleteAccountUseCase.invoke(
      password: password,
      provider: currentUser?.provider ?? '',
    );
    result.fold((failure) => emit(UserDeleteErrorState(failure.message.tr())), (
      unit,
    ) {
      emit(UserDeleteSuccessState());
      logout();
    });
  }

  Future<void> updateUserDetails({required MyUser user}) async {
    emit(UserDetailsUpdateLoadingState());
    var result = await _updateUserDetailsUseCase.updateAccountDetails(
      user: user,
    );
    result.fold(
      (failure) => emit(UserDetailsUpdateErrorState(failure.message)),
      (unit) {
        currentUser = user;
        emit(UserDetailsUpdateSuccessState());
      },
    );
  }

  Future<void> resetPassword({required String email}) async {
    emit(ResetUSerPasswordLoadingState());

    final result = await _resetPasswordUseCase.invoke(email: email);

    result.fold(
      (failure) {
        emit(ResetUSerPasswordErrorState(failure.message.tr()));
      },
      (_) {
        emit(ResetUserPasswordSuccessState());
      },
    );
  }

  String getInitialRoute() {
    var result = _checkAppStartupUseCase.checkAppStartup();
    switch (result.status) {
      case StartupStatus.onboarding:
        return AppRoutes.onboardingRouteName;
      case StartupStatus.unauthenticated:
        return AppRoutes.authScreen;
      case StartupStatus.authenticated:
        currentUser = result.user;
        return AppRoutes.masterPasswordScreen;
    }
  }
}
