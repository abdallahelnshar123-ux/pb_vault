import '../../domain/entities/response/user/my_user.dart';
import '../model/response/my_user_dto.dart';

extension MyUserDtoMapper on MyUser {
  MyUserDto toMyUserDto() {
    return MyUserDto(
      id: id,
      email: email,
      name: name,
      provider: provider,
      passwordVerifier: passwordVerifier,
      salt: salt,
      avatar: avatar,
    );
  }
}
