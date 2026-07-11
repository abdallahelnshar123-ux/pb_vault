import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/services/firebase_services/firestore_service.dart';
import '../../../../exceptions/app_exceptions.dart';
import '../../../../model/response/platform_account_dto/platform_account_dto.dart';
import '../account_remote_data_source.dart';

@Injectable(as: AccountRemoteDataSource)
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final FirestoreService _firestoreService;

  AccountRemoteDataSourceImpl(this._firestoreService);

  @override
  Future<void> addAccount({
    required PlatformAccountDto account,
    required String uId,
  }) async {
    try {
      await _firestoreService.addAccount(account: account, uId: uId);
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'server_error');
    } on SocketException {
      throw NetworkException(message: 'no_internet');
    } catch (e) {
      throw UnexpectedException(message: e.toString());
    }
  }

  @override
  Future<void> updateAccount({
    required PlatformAccountDto account,
    required String uId,
  }) async {
    try {
      await _firestoreService.updateAccount(account: account, uId: uId);
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'server_error');
    } on SocketException {
      throw NetworkException(message: 'no_internet');
    } catch (e) {
      throw UnexpectedException(message: e.toString());
    }
  }

  @override
  Stream<List<PlatformAccountDto>> getAccountsStream({required String uId}) {
    return _firestoreService.getAccountsStream(uId: uId).handleError((error) {
      switch (error) {
        case FirebaseException _:
          throw ServerException(message: error.message ?? 'server_error');
        case SocketException _:
          throw NetworkException(message: 'no_internet');
        default:
          throw UnexpectedException(message: error.toString());
      }
    });
  }

  @override
  Future<void> deleteAccount({
    required String uId,
    required String accountId,
  }) async {
    try {
      await _firestoreService.deleteAccount(uId: uId, accountId: accountId);
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'server_error');
    } on SocketException {
      throw NetworkException(message: 'no_internet');
    } catch (e) {
      throw UnexpectedException(message: e.toString());
    }
  }
}
