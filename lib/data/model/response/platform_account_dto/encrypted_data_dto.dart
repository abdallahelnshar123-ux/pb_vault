import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

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
      cipherText: List<int>.from(map[FirestoreConstants.cipherText] ?? []),
      nonce: List<int>.from(map[FirestoreConstants.nonce] ?? []),
      mac: List<int>.from(map[FirestoreConstants.mac] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.cipherText: cipherText,
      FirestoreConstants.nonce: nonce,
      FirestoreConstants.mac: mac,
    };
  }

  @override
  List<Object?> get props => [cipherText, nonce, mac];
}
