import 'package:equatable/equatable.dart';
import '../../../../core/constants/firestore_constants.dart';

class CustomFieldDto extends Equatable {
  final String title;
  final String value;
  final bool isSensitive;

  const CustomFieldDto({
    required this.title,
    required this.value,
    this.isSensitive = false,
  });

  factory CustomFieldDto.fromMap(Map<String, dynamic> map) {
    return CustomFieldDto(
      title: map[FirestoreConstants.title] ?? '',
      value: map[FirestoreConstants.value] ?? '',
      isSensitive: map[FirestoreConstants.isSensitive] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.title: title,
      FirestoreConstants.value: value,
      FirestoreConstants.isSensitive: isSensitive
    };
  }

  @override
  List<Object?> get props => [title, value, isSensitive];
}
