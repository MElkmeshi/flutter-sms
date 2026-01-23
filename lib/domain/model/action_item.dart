import 'package:equatable/equatable.dart';
import 'package:sms/domain/model/input_field.dart';

class ActionItem extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;
  final String smsNumber;
  final String template;
  final List<InputField> fields;

  const ActionItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.smsNumber,
    required this.template,
    required this.fields,
  });

  factory ActionItem.fromJson(Map<String, dynamic> json) {
    return ActionItem(
      id: json['id'] as String,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      smsNumber: json['smsNumber'] as String,
      template: json['template'] as String,
      fields:
          (json['fields'] as List)
              .map((f) => InputField.fromJson(f as Map<String, dynamic>))
              .toList(),
    );
  }

  @override
  List<Object?> get props => [id, nameEn, nameAr, smsNumber, template, fields];
}
