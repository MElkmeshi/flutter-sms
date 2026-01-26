import 'package:equatable/equatable.dart';
import 'package:sms/domain/model/input_field.dart';

enum ActionType { sms, ussd }

class ActionItem extends Equatable {
  final String id;
  final String nameEn;
  final String nameAr;
  final ActionType type;
  final String? smsNumber;
  final String? template;
  final String? ussdCode;
  final List<InputField> fields;

  const ActionItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    this.type = ActionType.sms,
    this.smsNumber,
    this.template,
    this.ussdCode,
    required this.fields,
  });

  factory ActionItem.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'sms';
    final type = typeStr == 'ussd' ? ActionType.ussd : ActionType.sms;

    return ActionItem(
      id: json['id'] as String,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      type: type,
      smsNumber: json['smsNumber'] as String?,
      template: json['template'] as String?,
      ussdCode: json['ussdCode'] as String?,
      fields:
          (json['fields'] as List)
              .map((f) => InputField.fromJson(f as Map<String, dynamic>))
              .toList(),
    );
  }

  @override
  List<Object?> get props => [id, nameEn, nameAr, type, smsNumber, template, ussdCode, fields];
}
