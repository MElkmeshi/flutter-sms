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

  /// Update usage tracking when a value is selected
  void updateUsage(int index) {
    if (index < 0 || index >= state.length) return;

    final updated = [...state];
    updated[index] = updated[index].copyWith(
      lastUsed: DateTime.now(),
      usageCount: updated[index].usageCount + 1,
    );
    state = updated;
    _persist(updated);
  }

  /// Update the name of a saved value
  void updateValueName(int index, String newName) {
    if (index < 0 || index >= state.length) return;

    final updated = [...state];
    updated[index] = updated[index].copyWith(name: newName);
    state = updated;
    _persist(updated);
  }

  /// Get sorted values (recent and frequent first)
  List<SavedFieldValue> getSortedValues() {
    final values = [...state];
    values.sort((a, b) {
      // Recently used in last 7 days comes first
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      final aRecent = a.lastUsed?.isAfter(sevenDaysAgo) ?? false;
      final bRecent = b.lastUsed?.isAfter(sevenDaysAgo) ?? false;

      if (aRecent && !bRecent) return -1;
      if (!aRecent && bRecent) return 1;

      // Then by usage count
      final countCompare = b.usageCount.compareTo(a.usageCount);
      if (countCompare != 0) return countCompare;

      // Then by most recent
      if (a.lastUsed != null && b.lastUsed != null) {
        final dateCompare = b.lastUsed!.compareTo(a.lastUsed!);
        if (dateCompare != 0) return dateCompare;
      }
      if (a.lastUsed != null && b.lastUsed == null) return -1;
      if (a.lastUsed == null && b.lastUsed != null) return 1;

      // Finally alphabetically by name
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return values;
  }

  /// Search values by name or value
  List<SavedFieldValue> searchValues(String query) {
    if (query.isEmpty) return getSortedValues();

    final lowerQuery = query.toLowerCase();
    return getSortedValues().where((item) =>
      item.name.toLowerCase().contains(lowerQuery) ||
      item.value.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  void _persist(List<SavedFieldValue> values) {
    final localStorage = ref.read(localStorageServiceProvider);
    localStorage.setString(
      _storageKey(arg),
      SavedFieldValue.listToJsonString(values),
    );
  }
}
