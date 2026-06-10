class MyUserDto {
  final String name;
  final String email;
  final String id;
  final String provider;
  final List<int>? salt;
  final String? passwordVerifier;

  const MyUserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.provider,
    this.passwordVerifier,
    this.salt,
  });

  factory MyUserDto.fromFireStore(Map<String, dynamic> data) {
    return MyUserDto(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      provider: data['provider']?.toString() ?? '',
      passwordVerifier: data['password_verifier']?.toString(),
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
    };
  }
}
