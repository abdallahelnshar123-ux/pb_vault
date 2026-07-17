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
class UnlockLoadingState extends MasterPasswordState {
  @override
  List<Object?> get props => [];
}

class UnlockSuccessState extends MasterPasswordState {
  final bool offerBiometric;

  UnlockSuccessState({this.offerBiometric = false});

  @override
  List<Object?> get props => [offerBiometric];
}

class UnlockErrorState extends MasterPasswordState {
  final String message;

  UnlockErrorState(this.message);

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
