
import '../../domain/entities/response/auth/auth_user.dart';
import '../model/response/auth_user_dto.dart';

extension AuthUserMapper on AuthUserDto {
  AuthUser toAuthUser() {
    return AuthUser(id: id, email: email, name: name, phone: phone);
  }
}
