import 'package:flutter_test/flutter_test.dart';
import 'package:pb_vault/core/utils/password_utils.dart';

void main() {
  group('PasswordUtils.generateStrongPassword', () {
    test('should return a string of length 16 when called', () {
      // Act
      final result = PasswordUtils.generateStrongPassword();

      // Assert
      expect(result, isA<String>());
      expect(result.length, 16);
    });

    test('should return unique passwords when called multiple times', () {
      // Act
      final first = PasswordUtils.generateStrongPassword();
      final second = PasswordUtils.generateStrongPassword();
      final third = PasswordUtils.generateStrongPassword();

      // Assert
      expect(first, isNot(equals(second)));
      expect(first, isNot(equals(third)));
      expect(second, isNot(equals(third)));
    });

    test('should produce many unique passwords when called in a loop', () {
      // Arrange
      final passwords = <String>{};
      const iterations = 100;

      // Act
      for (int i = 0; i < iterations; i++) {
        passwords.add(PasswordUtils.generateStrongPassword());
      }

      // Assert
      expect(passwords.length, iterations, 
        reason: 'Should have generated $iterations unique passwords');
    });

    test('should only contain allowed characters when generated', () {
      // Arrange
      const allowedChars = "abcdefghijklmnopqrstuvwxyz"
          "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
          "0123456789"
          "@#%^&*_-+()[]{}";
      
      // Act
      final result = PasswordUtils.generateStrongPassword();
      
      // Assert
      for (int i = 0; i < result.length; i++) {
        expect(allowedChars.contains(result[i]), isTrue, 
          reason: 'Character ${result[i]} at index $i is not in the allowed set');
      }
    });

    test('should contain mixed character types when generated', () {
      // Act
      final password = PasswordUtils.generateStrongPassword();
      
      // Arrange matchers
      final hasLower = RegExp(r'[a-z]').hasMatch(password);
      final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
      final hasNumbers = RegExp(r'[0-9]').hasMatch(password);
      final hasSpecial = RegExp(r'[@#%^&*_\-+()\[\]{}]').hasMatch(password);

      // Assert - A 16 char random password is statistically certain to have variety
      int typesFound = 0;
      if (hasLower) typesFound++;
      if (hasUpper) typesFound++;
      if (hasNumbers) typesFound++;
      if (hasSpecial) typesFound++;

      expect(typesFound, greaterThanOrEqualTo(2), 
        reason: 'Password "$password" should have at least 2 types of characters for strength');
    });
  });
}
