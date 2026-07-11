import 'package:flutter_test/flutter_test.dart';
import 'package:pb_vault/core/utils/validators.dart';

void main() {
  group('Validators.required', () {
    test('should return null when value is not empty', () {
      final result = Validators.required('valid text');
      expect(result, isNull);
    });

    test('should return error message when value is null', () {
      final result = Validators.required(null);
      expect(result, isNotNull);
    });

    test('should return error message when value is empty', () {
      final result = Validators.required('');
      expect(result, isNotNull);
    });

    test('should return error message when value is only whitespace', () {
      final result = Validators.required('   ');
      expect(result, isNotNull);
    });

    test('should return custom error message when provided', () {
      const customMessage = 'custom_error';
      final result = Validators.required('', message: customMessage);
      expect(result, isNotNull);
    });
  });

  group('Validators.email', () {
    test('should return null for valid email', () {
      expect(Validators.email('test@example.com'), isNull);
    });

    test('should return email_is_required for null or empty', () {
      expect(Validators.email(null), isNotNull);
      expect(Validators.email(''), isNotNull);
    });

    test('should return invalid_email_format for malformed emails', () {
      expect(Validators.email('test@'), isNotNull);
      expect(Validators.email('test@domain'), isNotNull);
      expect(Validators.email('@domain.com'), isNotNull);
      expect(Validators.email('test domain.com'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('should return null for password >= 6 characters', () {
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('password123'), isNull);
    });

    test('should return password_is_required for null or empty', () {
      expect(Validators.password(null), isNotNull);
      expect(Validators.password(''), isNotNull);
    });

    test(
      'should return password_must_be_at_least_6_characters for short passwords',
      () {
        expect(Validators.password('12345'), isNotNull);
        expect(Validators.password('a'), isNotNull);
      },
    );
  });

  group('Validators.confirmPassword', () {
    test('should return null when passwords match', () {
      expect(Validators.confirmPassword('pass123', 'pass123'), isNull);
    });

    test('should return confirm_password_is_required for null or empty', () {
      expect(Validators.confirmPassword(null, 'pass123'), isNotNull);
      expect(Validators.confirmPassword('', 'pass123'), isNotNull);
    });

    test('should return passwords_do_not_match for mismatched passwords', () {
      expect(Validators.confirmPassword('wrong', 'pass123'), isNotNull);
    });
  });

  group('Validators.phone', () {
    test('should return null for valid phone numbers (10-15 digits)', () {
      expect(Validators.phone('1234567890'), isNull);
      expect(Validators.phone('123456789012345'), isNull);
    });

    test('should return phone_is_required for null or empty', () {
      expect(Validators.phone(null), isNotNull);
      expect(Validators.phone(''), isNotNull);
    });

    test('should return invalid_phone_number for non-digit characters', () {
      expect(Validators.phone('123456789a'), isNotNull);
      expect(
        Validators.phone('+1234567890'),
        isNotNull,
      ); // The regex doesn't allow +
    });

    test('should return invalid_phone_number for short or long numbers', () {
      expect(Validators.phone('123456789'), isNotNull); // 9 digits
      expect(Validators.phone('1234567890123456'), isNotNull); // 16 digits
    });
  });
}
