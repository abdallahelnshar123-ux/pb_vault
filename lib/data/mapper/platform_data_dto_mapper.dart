import '../../domain/entities/response/platform_account/platform_data.dart';
import '../model/response/platform_account_dto/platform_data_dto.dart';

extension PlatformDataDtoMapper on PlatformData {
  PlatformDataDto toPlatformDataDto() {
    return PlatformDataDto(name: name, icon: icon, website: website);
  }
}
