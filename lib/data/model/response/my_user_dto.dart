import 'package:equatable/equatable.dart';

class MyUserDto extends Equatable {
  final String name;
  final String email;
  final String id;
  final String provider;
  final List<int>? salt;
  final String? passwordVerifier;
  final String? avatar;

  const MyUserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.provider,
    this.passwordVerifier,
    this.salt,
    this.avatar,
  });

  factory MyUserDto.fromFireStore(Map<String, dynamic> data) {
    return MyUserDto(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      provider: data['provider']?.toString() ?? '',
      passwordVerifier: data['password_verifier']?.toString(),
      avatar: data['avatar']?.toString() ?? '',
      salt: data['salt'] != null ? List<int>.from(data['salt']) : null,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'provider': provider,
      'password_verifier': passwordVerifier,
      'salt': salt,
      'avatar': avatar,
    };
  }

  @override
  List<Object?> get props => [
    name,
    email,
    id,
    passwordVerifier,
    salt,
    provider,
    avatar,
  ];
}
