class MyUser {
  final String name;
  final String email;
  final String id;
  final String phone;
  final String provider;

  const MyUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.provider,
  });

  MyUser copyWith({String? name, String? phone, int? avatarIndex}) {
    return MyUser(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email,
      provider: provider,
    );
  }
}
