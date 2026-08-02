import '../../../../data/model/response/platform_account_dto/platform_account_dto.dart';

abstract class AccountRemoteDataSource {
  Future<void> addAccount({
    required PlatformAccountDto account,
    required String uId,
  });

  Future<void> updateAccount({
    required PlatformAccountDto account,
    required String uId,
  });

  Stream<List<PlatformAccountDto>> getAccountsStream({required String uId});

  Future<void> deleteAccount({required String uId, required String accountId});

  Future<PlatformAccountDto> getAccountById({
    required String uId,
    required String accountId,
  });
}
