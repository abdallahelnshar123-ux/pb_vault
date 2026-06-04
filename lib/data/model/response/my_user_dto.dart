class MyUserDto {
  final String name;
  final String email;
  final String id;
  final String phone;
  final String provider;

  const MyUserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.provider,
  });

  MyUserDto.fromFireStore(Map<String, dynamic> data)
    : this(
        id: data['id']?.toString() ?? '',
        name: data['name']?.toString() ?? '',
        email: data['email']?.toString() ?? '',
        phone: data['phone']?.toString() ?? '',
        provider: data['provider']?.toString() ?? '',
      );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'provider': provider,
    };
  }
}
