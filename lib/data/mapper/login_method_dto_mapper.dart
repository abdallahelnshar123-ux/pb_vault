import '../../domain/entities/response/platform_account/login_method.dart';
import '../model/response/platform_account_dto/login_method_dto.dart';

extension LoginMethodDtoMapper on LoginMethod {
  LoginMethodDto toLoginMethodDto() {
    return LoginMethodDto(
      provider: provider.name,
      identifier: identifier,
      id: id,
    );
  }
}
