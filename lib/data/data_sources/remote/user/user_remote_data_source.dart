import '../../../model/response/my_user_dto.dart';

abstract class UserRemoteDataSource {
  Future<MyUserDto?> getUser(String uId);

  Future<void> createUser(MyUserDto user);

  Future<void> updateUser(MyUserDto user);

  Future<void> deleteUser(String uId);
}
