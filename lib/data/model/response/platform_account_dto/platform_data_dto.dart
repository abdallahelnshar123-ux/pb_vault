import 'package:equatable/equatable.dart';
import '../../../../core/constants/firestore_constants.dart';

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
      name: map[FirestoreConstants.name] ?? '',
      icon: map[FirestoreConstants.icon] ?? '',
      website: map[FirestoreConstants.website] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.name: name,
      FirestoreConstants.icon: icon,
      FirestoreConstants.website: website
    };
  }

  @override
  List<Object?> get props => [name, icon, website];
}
