import 'dart:math';

class PasswordUtils {
  static String generateStrongPassword() {
    const length = 16;
    const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const number = "0123456789";
    const special = "@#%^&*_-+()[]{}";

    String chars = "";
    chars += letterLowerCase;
    chars += letterUpperCase;
    chars += number;
    chars += special;

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }
}
