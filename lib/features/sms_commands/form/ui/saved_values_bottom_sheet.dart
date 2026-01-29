import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/features/sms_commands/form/logic/saved_values_controller.dart';
import 'package:sms/features/sms_commands/form/models/saved_field_value.dart';
import 'package:sms/ui/theme/design_tokens.dart';

class SavedValuesBottomSheet extends HookConsumerWidget {
  const SavedValuesBottomSheet({
    super.key,
    required this.fieldId,
    required this.fieldLabel,
    required this.onValueSelected,
  });

  final String fieldId;
  final String fieldLabel;
  final ValueChanged<String> onValueSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final savedValues = ref.watch(SavedValuesController.provider(fieldId));

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSpacing.sm),
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
                SizedBox(height: AppSpacing.lg),
              // Title
              Text(
                '${l10n.savedValues} - $fieldLabel',
                style: textTheme.titleMedium?.copyWith(
                  fontSize: AppFontSize.xxl,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              // List or empty state
              Expanded(
                child: savedValues.isEmpty
                    ? _buildEmptyState(context, l10n, colorScheme, textTheme)
                    : _buildValuesList(
                        context, ref, savedValues, colorScheme, l10n, scrollController, textTheme),
              ),
              // Add new value button
              SizedBox(height: AppSpacing.sm),
              SafeArea(
                child: FilledButton.icon(
                  onPressed: () => _showAddValueDialog(context, ref, l10n, colorScheme),
                  icon: Icon(Icons.add, size: AppIconSize.md),
                  label: Text(
                    l10n.addNewValue,
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: AppIconSize.xxl,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            l10n.noSavedValues,
            style: textTheme.titleMedium?.copyWith(
              fontSize: AppFontSize.xl,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            l10n.noSavedValuesHint,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              fontSize: AppFontSize.sm + 1,
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
    TextTheme textTheme,
  ) {
    return ListView.separated(
      controller: scrollController,
      itemCount: values.length,
      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final item = values[index];
        return Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
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
                size: AppIconSize.md,
              ),
            ),
            title: Text(
              item.name,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              item.value,
              style: textTheme.bodySmall?.copyWith(
                fontSize: AppFontSize.sm + 1,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: colorScheme.error,
                size: AppIconSize.lg,
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

  void _showAddValueDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addNewValue),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
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
              SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: valueController,
                decoration: InputDecoration(
                  labelText: l10n.value,
                  hintText: l10n.enterField(fieldLabel),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.fieldRequired(l10n.value);
                  }
                  return null;
                },
              ),
            ],
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
                      value: valueController.text.trim(),
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
