import 'package:equatable/equatable.dart';

import 'custom_field.dart';
import 'login_method.dart';

class PlatformAccount extends Equatable {
  const PlatformAccount({
    this.id,
    required this.platformId,

    required this.identifier,

    this.password,

    this.loginMethods = const [],

    this.recoveryCodes,

    this.passkey,

    this.twoFactorSecret,

    this.notes,

    this.customFields = const [],

    required this.createdAt,
  });

  final String? id;

  final String platformId;

  /// email / username / phone
  final String identifier;

  final String? password;

  /// Google, Facebook...
  final List<LoginMethod> loginMethods;

  final String? recoveryCodes;

  final String? passkey;

  final String? twoFactorSecret;

  final String? notes;

  final List<CustomField> customFields;

  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    platformId,
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

/*
import 'package:equatable/equatable.dart'; import 'platform_data.dart'; class PlatformAccount extends Equatable { const PlatformAccount({ this.id, required this.platform, required this.emailOrUsername, required this.encryptedPassword, this.notes, required this.createdAt, required this.mac, required this.nonce, }); final String? id; final PlatformData platform; final String emailOrUsername; final List<int> encryptedPassword; final List<int> nonce; final List<int> mac; final String? notes; final DateTime createdAt; @override List<Object?> get props => [ id, platform, emailOrUsername, encryptedPassword, nonce, mac, notes, createdAt, ]; }

 */
