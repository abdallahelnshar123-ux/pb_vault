import '../../domain/entities/response/platform_account/platform_data.dart';
import '../constants/platforms.dart';

extension PlatformLookup on String {
  PlatformData? get platform => appPlatforms[this];
}
