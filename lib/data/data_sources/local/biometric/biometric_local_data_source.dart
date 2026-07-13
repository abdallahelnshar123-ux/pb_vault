import 'package:dartz/dartz.dart';

abstract class BiometricLocalDataSource {
  Future<void> saveSecretKey(List<int> secretKey);

  Future<Option<List<int>>> getSecretKey();

  Future<void> deleteSecretKey();

  Future<void> setBiometricEnabled(bool enabled);

  bool isBiometricEnabled();
}
