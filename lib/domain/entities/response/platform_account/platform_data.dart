import 'package:equatable/equatable.dart';

class PlatformData extends Equatable {
  final String name;
  final String icon;
  final String website;

  const PlatformData({
    required this.name,
    required this.icon,
    required this.website,
  });

  @override
  List<Object?> get props => [name, icon, website];
}
