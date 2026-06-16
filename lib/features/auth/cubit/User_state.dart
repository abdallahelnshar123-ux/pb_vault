import '../../../domain/entities/response/user/my_user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

/// ===================  Auth States  =======================
class LoginWithEmailPasswordLoadingState extends UserState {}

class LoginWithEmailPasswordErrorState extends UserState {
  final String message;

  LoginWithEmailPasswordErrorState(this.message);
}

class RegisterWithEmailPasswordLoadingState extends UserState {}

class RegisterWithEmailPasswordErrorState extends UserState {
  final String message;

  RegisterWithEmailPasswordErrorState(this.message);
}

class ContinueWithGoogleLoadingState extends UserState {}

class ContinueWithGoogleErrorState extends UserState {
  final String message;

  ContinueWithGoogleErrorState(this.message);
}

class LogoutLoadingState extends UserState {}

class LogoutErrorState extends UserState {
  final String message;

  LogoutErrorState(this.message);
}

class UserAuthenticatedState extends UserState {
  final MyUser? currentUser;

  UserAuthenticatedState(this.currentUser);
}

class UserUnauthenticatedState extends UserState {}

/// ======================   update states   ======================
class UserDetailsUpdateLoadingState extends UserState {}

class UserDetailsUpdateSuccessState extends UserState {}

class USerDetailsUpdateErrorState extends UserState {
  final String message;

  USerDetailsUpdateErrorState(this.message);
}

/// ====================   delete states   =========================

class UserDeleteLoadingState extends UserState {}

class UserDeleteSuccessState extends UserState {}

class UserDeleteErrorState extends UserState {
  final String message;

  UserDeleteErrorState(this.message);
}

/// ===================   reset state   ===========================
class ResetUSerPasswordLoadingState extends UserState {}

class ResetUserPasswordSuccessState extends UserState {}

class ResetUSerPasswordErrorState extends UserState {
  final String message;

  ResetUSerPasswordErrorState(this.message);
}
