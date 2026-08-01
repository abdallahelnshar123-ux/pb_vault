import 'package:equatable/equatable.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';

abstract class PlatformAccountState extends Equatable {}

class AddPlatformAccountInitialState extends PlatformAccountState {
  @override
  List<Object?> get props => [];
}

/// ======================  add account states =====================

class AddPlatformAccountLoadingState extends PlatformAccountState {
  @override
  List<Object?> get props => [];
}

class AddPlatformAccountSuccessState extends PlatformAccountState {
  @override
  List<Object?> get props => [];
}

class AddPlatformAccountErrorState extends PlatformAccountState {
  final String message;

  AddPlatformAccountErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// ======================  edite account states =====================

class EditPlatformAccountLoadingState extends PlatformAccountState {
  @override
  List<Object?> get props => [];
}

class EditPlatformAccountSuccessState extends PlatformAccountState {
  @override
  List<Object?> get props => [];
}

class EditPlatformAccountErrorState extends PlatformAccountState {
  final String message;

  EditPlatformAccountErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// ======================  get account states =====================

class GetPlatformAccountLoadingState extends PlatformAccountState {
  @override
  List<Object?> get props => [];
}

class GetPlatformAccountSuccessState extends PlatformAccountState {
  final PlatformAccount account;

  GetPlatformAccountSuccessState(this.account);

  @override
  List<Object?> get props => [account];
}

class GetPlatformAccountErrorState extends PlatformAccountState {
  final String message;

  GetPlatformAccountErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// ======================  delete account states =====================

class DeletePlatformAccountLoadingState extends PlatformAccountState {
  @override
  List<Object?> get props => [];
}

class DeletePlatformAccountSuccessState extends PlatformAccountState {
  @override
  List<Object?> get props => [];
}

class DeletePlatformAccountErrorState extends PlatformAccountState {
  final String message;

  DeletePlatformAccountErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
