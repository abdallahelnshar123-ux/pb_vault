import '../../domain/entities/response/platform_account/login_method.dart';
import '../model/response/platform_account_dto/login_method_dto.dart';

extension LoginMethodMapper on LoginMethodDto {
  LoginMethod toLoginMethod() {
    return LoginMethod(
      provider: LoginProvider.values.firstWhere(
        (e) => e.name == provider,
        orElse: () => LoginProvider.password,
      ),
      identifier: identifier,
      id: id,
    );
  }
}
