
import '../../domain/entities/response/user/my_user.dart';
import '../model/response/my_user_dto.dart';

extension UserMapper on MyUserDto {
  MyUser toUser() {
    return MyUser(
      id: id,
      email: email,
      name: name,
      phone: phone,
      provider: provider,
    );
  }
}
