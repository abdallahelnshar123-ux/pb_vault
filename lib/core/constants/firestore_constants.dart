class FirestoreConstants {
  // Collections
  static const String usersCollection = 'users';
  static const String accountsCollection = 'accounts';

  // Common Fields
  static const String id = 'id';
  static const String createdAt = 'created_at';

  // User Fields
  static const String name = 'name';
  static const String email = 'email';
  static const String provider = 'provider';
  static const String passwordVerifier = 'password_verifier';
  static const String salt = 'salt';
  static const String avatar = 'avatar';

  // Platform Account Fields
  static const String platformId = 'platform_id';
  static const String identifier = 'identifier';
  static const String password = 'password';
  static const String loginMethods = 'login_methods';
  static const String recoveryCodes = 'recovery_codes';
  static const String passkey = 'passkey';
  static const String twoFactorSecret = 'two_factor_secret';
  static const String notes = 'notes';
  static const String customFields = 'custom_fields';

  // Platform Data Fields
  static const String icon = 'icon';
  static const String website = 'website';
  static const String color = 'color';

  // Login Method Fields
  // 'id' and 'provider' are reused

  // Custom Field Fields
  static const String title = 'title';
  static const String value = 'value';
  static const String isSensitive = 'is_sensitive';

  // Encrypted Data Fields
  static const String cipherText = 'cipher_text';
  static const String nonce = 'nonce';
  static const String mac = 'mac';
}
