import '../../domain/entities/response/platform_account/platform_category.dart';
import '../../domain/entities/response/platform_account/platform_data.dart';

const Map<String, PlatformData> platforms = {
  "google": PlatformData(
    id: "google",
    name: "Google",
    website: "https://google.com",
    category: PlatformCategory.email,
  ),

  "github": PlatformData(
    id: "github",
    name: "GitHub",
    website: "https://github.com",
    category: PlatformCategory.development,
  ),

  "we": PlatformData(
    id: "we",
    name: "WE",
    website: "https://te.eg",
    category: PlatformCategory.communication,
  ),
};