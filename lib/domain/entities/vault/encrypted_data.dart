import 'package:equatable/equatable.dart';

class EncryptedData extends Equatable {
  final List<int> cipherText;
  final List<int> mac;
  final List<int> nonce;

  const EncryptedData({
    required this.cipherText,
    required this.mac,
    required this.nonce,
  });

  @override
  List<Object?> get props => [cipherText, mac, nonce];
}
