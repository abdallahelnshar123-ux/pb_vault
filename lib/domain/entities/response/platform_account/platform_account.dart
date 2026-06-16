import 'platform_data.dart';

class PlatformAccount {
  final String? id;
  final PlatformData platform;
  final String emailOrUsername;
  final List<int> encryptedPassword;
  final List<int> nonce;
  final List<int> mac;
  final String? notes;
  final DateTime createdAt;

  PlatformAccount({
    this.id,
    required this.platform,
    required this.emailOrUsername,
    required this.encryptedPassword,
    this.notes,
    required this.createdAt,
    required this.mac ,
    required this.nonce
  });
}
