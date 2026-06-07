import '../../../model/response/auth_user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserDto> continueWithGoogle();

  Future<AuthUserDto> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUserDto> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<AuthUserDto> reAuthenticateWithEmailAndPassword(String password);

  Future<AuthUserDto> reAuthenticateWithGoogle();

  Future<void> resetPassword({required String email});

  Future<void> deleteAccount();
}
