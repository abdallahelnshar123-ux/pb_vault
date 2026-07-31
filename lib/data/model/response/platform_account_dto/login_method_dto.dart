import 'package:equatable/equatable.dart';
import '../../../../core/constants/firestore_constants.dart';

class LoginMethodDto extends Equatable {
  final String id;
  final String provider;
  final String? identifier;

  const LoginMethodDto({required this.id,required this.provider, this.identifier});

  factory LoginMethodDto.fromMap(Map<String, dynamic> map) {
    return LoginMethodDto(
      id: map[FirestoreConstants.id] ?? '',
      provider: map[FirestoreConstants.provider] ?? '',
      identifier: map[FirestoreConstants.identifier],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.id: id,
      FirestoreConstants.provider: provider,
      FirestoreConstants.identifier: identifier
    };
  }

  @override
  List<Object?> get props => [id,provider, identifier];
}
