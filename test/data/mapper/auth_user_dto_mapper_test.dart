import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pb_vault/data/mapper/auth_user_dto_mapper.dart';
import 'package:pb_vault/data/model/response/auth_user_dto.dart';

class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  group('AuthUserDtoMapper', () {
    late MockUserCredential mockUserCredential;
    late MockUser mockUser;

    setUp(() {
      mockUserCredential = MockUserCredential();
      mockUser = MockUser();
    });

    test('should map UserCredential to AuthUserDto when user is present', () {
      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn('test@test.com');
      when(() => mockUser.displayName).thenReturn('Test User');
      when(() => mockUserCredential.user).thenReturn(mockUser);

      const expected = AuthUserDto(
        id: '123',
        email: 'test@test.com',
        name: 'Test User',
      );

      expect(mockUserCredential.toAuthUserDto(), expected);
    });

    test('should map UserCredential to AuthUserDto with defaults when user is null', () {
      when(() => mockUserCredential.user).thenReturn(null);

      const expected = AuthUserDto(
        id: '',
        email: '',
        name: '',
      );

      expect(mockUserCredential.toAuthUserDto(), expected);
    });
    test('should use empty strings when user fields are null', () {
      when(() => mockUserCredential.user).thenReturn(mockUser);

      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn(null);
      when(() => mockUser.displayName).thenReturn(null);

      const expected = AuthUserDto(
        id: '123',
        email: '',
        name: '',
      );

      expect(mockUserCredential.toAuthUserDto(), expected);
    });
  });


}
