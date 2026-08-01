import '../../domain/entities/response/platform_account/custom_field.dart';
import '../model/response/platform_account_dto/custom_field_dto.dart';

extension CustomFieldDtoMapper on CustomField {
  CustomFieldDto toCustomFieldDto() {
    return CustomFieldDto(title: title, value: value, isSensitive: isSensitive);
  }
}
