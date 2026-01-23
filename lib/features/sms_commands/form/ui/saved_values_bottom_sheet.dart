import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/features/sms_commands/form/logic/saved_values_controller.dart';
import 'package:sms/features/sms_commands/form/models/saved_field_value.dart';

class SavedValuesBottomSheet extends HookConsumerWidget {
  const SavedValuesBottomSheet({
    super.key,
    required this.fieldId,
    required this.fieldLabel,
    required this.currentValue,
    required this.onValueSelected,
  });

  final String fieldId;
  final String fieldLabel;
  final String currentValue;
  final ValueChanged<String> onValueSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final savedValues = ref.watch(SavedValuesController.provider(fieldId));

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                '${l10n.savedValues} - $fieldLabel',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              // List or empty state
              Expanded(
                child: savedValues.isEmpty
                    ? _buildEmptyState(context, l10n, colorScheme)
                    : _buildValuesList(
                        context, ref, savedValues, colorScheme, l10n, scrollController),
              ),
              // Save current value button
              const SizedBox(height: 8),
              SafeArea(
                child: FilledButton.icon(
                  onPressed: currentValue.isEmpty
                      ? null
                      : () => _showSaveDialog(context, ref, l10n, colorScheme),
                  icon: const Icon(Icons.save, size: 18),
                  label: Text(
                    l10n.saveCurrentValue,
                    style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noSavedValues,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.noSavedValuesHint,
            textAlign: TextAlign.center,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValuesList(
    BuildContext context,
    WidgetRef ref,
    List<SavedFieldValue> values,
    ColorScheme colorScheme,
    AppLocalizations l10n,
    ScrollController scrollController,
  ) {
    return ListView.separated(
      controller: scrollController,
      itemCount: values.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = values[index];
        return Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () {
              onValueSelected(item.value);
              Navigator.of(context).pop();
            },
            leading: CircleAvatar(
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.bookmark,
                color: colorScheme.primary,
                size: 18,
              ),
            ),
            title: Text(
              item.name,
              style: GoogleFonts.ibmPlexSans(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              item.value,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: colorScheme.error,
                size: 20,
              ),
              onPressed: () => _confirmDelete(context, ref, index, l10n, colorScheme),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    int index,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteSavedValue),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.goBack),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(SavedValuesController.provider(fieldId).notifier)
                  .removeValue(index);
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showSaveDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.saveCurrentValue),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.valueName,
              hintText: l10n.valueNameHint,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.valueNameRequired;
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.goBack),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ref
                    .read(SavedValuesController.provider(fieldId).notifier)
                    .addValue(SavedFieldValue(
                      name: nameController.text.trim(),
                      value: currentValue,
                    ));
                Navigator.of(ctx).pop();
              }
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
