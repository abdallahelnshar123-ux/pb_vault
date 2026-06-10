abstract class AddAccountState {}

class AddAccountInitial extends AddAccountState {}

class AddAccountLoading extends AddAccountState {}

class AddAccountSuccess extends AddAccountState {}

class AddAccountError extends AddAccountState {
  final String message;
  AddAccountError(this.message);
}
