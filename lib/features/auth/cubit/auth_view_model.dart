import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
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
import '../auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final SignInWithGoogleUseCases _signInWithGoogleUseCases;
  final RegisterWithEmailAndPasswordUseCase
  _registerWithEmailAndPasswordUseCases;
  final LoginWithEmailAndPasswordUseCase _loginWithEmailAndPasswordUseCase;
  final LogoutUseCase _logoutUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final UpdateAccountDetailsUseCase _updateAccountDetailsUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final CheckAppStartupUseCase _checkAppStartupUseCase;

  AuthCubit(
    this._signInWithGoogleUseCases,
    this._registerWithEmailAndPasswordUseCases,
    this._loginWithEmailAndPasswordUseCase,
    this._logoutUseCase,
    this._deleteAccountUseCase,
    this._updateAccountDetailsUseCase,
    this._resetPasswordUseCase,
    this._checkAppStartupUseCase,
  ) : super(AuthInitial());

  MyUser? currentUser;
  int _selectedAvatarIndex = 0;

  set changeSelectedIndex(int newIndex) {
    _selectedAvatarIndex = newIndex;
  }

  int get selectedAvatarIndex {
    return _selectedAvatarIndex;
  }

  void logout(BuildContext context) async {
    emit(AuthLogoutLoading());
    if (!context.mounted) return;
    var result = await _logoutUseCase.invoke();
    result.fold((failure) => emit(AuthLogoutError(failure.message.tr())), (_) {
      emit(AuthUnauthenticated());
    });
  }

  Future<void> deleteAccount({
    required BuildContext context,
    required String password,
  }) async {
    emit(AccountDeleteLoading());

    var result = await _deleteAccountUseCase.deleteAccount(
      password: password,
      provider: currentUser?.provider ?? '',
    );
    result.fold((failure) => emit(AccountDeleteError(failure.message.tr())), (
      unit,
    ) {
      emit(AccountDeleteSuccess());
      logout(context);
    });
  }

  Future<void> updateAccountDetails({required MyUser user}) async {
    emit(AccountDetailsUpdateLoading());
    var result = await _updateAccountDetailsUseCase.updateAccountDetails(
      user: user,
    );
    result.fold((failure) => emit(AccountDetailsUpdateError(failure.message)), (
      unit,
    ) {
      currentUser = user;
      emit(AccountDetailsUpdateSuccess());
    });
  }

  ///   auth with google
  Future<void> continueWithGoogle() async {
    try {
      emit(AuthContinueWithGoogleLoading());
      final result = await _signInWithGoogleUseCases.invoke();

      result.fold((failure) => emit(AuthLoginError(failure.message.tr())), (
        user,
      ) {
        currentUser = user;
        emit(AuthAuthenticated(user));
      });
    } catch (e) {
      emit(AuthContinueWithGoogleError('Unexpected Error'));
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthLoginLoading());
      final result = await _loginWithEmailAndPasswordUseCase.invoke(
        email: email,
        password: password,
      );
      result.fold((failure) => emit(AuthLoginError(failure.message.tr())), (
        user,
      ) {
        currentUser = user;
        emit(AuthAuthenticated(user));
      });
    } catch (e) {
      emit(AuthLoginError('Unexpected Error'));
    }
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {
    try {
      emit(AuthRegisterLoading());
      final result = await _registerWithEmailAndPasswordUseCases.invoke(
        name: name,
        phone: phone,
        avatarIndex: avatarIndex,
        password: password,
        email: email,
      );

      result.fold((failure) => emit(AuthRegisterError(failure.message.tr())), (
        user,
      ) {
        currentUser = user;
        emit(AuthAuthenticated(user));
      });
    } catch (e) {
      emit(AuthRegisterError('Unexpected Error'));
    }
  }

  Future<void> resetPassword({required String email}) async {
    emit(ResetPasswordLoading());

    final result = await _resetPasswordUseCase.invoke(email: email);

    result.fold(
      (failure) {
        emit(ResetPasswordError(failure.message.tr()));
      },
      (_) {
        emit(ResetPasswordSuccess());
      },
    );
  }

  String getInitialRoute() {
    var result = _checkAppStartupUseCase.checkAppStartup();
    switch (result.status) {
      case StartupStatus.onboarding:
        return AppRoutes.onboardingRouteName;
      case StartupStatus.unauthenticated:
        return AppRoutes.loginRouteName;
      case StartupStatus.authenticated:
        currentUser = result.user;
        return AppRoutes.homeRouteName;
    }
  }
}
