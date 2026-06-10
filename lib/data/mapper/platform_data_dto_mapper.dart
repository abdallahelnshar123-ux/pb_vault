import '../../domain/entities/response/account/platform_data.dart';
import '../model/response/account/platform_data_dto.dart';

extension PlatformDataDtoMapper on PlatformData {
  PlatformDataDto toPlatformDataDto() {
    return PlatformDataDto(name: name, icon: icon, website: website);
  }
}
