import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms/core/initializer/app_providers.dart';
import 'package:sms/features/sms_commands/form/models/saved_field_value.dart';

/// Controller for managing saved field values per field ID.
/// Uses FamilyNotifier parameterized by fieldId so values are shared
/// across all actions that use the same field.
class SavedValuesController
    extends FamilyNotifier<List<SavedFieldValue>, String> {
  static final provider = NotifierProvider.family<SavedValuesController,
      List<SavedFieldValue>, String>(
    SavedValuesController.new,
  );

  String _storageKey(String fieldId) => 'saved_values_$fieldId';

  @override
  List<SavedFieldValue> build(String arg) {
    final localStorage = ref.watch(localStorageServiceProvider);
    final stored = localStorage.getString(_storageKey(arg));
    if (stored != null && stored.isNotEmpty) {
      try {
        return SavedFieldValue.listFromJsonString(stored);
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  void addValue(SavedFieldValue value) {
    final updated = [...state, value];
    state = updated;
    _persist(updated);
  }

  void removeValue(int index) {
    final updated = [...state]..removeAt(index);
    state = updated;
    _persist(updated);
  }

  void _persist(List<SavedFieldValue> values) {
    final localStorage = ref.read(localStorageServiceProvider);
    localStorage.setString(
      _storageKey(arg),
      SavedFieldValue.listToJsonString(values),
    );
  }
}
