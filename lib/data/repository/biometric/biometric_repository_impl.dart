import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import '../../../domain/failure/failure.dart';
import '../../../domain/repository/biometric/biometric_repository.dart';
import '../../data_sources/local/biometric/biometric_local_data_source.dart';
import '../../exceptions/app_exceptions.dart';
import '../../mapper/exception_mapper.dart';

@Injectable(as: BiometricRepository)
class BiometricRepositoryImpl implements BiometricRepository {
  final LocalAuthentication _localAuth;
  final BiometricLocalDataSource _localDataSource;

  BiometricRepositoryImpl(this._localAuth, this._localDataSource);

  @override
  Future<Either<Failure, bool>> isBiometricSupported() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics ||
          await _localAuth.isDeviceSupported();
      return Right(canAuthenticate);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticate() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to unlock your vault',
        biometricOnly: false,
        persistAcrossBackgrounding: true,

      );
      return Right(authenticated);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSecretKey(List<int> secretKey) async {
    try {
      await _localDataSource.saveSecretKey(secretKey);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Option<List<int>>>> getSecretKey() async {
    try {
      final key = await _localDataSource.getSecretKey();
      return Right(key);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSecretKey() async {
    try {
      await _localDataSource.deleteSecretKey();
      return const Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setBiometricEnabled(bool enabled) async {
    try {
      await _localDataSource.setBiometricEnabled(enabled);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Either<Failure, bool> isBiometricEnabled() {
    try {
      return Right(_localDataSource.isBiometricEnabled());
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
