class MyUserDto {
  final String name;
  final String email;
  final String id;
  final String provider;
  final String? masterPassword;

  const MyUserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.provider,
    this.masterPassword,
  });

  MyUserDto.fromFireStore(Map<String, dynamic> data)
    : this(
        id: data['id']?.toString() ?? '',
        name: data['name']?.toString() ?? '',
        email: data['email']?.toString() ?? '',
        provider: data['provider']?.toString() ?? '',
        masterPassword: data['master_password']?.toString() ?? '',
      );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'provider': provider,
      'master_password': masterPassword,
    };
  }
}
