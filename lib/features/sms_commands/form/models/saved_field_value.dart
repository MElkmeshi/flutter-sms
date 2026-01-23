import 'dart:convert';

import 'package:equatable/equatable.dart';

class SavedFieldValue extends Equatable {
  const SavedFieldValue({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;

  factory SavedFieldValue.fromJson(Map<String, dynamic> json) {
    return SavedFieldValue(
      name: json['name'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }

  static List<SavedFieldValue> listFromJsonString(String jsonString) {
    final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
    return decoded
        .map((e) => SavedFieldValue.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJsonString(List<SavedFieldValue> values) {
    return json.encode(values.map((e) => e.toJson()).toList());
  }

  @override
  List<Object?> get props => [name, value];
}
