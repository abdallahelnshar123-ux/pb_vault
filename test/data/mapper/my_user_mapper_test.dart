import 'package:flutter_test/flutter_test.dart';
import 'package:pb_vault/data/mapper/my_user_mapper.dart';
import 'package:pb_vault/data/model/response/my_user_dto.dart';
import 'package:pb_vault/domain/entities/response/user/my_user.dart';

void main() {
  group('MyUserMapper', () {
    test('should map MyUserDto to MyUser', () {
      const dto = MyUserDto(
        id: '1',
        email: 'test@test.com',
        name: 'Test User',
        provider: 'google',
        salt: [1, 2, 3],
        passwordVerifier: 'verifier',
      );

      const expected = MyUser(
        id: '1',
        email: 'test@test.com',
        name: 'Test User',
        provider: 'google',
        salt: [1, 2, 3],
        passwordVerifier: 'verifier',
      );

      expect(dto.toUser(), expected);
    });
  });
}
