// import 'package:equatable/equatable.dart';
// import '../../../../core/constants/firestore_constants.dart';
//
// class PlatformDataDto extends Equatable {
//   final String id;
//   final String name;
//   final String icon;
//   final String website;
//   final int color;
//
//   const PlatformDataDto({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.website,
//     required this.color,
//   });
//
//   factory PlatformDataDto.fromMap(Map<String, dynamic> map) {
//     return PlatformDataDto(
//       id: map[FirestoreConstants.id] ?? '',
//       name: map[FirestoreConstants.name] ?? '',
//       icon: map[FirestoreConstants.icon] ?? '',
//       website: map[FirestoreConstants.website] ?? '',
//       color: map[FirestoreConstants.color] ?? 0xFF000000,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       FirestoreConstants.id: id,
//       FirestoreConstants.name: name,
//       FirestoreConstants.icon: icon,
//       FirestoreConstants.website: website,
//       FirestoreConstants.color: color,
//     };
//   }
//
//   @override
//   List<Object?> get props => [id, name, icon, website, color];
// }
