import 'package:equatable/equatable.dart';

class FieldOption extends Equatable {
  final String labelEn;
  final String labelAr;
  final String value;

  const FieldOption({
    required this.labelEn,
    required this.labelAr,
    required this.value,
  });

  factory FieldOption.fromJson(Map<String, dynamic> json) {
    return FieldOption(
      labelEn: json['label_en'] as String,
      labelAr: json['label_ar'] as String,
      value: json['value'] as String,
    );
  }

  @override
  List<Object?> get props => [labelEn, labelAr, value];
}
