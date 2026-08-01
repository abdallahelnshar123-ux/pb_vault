import 'package:equatable/equatable.dart';

import 'platform_category.dart';

class PlatformData extends Equatable {
  final String id;

  final String name;

  final String website;

  final PlatformCategory category;

  const PlatformData({
    required this.id,
    required this.name,
    required this.website,
    required this.category,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    website,
    category,
  ];
}