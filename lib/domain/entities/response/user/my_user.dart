class MyUser {
  final String name;
  final String email;
  final String id;
  final String provider;
  final String? masterPassword;

  const MyUser({
    required this.id,
    required this.email,
    required this.name,
    required this.provider,
    this.masterPassword,
  });

  MyUser copyWith({String? name, String? masterPassword}) {
    return MyUser(
      id: id,
      name: name ?? this.name,
      email: email,
      provider: provider,
      masterPassword: masterPassword ?? this.masterPassword,
    );
  }
}
