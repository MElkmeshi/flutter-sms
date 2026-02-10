import 'dart:convert';

import 'package:equatable/equatable.dart';

class SavedFieldValue extends Equatable {
  const SavedFieldValue({
    required this.name,
    required this.value,
    this.lastUsed,
    this.usageCount = 0,
  });

  final String name;
  final String value;
  final DateTime? lastUsed;
  final int usageCount;

  factory SavedFieldValue.fromJson(Map<String, dynamic> json) {
    return SavedFieldValue(
      name: json['name'] as String,
      value: json['value'] as String,
      lastUsed: json['lastUsed'] != null
          ? DateTime.parse(json['lastUsed'] as String)
          : null,
      usageCount: json['usageCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'lastUsed': lastUsed?.toIso8601String(),
      'usageCount': usageCount,
    };
  }

  SavedFieldValue copyWith({
    String? name,
    String? value,
    DateTime? lastUsed,
    int? usageCount,
  }) {
    return SavedFieldValue(
      name: name ?? this.name,
      value: value ?? this.value,
      lastUsed: lastUsed ?? this.lastUsed,
      usageCount: usageCount ?? this.usageCount,
    );
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
  List<Object?> get props => [name, value, lastUsed, usageCount];
}
