import 'package:equatable/equatable.dart';

import '../../../domain/entities/response/user/my_user.dart';

abstract class MasterPasswordState extends Equatable {}

class MasterPasswordInitial extends MasterPasswordState {
  @override
  List<Object?> get props => [];
}

/// ==========================   Master Password Setup states   ===========================
class MasterPasswordSetupLoading extends MasterPasswordState {
  @override
  List<Object?> get props => [];
}

class MasterPasswordSetupSuccess extends MasterPasswordState {
  final MyUser user;
  final bool offerBiometric;

  MasterPasswordSetupSuccess(this.user, {this.offerBiometric = false});

  @override
  List<Object?> get props => [user, offerBiometric];
}

class MasterPasswordSetupError extends MasterPasswordState {
  final String message;

  MasterPasswordSetupError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ==========================   Master Password Verify states   ===========================
class MasterPasswordVerifyLoading extends MasterPasswordState {
  @override
  List<Object?> get props => [];
}

class MasterPasswordVerifySuccess extends MasterPasswordState {
  final bool offerBiometric;

  MasterPasswordVerifySuccess({this.offerBiometric = false});

  @override
  List<Object?> get props => [offerBiometric];
}

class MasterPasswordVerifyError extends MasterPasswordState {
  final String message;

  MasterPasswordVerifyError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ==========================   biometric states   ===========================

class BiometricErrorState extends MasterPasswordState {
  final String message;

  BiometricErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
