import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

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
      id: data[FirestoreConstants.id]?.toString() ?? '',
      name: data[FirestoreConstants.name]?.toString() ?? '',
      email: data[FirestoreConstants.email]?.toString() ?? '',
      provider: data[FirestoreConstants.provider]?.toString() ?? '',
      passwordVerifier: data[FirestoreConstants.passwordVerifier]?.toString(),
      avatar: data[FirestoreConstants.avatar]?.toString() ?? '',
      salt: data[FirestoreConstants.salt] != null
          ? List<int>.from(data[FirestoreConstants.salt])
          : null,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      FirestoreConstants.id: id,
      FirestoreConstants.name: name,
      FirestoreConstants.email: email,
      FirestoreConstants.provider: provider,
      FirestoreConstants.passwordVerifier: passwordVerifier,
      FirestoreConstants.salt: salt,
      FirestoreConstants.avatar: avatar,
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
