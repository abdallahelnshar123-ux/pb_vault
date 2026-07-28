import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pb_vault/data/mapper/encrypted_data_mapper.dart';

import '../../../domain/entities/response/platform_account/encrypted_data.dart';
import '../../../domain/failure/failure.dart';
import '../../../domain/repository/vault/vault_repository.dart';
import '../../data_sources/remote/vault/vault_remote_data_source.dart';
import '../../exceptions/app_exceptions.dart';
import '../../mapper/exception_mapper.dart';

@LazySingleton(as: VaultRepository)
class VaultRepositoryImpl implements VaultRepository {
  final VaultRemoteDataSource _vaultRemoteDataSource;

  VaultRepositoryImpl(this._vaultRemoteDataSource);

  @override
  Future<Either<Failure, EncryptedData>> encrypt(String text) async {
    try {
      final result = await _vaultRemoteDataSource.encrypt(text);
      return Right(result.toEncryptedData());
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> decrypt(EncryptedData data) async {
    try {
      final result = await _vaultRemoteDataSource.decrypt(data);
      return Right(result);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createVerifier(
    String password,
  ) async {
    try {
      final result = await _vaultRemoteDataSource.createVerifier(password);
      return Right(result);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getSecretKeyBytes() async {
    try {
      final result = await _vaultRemoteDataSource.getSecretKeyBytes();
      return Right(result);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> unlock({
    required String password,
    required List<int> salt,
    required String verifier,
  }) async {
    try {
      final result = await _vaultRemoteDataSource.unlock(
        password: password,
        salt: salt,
        verifier: verifier,
      );
      return Right(result);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> unlockWithKey(List<int> keyBytes) async {
    try {
      await _vaultRemoteDataSource.unlockWithKey(keyBytes);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  void lock() {
    _vaultRemoteDataSource.lock();
  }

  @override
  bool get isLocked => _vaultRemoteDataSource.isLocked;
}
