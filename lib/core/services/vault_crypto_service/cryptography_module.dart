import 'package:cryptography/cryptography.dart';
import 'package:injectable/injectable.dart';

@module
abstract class CryptographyModule {
  @singleton
  Cryptography get cryptography => Cryptography.instance;

  @singleton
  Pbkdf2 get pbkf2 => Pbkdf2.hmacSha256(iterations: 100000, bits: 256);
}
