import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sms/domain/model/action_item.dart';
import 'package:sms/domain/model/service_provider.dart';
import 'package:sms/core/initializer/app_providers.dart';
import 'form_state.dart';

/// Parameters for the FormController family provider
@immutable
class FormParams extends Equatable {
  const FormParams({
    required this.action,
    required this.provider,
  });

  final ActionItem action;
  final ServiceProvider provider;

  @override
  List<Object?> get props => [action, provider];
}

/// Controller for managing form state and form persistence per provider
/// Uses FamilyNotifier to maintain separate state for each action/provider combination
class FormController extends FamilyNotifier<FormState, FormParams> {
  /// Static provider following the convention pattern
  static final provider =
      NotifierProvider.family<FormController, FormState, FormParams>(
    FormController.new,
  );

  @override
  FormState build(FormParams arg) {
    // Load saved form values from persistent storage
    final localStorage = ref.watch(localStorageServiceProvider);
    final savedValues = _loadProviderFormValues(localStorage, arg.provider.id);

    return FormState(
      action: arg.action,
      provider: arg.provider,
      formValues: savedValues,
      previewMessage: _generatePreview(arg.action.template, savedValues),
    );
  }

  /// Update a form field value and regenerate preview
  void updateField(String fieldId, String value) {
    final updatedValues = Map<String, String>.from(state.formValues);
    updatedValues[fieldId] = value;

    // Save to persistent storage
    final localStorage = ref.read(localStorageServiceProvider);
    _saveProviderFormValues(localStorage, state.provider.id, updatedValues);

    // Update state with new preview
    state = state.copyWith(
      formValues: updatedValues,
      previewMessage: _generatePreview(state.action.template, updatedValues),
    );
  }

  /// Clear all form values for current provider
  void clearForm() {
    state = state.copyWith(
      formValues: const {},
      previewMessage: state.action.template,
    );

    final localStorage = ref.read(localStorageServiceProvider);
    localStorage.remove('provider_form_${state.provider.id}');
  }

  /// Send SMS with the current form values
  Future<bool> sendSms() async {
    try {
      final uri = Uri(
        scheme: 'sms',
        path: state.action.smsNumber,
        queryParameters: {'body': state.previewMessage},
      );
      return await launchUrl(uri);
    } catch (e) {
      return false;
    }
  }

  // Private helper methods

  /// Generate SMS preview by replacing template placeholders with form values
  String _generatePreview(String template, Map<String, String> values) {
    String preview = template;
    values.forEach((key, value) {
      preview = preview.replaceAll('{$key}', value);
    });
    return preview;
  }

  /// Load form values from persistent storage for a specific provider
  Map<String, String> _loadProviderFormValues(
    dynamic storage,
    String providerId,
  ) {
    final savedData = storage.getString('provider_form_$providerId');
    if (savedData != null) {
      return _decodeFormValues(savedData);
    }
    return {};
  }

  /// Save form values to persistent storage for a specific provider
  Future<void> _saveProviderFormValues(
    dynamic storage,
    String providerId,
    Map<String, String> values,
  ) async {
    await storage.setString(
      'provider_form_$providerId',
      _encodeFormValues(values),
    );
  }

  /// Encode form values map to a string for storage
  /// Format: "key1:value1|key2:value2|..."
  String _encodeFormValues(Map<String, String> values) {
    return values.entries.map((e) => '${e.key}:${e.value}').join('|');
  }

  /// Decode stored string back to form values map
  Map<String, String> _decodeFormValues(String encoded) {
    final result = <String, String>{};
    final pairs = encoded.split('|');
    for (final pair in pairs) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        result[parts[0]] = parts[1];
      }
    }
    return result;
  }
}
