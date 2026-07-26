import 'package:equatable/equatable.dart';

class PlatformDataDto extends Equatable {
  final String name;
  final String icon;
  final String website;

  const PlatformDataDto({
    required this.name,
    required this.icon,
    required this.website,
  });

  factory PlatformDataDto.fromMap(Map<String, dynamic> map) {
    return PlatformDataDto(
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
      website: map['website'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'icon': icon, 'website': website};
  }

  @override
  List<Object?> get props => [name, icon, website];
}
