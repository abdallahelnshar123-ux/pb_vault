import 'package:flutter_test/flutter_test.dart';
import 'package:pb_vault/data/mapper/platform_data_dto_mapper.dart';
import 'package:pb_vault/data/model/response/platform_account_dto/platform_data_dto.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_data.dart';

void main() {
  group('PlatformDataDtoMapper', () {
    test('should map PlatformData to PlatformDataDto', () {
      const entity = PlatformData(
        name: 'Google',
        icon: 'google_icon',
        website: 'google.com',
      );

      const expected = PlatformDataDto(
        name: 'Google',
        icon: 'google_icon',
        website: 'google.com',
      );

      expect(entity.toPlatformDataDto(), expected);
    });
  });
}
