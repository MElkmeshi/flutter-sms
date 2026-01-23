import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sms/domain/model/action_item.dart';
import 'package:sms/domain/model/service_provider.dart';

/// Immutable state for the form screen
@immutable
class FormState extends Equatable {
  const FormState({
    required this.action,
    required this.provider,
    this.formValues = const {},
    this.previewMessage = '',
  });

  final ActionItem action;
  final ServiceProvider provider;
  final Map<String, String> formValues;
  final String previewMessage;

  /// Check if all required fields are filled
  bool get isFormComplete =>
      action.fields.every((field) => formValues[field.id]?.isNotEmpty == true);

  /// Create a copy with updated fields
  FormState copyWith({
    ActionItem? action,
    ServiceProvider? provider,
    Map<String, String>? formValues,
    String? previewMessage,
  }) {
    return FormState(
      action: action ?? this.action,
      provider: provider ?? this.provider,
      formValues: formValues ?? this.formValues,
      previewMessage: previewMessage ?? this.previewMessage,
    );
  }

  @override
  List<Object?> get props => [action, provider, formValues, previewMessage];
}
