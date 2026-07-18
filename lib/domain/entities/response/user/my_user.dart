import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  final String name;
  final String email;
  final String id;
  final String provider;
  final List<int>? salt;
  final String? passwordVerifier;
  final String? avatar;

  const MyUser({
    required this.id,
    required this.email,
    required this.name,
    required this.provider,
    this.salt,
    this.passwordVerifier,
    this.avatar,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    provider,
    salt,
    passwordVerifier,
    avatar,
  ];

  MyUser copyWith({
    String? name,
    List<int>? salt,
    String? passwordVerifier,
    String? avatar,
  }) {
    return MyUser(
      id: id,
      name: name ?? this.name,
      email: email,
      provider: provider,
      salt: salt ?? this.salt,
      passwordVerifier: passwordVerifier ?? this.passwordVerifier,
      avatar: avatar ?? this.avatar,
    );
  }
}
