import 'package:equatable/equatable.dart';

enum LoginProvider {
  password,
  google,
  facebook,
  apple,
  github,
  microsoft,
  x,
  discord,
  linkedin,
  passkey;

  bool get requiresEmail => switch (this) {
    passkey => false,
    _ => true,
  };
}

class LoginMethod extends Equatable {
  const LoginMethod({required this.id, required this.provider, this.identifier});
  final String id;

  final LoginProvider provider;

  /// optional
  final String? identifier;

  @override
  List<Object?> get props => [id,provider, identifier];
}
