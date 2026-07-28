import 'package:equatable/equatable.dart';

class LoginMethodDto extends Equatable {
  final String provider;
  final String? identifier;

  const LoginMethodDto({required this.provider, this.identifier});

  factory LoginMethodDto.fromMap(Map<String, dynamic> map) {
    return LoginMethodDto(
      provider: map['provider'] ?? '',
      identifier: map['identifier'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'provider': provider, 'identifier': identifier};
  }

  @override
  List<Object?> get props => [provider, identifier];
}
