import '../../domain/entities/response/account/platform_data.dart';
import '../model/response/account/platform_data_dto.dart';

extension PlatformDataMapper on PlatformDataDto {
  PlatformData toPlatformData() {
    return PlatformData(name: name, icon: icon, website: website);
  }
}
