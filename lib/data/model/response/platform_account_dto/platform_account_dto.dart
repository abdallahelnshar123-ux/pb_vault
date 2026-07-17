import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_data_dto.dart';

class PlatformAccountDto extends Equatable {
  final String? id;
  final PlatformDataDto platform;
  final String emailOrUsername;
  final List<int> encryptedPassword;
  final List<int> nonce;
  final List<int> mac;
  final String? notes;
  final DateTime createdAt;

  const PlatformAccountDto({
    required this.id,
    required this.platform,
    required this.emailOrUsername,
    required this.encryptedPassword,
    required this.nonce,
    required this.mac,
    this.notes,
    required this.createdAt,
  });

  PlatformAccountDto copyWith(String id) {
    return PlatformAccountDto(
      id: id,
      platform: platform,
      emailOrUsername: emailOrUsername,
      encryptedPassword: encryptedPassword,
      nonce: nonce,
      mac: mac,
      createdAt: createdAt,
      notes: notes,
    );
  }

  factory PlatformAccountDto.fromFireStore(Map<String, dynamic> data) {
    return PlatformAccountDto(
      id: data['id'],
      platform: PlatformDataDto.fromMap(data['platform'] ?? {}),
      emailOrUsername: data['email_or_username'] ?? '',
      encryptedPassword: List<int>.from(data['encrypted_password'] ?? []),
      notes: data['notes'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
      nonce: List<int>.from(data['nonce'] ?? []),
      mac: List<int>.from(data['mac'] ?? []),
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'platform': platform.toMap(),
      'email_or_username': emailOrUsername,
      'encrypted_password': encryptedPassword,
      'notes': notes,
      'created_at': Timestamp.fromDate(createdAt),
      'nonce': nonce,
      'mac': mac,
    };
  }

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
