import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/custom_field_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/encrypted_data_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/login_method_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_data_dto.dart';

class PlatformAccountDto extends Equatable {
  final String? id;
  final PlatformDataDto platform;
  final String identifier;
  final EncryptedDataDto? password;
  final List<LoginMethodDto> loginMethods;
  final EncryptedDataDto? recoveryCodes;
  final EncryptedDataDto? passkey;
  final EncryptedDataDto? twoFactorSecret;
  final EncryptedDataDto? notes;
  final List<CustomFieldDto>? customFields;
  final DateTime createdAt;

  const PlatformAccountDto({
    this.id,
    required this.platform,
    required this.identifier,
    this.password,
    this.loginMethods = const [],
    this.recoveryCodes ,
    this.passkey,
    this.twoFactorSecret,
    this.notes,
    this.customFields = const [],
    required this.createdAt,
  });

  PlatformAccountDto copyWith({
    String? id,
    PlatformDataDto? platform,
    String? identifier,
    EncryptedDataDto? password,
    List<LoginMethodDto>? loginMethods,
   EncryptedDataDto? recoveryCodes,
    EncryptedDataDto? passkey,
    EncryptedDataDto? twoFactorSecret,
    EncryptedDataDto? notes,
    List<CustomFieldDto>? customFields,
    DateTime? createdAt,
  }) {
    return PlatformAccountDto(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      identifier: identifier ?? this.identifier,
      password: password ?? this.password,
      loginMethods: loginMethods ?? this.loginMethods,
      recoveryCodes: recoveryCodes ?? this.recoveryCodes,
      passkey: passkey ?? this.passkey,
      twoFactorSecret: twoFactorSecret ?? this.twoFactorSecret,
      notes: notes ?? this.notes,
      customFields: customFields ?? this.customFields,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PlatformAccountDto.fromFireStore(Map<String, dynamic> data) {
    return PlatformAccountDto(
      id: data['id'],
      platform: PlatformDataDto.fromMap(data['platform'] ?? {}),
      identifier: data['identifier'] ?? '',
      password: data['password'] != null
          ? EncryptedDataDto.fromMap(data['password'])
          : null,
      loginMethods: (data['login_methods'] as List? ?? [])
          .map((e) => LoginMethodDto.fromMap(e))
          .toList(),
      recoveryCodes: data['recovery_codes'] != null
          ? EncryptedDataDto.fromMap(data['password'])
          : null,
      passkey: data['passkey'] != null
          ? EncryptedDataDto.fromMap(data['passkey'])
          : null,
      twoFactorSecret: data['two_factor_secret'] != null
          ? EncryptedDataDto.fromMap(data['two_factor_secret'])
          : null,
      notes: data['notes'] != null
          ? EncryptedDataDto.fromMap(data['notes'])
          : null,
      customFields: (data['custom_fields'] as List? ?? [])
          .map((e) => CustomFieldDto.fromMap(e))
          .toList(),
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'platform': platform.toMap(),
      'identifier': identifier,
      'password': password?.toMap(),
      'login_methods': loginMethods.map((e) => e.toMap()).toList(),
      'recovery_codes': recoveryCodes?.toMap(),
      'passkey': passkey?.toMap(),
      'two_factor_secret': twoFactorSecret?.toMap(),
      'notes': notes?.toMap(),
      'custom_fields': customFields?.map((e) => e.toMap()).toList(),
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  @override
  List<Object?> get props => [
    id,
    platform,
    identifier,
    password,
    loginMethods,
    recoveryCodes,
    passkey,
    twoFactorSecret,
    notes,
    customFields,
    createdAt,
  ];
}
