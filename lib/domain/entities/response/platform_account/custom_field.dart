import 'package:equatable/equatable.dart';

class CustomField extends Equatable {
  const CustomField({
    required this.title,
    required this.value,
    this.isSensitive = false,
  });

  final String title;

  final String value;

  final bool isSensitive;

  @override
  // TODO: implement props
  List<Object?> get props => [title, value, isSensitive];
}
