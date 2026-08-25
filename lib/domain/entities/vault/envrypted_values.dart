import '../response/platform_account/encrypted_data.dart';

class EncryptedValues {
  final EncryptedData? password;
  final EncryptedData? notes;
  final EncryptedData? recoveryCodes;
  final EncryptedData? passkey;

  const EncryptedValues({
    this.password,
    this.notes,
    this.recoveryCodes,
    this.passkey,
  });
}
