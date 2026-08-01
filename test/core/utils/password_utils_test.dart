import 'package:flutter_test/flutter_test.dart';
import 'package:pb_vault/core/utils/password_utils.dart';

void main() {
  group('PasswordUtils - generateStrongPassword', () {
    test('should return a password of length 16', () {
      final password = PasswordUtils.generateStrongPassword();
      expect(password.length, 16);
    });

    test('should return different passwords on consecutive calls', () {
      final password1 = PasswordUtils.generateStrongPassword();
      final password2 = PasswordUtils.generateStrongPassword();
      expect(password1, isNot(equals(password2)));
    });

    test('should only contain valid characters', () {
      const allowedChars = "abcdefghijklmnopqrstuvwxyz"
          "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
          "0123456789"
          "@#%^&*_-+()[]{}";
      
      final password = PasswordUtils.generateStrongPassword();
      
      for (var i = 0; i < password.length; i++) {
        expect(allowedChars.contains(password[i]), isTrue, 
          reason: 'Character ${password[i]} at index $i is not allowed');
      }
    });

    test('should contain at least some variety (probabilistic check)', () {
      // Since it's random, we can't guarantee all types in one shot, 
      // but we can check if it's not just one type repeatedly for many generations.
      bool hasLower = false;
      bool hasUpper = false;
      bool hasNumber = false;
      bool hasSpecial = false;

      final password = PasswordUtils.generateStrongPassword();
      
      final lowerCase = RegExp(r'[a-z]');
      final upperCase = RegExp(r'[A-Z]');
      final numbers = RegExp(r'[0-9]');
      final special = RegExp(r'[@#%^&*_\-+()\[\]{}]');

      hasLower = lowerCase.hasMatch(password);
      hasUpper = upperCase.hasMatch(password);
      hasNumber = numbers.hasMatch(password);
      hasSpecial = special.hasMatch(password);

      // In a 16-char password, it's highly likely to have at least 3 out of 4 types
      int typesCount = 0;
      if (hasLower) typesCount++;
      if (hasUpper) typesCount++;
      if (hasNumber) typesCount++;
      if (hasSpecial) typesCount++;

      expect(typesCount, greaterThanOrEqualTo(2), 
        reason: 'Password $password lacks variety');
    });
  });
}
