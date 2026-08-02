import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'platform_category.dart';

class PlatformData extends Equatable {
  final String id;

  final String name;

  final String website;

  final IconData? icon;

  final Color? color;

  final String? iconPath;

  final PlatformCategory? category;

  const PlatformData({
    required this.id,
    required this.name,
    required this.website,
    this.icon,
    this.color,
    this.iconPath,
    this.category,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    website,
    icon,
    color,
    iconPath,
    category,
  ];
}
