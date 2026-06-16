abstract class PlatformAccountState {}

class AddPlatformAccountInitialState extends PlatformAccountState {}

/// ======================  add account states =====================

class AddPlatformAccountLoadingState extends PlatformAccountState {}

class AddPlatformAccountSuccessState extends PlatformAccountState {}

class AddPlatformAccountErrorState extends PlatformAccountState {
  final String message;

  AddPlatformAccountErrorState(this.message);
}

/// ======================  edite account states =====================

class EditPlatformAccountLoadingState extends PlatformAccountState {}

class EditPlatformAccountSuccessState extends PlatformAccountState {}

class EditPlatformAccountErrorState extends PlatformAccountState {
  final String message;

  EditPlatformAccountErrorState(this.message);
}

/// ======================  delete account states =====================

class DeletePlatformAccountLoadingState extends PlatformAccountState {}

class DeletePlatformAccountSuccessState extends PlatformAccountState {}

class DeletePlatformAccountErrorState extends PlatformAccountState {
  final String message;

  DeletePlatformAccountErrorState(this.message);
}
