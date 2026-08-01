import '../../entities/response/platform_account/platform_category.dart';
import '../../entities/response/platform_account/platform_data.dart';

abstract interface class PlatformRepository {
  List<PlatformData> getAll();

  PlatformData? getById(String id);

  List<PlatformData> search(String query);

  List<PlatformData> getByCategory(
      PlatformCategory category,
      );
}