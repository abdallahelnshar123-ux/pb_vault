class MyUser {
  final String name;
  final String email;
  final String id;
  final String provider;
  final List<int>? salt;
  final String? passwordVerifier;

  const MyUser({
    required this.id,
    required this.email,
    required this.name,
    required this.provider,
    this.salt,
    this.passwordVerifier,
  });

  MyUser copyWith({String? name, List<int>? salt, String? passwordVerifier}) {
    return MyUser(
      id: id,
      name: name ?? this.name,
      email: email,
      provider: provider,
      salt: salt ?? this.salt,
      passwordVerifier: passwordVerifier ?? this.passwordVerifier,
    );
  }
}
