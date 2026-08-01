import 'package:injectable/injectable.dart';

import '../../../domain/entities/response/platform_account/platform_category.dart';
import '../../../domain/entities/response/platform_account/platform_data.dart';
import '../../../domain/repository/platform/platform_repository.dart';
import '../../data_sources/local/platform/platform_local_data_source.dart';

@Injectable(as: PlatformRepository)
class PlatformRepositoryImpl implements PlatformRepository {
  final PlatformLocalDataSource local;

  const PlatformRepositoryImpl(this.local);

  @override
  List<PlatformData> getAll() => local.platforms.values.toList();

  @override
  PlatformData? getById(String id) => local.platforms[id];

  @override
  List<PlatformData> search(String query) {
    final q = query.toLowerCase();

    return local.platforms.values
        .where((e) => e.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  List<PlatformData> getByCategory(PlatformCategory category) {
    return local.platforms.values.where((e) => e.category == category).toList();
  }
}
