class EncryptedData {
  final List<int> cipherText;
  final List<int> mac;
  final List<int> nonce;

  EncryptedData({
    required this.cipherText,
    required this.mac,
    required this.nonce,
  });
}
