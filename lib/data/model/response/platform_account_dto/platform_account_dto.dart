import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pb_vault/core/constants/firestore_constants.dart';
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
      id: data[FirestoreConstants.id],
      platform: PlatformDataDto.fromMap(data[FirestoreConstants.platform] ?? {}),
      identifier: data[FirestoreConstants.identifier] ?? '',
      password: data[FirestoreConstants.password] != null
          ? EncryptedDataDto.fromMap(data[FirestoreConstants.password])
          : null,
      loginMethods: (data[FirestoreConstants.loginMethods] as List? ?? [])
          .map((e) => LoginMethodDto.fromMap(e))
          .toList(),
      recoveryCodes: data[FirestoreConstants.recoveryCodes] != null
          ? EncryptedDataDto.fromMap(data[FirestoreConstants.recoveryCodes])
          : null,
      passkey: data[FirestoreConstants.passkey] != null
          ? EncryptedDataDto.fromMap(data[FirestoreConstants.passkey])
          : null,
      twoFactorSecret: data[FirestoreConstants.twoFactorSecret] != null
          ? EncryptedDataDto.fromMap(data[FirestoreConstants.twoFactorSecret])
          : null,
      notes: data[FirestoreConstants.notes] != null
          ? EncryptedDataDto.fromMap(data[FirestoreConstants.notes])
          : null,
      customFields: (data[FirestoreConstants.customFields] as List? ?? [])
          .map((e) => CustomFieldDto.fromMap(e))
          .toList(),
      createdAt: (data[FirestoreConstants.createdAt] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      FirestoreConstants.id: id,
      FirestoreConstants.platform: platform.toMap(),
      FirestoreConstants.identifier: identifier,
      FirestoreConstants.password: password?.toMap(),
      FirestoreConstants.loginMethods: loginMethods.map((e) => e.toMap()).toList(),
      FirestoreConstants.recoveryCodes: recoveryCodes?.toMap(),
      FirestoreConstants.passkey: passkey?.toMap(),
      FirestoreConstants.twoFactorSecret: twoFactorSecret?.toMap(),
      FirestoreConstants.notes: notes?.toMap(),
      FirestoreConstants.customFields: customFields?.map((e) => e.toMap()).toList(),
      FirestoreConstants.createdAt: Timestamp.fromDate(createdAt),
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
