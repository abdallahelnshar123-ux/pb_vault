import 'package:flutter_test/flutter_test.dart';
import 'package:pb_vault/data/mapper/account_mapper.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_account_dto.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_data_dto.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_data.dart';

void main() {
  group('AccountMapper', () {
    test('should map PlatformAccountDto to PlatformAccount', () {
      final date = DateTime(2023, 1, 1);

      final dto = PlatformAccountDto(
        id: '1',
        platform: const PlatformDataDto(
          name: 'Google',
          icon: 'icon',
          website: 'website',
        ),
        emailOrUsername: 'test@test.com',
        encryptedPassword: const [1, 2, 3],
        nonce: const [4, 5, 6],
        mac: const [7, 8, 9],
        notes: 'notes',
        createdAt: date,
      );

      final expected = PlatformAccount(
        id: '1',
        platform: const PlatformData(
          name: 'Google',
          icon: 'icon',
          website: 'website',
        ),
        emailOrUsername: 'test@test.com',
        encryptedPassword: const [1, 2, 3],
        nonce: const [4, 5, 6],
        mac: const [7, 8, 9],
        notes: 'notes',
        createdAt: date,
      );

      expect(dto.toAccount(), expected);
    });
  });
}
