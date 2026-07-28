import 'package:equatable/equatable.dart';

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
      title: map['title'] ?? '',
      value: map['value'] ?? '',
      isSensitive: map['is_sensitive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'value': value, 'is_sensitive': isSensitive};
  }

  @override
  List<Object?> get props => [title, value, isSensitive];
}
