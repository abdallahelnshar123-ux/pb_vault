import '../../../domain/entities/response/user/my_user.dart';

abstract class MasterPasswordState {}

class MasterPasswordInitial extends MasterPasswordState {}

/// ==========================   Master Password Setup states   ===========================
class MasterPasswordSetupLoading extends MasterPasswordState {}

class MasterPasswordSetupSuccess extends MasterPasswordState {
  final MyUser user;
  final bool offerBiometric;

  MasterPasswordSetupSuccess(this.user, {this.offerBiometric = false});
}

class MasterPasswordSetupError extends MasterPasswordState {
  final String message;

  MasterPasswordSetupError(this.message);
}

/// ==========================   Master Password Verify states   ===========================
class MasterPasswordVerifyLoading extends MasterPasswordState {}

class MasterPasswordVerifySuccess extends MasterPasswordState {}

class MasterPasswordVerifyError extends MasterPasswordState {
  final String message;

  MasterPasswordVerifyError(this.message);
}

/// ==========================   biometric states   ===========================

class BiometricErrorState extends MasterPasswordState {
  final String message;

  BiometricErrorState(this.message);
}