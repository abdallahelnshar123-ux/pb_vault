import '../../../../domain/entities/response/platform_account/platform_data.dart';

class PlatformLocalDataSource {
  const PlatformLocalDataSource();

  Map<String, PlatformData> get platforms =>
      platformMap;
}