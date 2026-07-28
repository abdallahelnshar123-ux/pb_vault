import 'package:equatable/equatable.dart';

class EncryptedDataDto extends Equatable {
  final List<int> cipherText;
  final List<int> nonce;
  final List<int> mac;

  const EncryptedDataDto({
    required this.cipherText,
    required this.nonce,
    required this.mac,
  });

  factory EncryptedDataDto.fromMap(Map<String, dynamic> map) {
    return EncryptedDataDto(
      cipherText: List<int>.from(map['cipher_text'] ?? []),
      nonce: List<int>.from(map['nonce'] ?? []),
      mac: List<int>.from(map['mac'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {'cipher_text': cipherText, 'nonce': nonce, 'mac': mac};
  }

  @override
  List<Object?> get props => [cipherText, nonce, mac];
}
