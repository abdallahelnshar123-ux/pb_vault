import 'package:equatable/equatable.dart';

class LoginMethodDto extends Equatable {
  final String id;
  final String provider;
  final String? identifier;

  const LoginMethodDto({required this.id,required this.provider, this.identifier});

  factory LoginMethodDto.fromMap(Map<String, dynamic> map) {
    return LoginMethodDto(
      id: map['id']??'',
      provider: map['provider'] ?? '',
      identifier: map['identifier'],
    );
  }

  Map<String, dynamic> toMap() {
    return { 'id': id, 'provider': provider, 'identifier': identifier};
  }

  @override
  List<Object?> get props => [id,provider, identifier];
}
