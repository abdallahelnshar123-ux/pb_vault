import '../../domain/entities/response/platform_account/platform_data.dart';
import '../model/response/platform_account_dto/platform_data_dto.dart';

extension PlatformDataMapper on PlatformDataDto {
  PlatformData toPlatformData() {
    return PlatformData(name: name, icon: icon, website: website);
  }
}
