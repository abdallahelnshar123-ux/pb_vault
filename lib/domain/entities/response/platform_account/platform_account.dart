import 'package:equatable/equatable.dart';

import 'platform_data.dart';

class PlatformAccount extends Equatable {
  const PlatformAccount({
    this.id,
    required this.platform,
    required this.emailOrUsername,
    required this.encryptedPassword,
    this.notes,
    required this.createdAt,
    required this.mac,
    required this.nonce,
  });

  final String? id;
  final PlatformData platform;
  final String emailOrUsername;
  final List<int> encryptedPassword;
  final List<int> nonce;
  final List<int> mac;
  final String? notes;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    platform,
    emailOrUsername,
    encryptedPassword,
    nonce,
    mac,
    notes,
    createdAt,
  ];
}
