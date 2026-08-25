import '../../domain/entities/response/user/my_user.dart';
import '../model/response/my_user_dto.dart';

extension UserMapper on MyUserDto {
  MyUser toUser() {
    return MyUser(
      id: id,
      email: email,
      name: name,
      provider: provider,
      salt: salt,
      passwordVerifier: passwordVerifier,
      avatar: avatar,
    );
  }
}
