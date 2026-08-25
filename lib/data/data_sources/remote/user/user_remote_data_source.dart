import '../../../model/response/my_user_dto.dart';
import '../../../model/response/platform_account_dto/platform_account_dto.dart';

abstract class UserRemoteDataSource {
  Future<MyUserDto?> getUser(String uId);

  Future<void> createUser(MyUserDto user);

  Future<void> updateUser(MyUserDto user);

  Future<void> deleteUser(String uId);

  Future<void> changeMasterPassword({
    required String uId,
    required MyUserDto userDto,
    required List<PlatformAccountDto> accounts,
  });
}
