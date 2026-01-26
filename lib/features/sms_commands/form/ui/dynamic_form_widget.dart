import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/domain/model/input_field.dart';
import 'package:sms/domain/model/action_item.dart';
import 'package:sms/features/sms_commands/form/logic/form_controller.dart';
import 'package:sms/features/sms_commands/form/logic/saved_values_controller.dart';
import 'package:sms/features/sms_commands/form/models/saved_field_value.dart';
import 'package:sms/features/sms_commands/form/ui/saved_values_bottom_sheet.dart';

class DynamicFormWidget extends HookConsumerWidget {
  const DynamicFormWidget({
    super.key,
    required this.fields,
    required this.formParams,
    required this.onSubmit,
    this.actionType = ActionType.sms,
  });

  final List<InputField> fields;
  final FormParams formParams;
  final VoidCallback onSubmit;
  final ActionType actionType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    // Create form key with useMemoized
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Create controllers map - auto-dispose!
    final controllers = useMemoized(
      () => Map.fromEntries(
        fields.map((field) => MapEntry(field.id, TextEditingController())),
      ),
      [fields],
    );

    // Watch form state
    final formState = ref.watch(FormController.provider(formParams));

    // Sync saved values to controllers
    useEffect(() {
      for (final field in fields) {
        final savedValue = formState.formValues[field.id];
        final controller = controllers[field.id];
        if (savedValue != null && controller?.text != savedValue) {
          controller?.text = savedValue;
        }
      }
      return null;
    }, [formState.formValues]);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          // Form Header with Clear Button
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                l10n.formFields,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 16,
                  fontWeight: .bold,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Clear all controllers
                  for (final controller in controllers.values) {
                    controller.clear();
                  }
                  // Clear form values in controller
                  ref.read(FormController.provider(formParams).notifier).clearForm();
                },
                icon: const Icon(Icons.clear, size: 16),
                label: Text(
                  l10n.clearAll,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 12,
                    fontWeight: .w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.error,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Form fields
          ...fields.map((field) {
            final isArabic = Localizations.localeOf(context).languageCode == 'ar';
            final label = isArabic ? field.labelAr : field.labelEn;

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildFormField(
                context,
                ref,
                field,
                label,
                l10n,
                controllers,
                formState.formValues,
                colorScheme,
              ),
            );
          }),

          const SizedBox(height: 32),

          // Submit button
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  onSubmit();
                }
              },
              iconAlignment: IconAlignment.end,
              icon: Icon(actionType == ActionType.ussd ? Icons.phone : Icons.send),
              label: Text(
                actionType == ActionType.ussd ? l10n.dialUssd : l10n.sendSms,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: .bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    BuildContext context,
    WidgetRef ref,
    InputField field,
    String label,
    AppLocalizations l10n,
    Map<String, TextEditingController> controllers,
    Map<String, String> formValues,
    ColorScheme colorScheme,
  ) {
    final hasSavedValue = formValues[field.id]?.isNotEmpty == true;

    return Column(
      crossAxisAlignment: .start,
      children: [
        // Field label with saved indicator
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 14,
                  fontWeight: .w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            if (hasSavedValue)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.primary),
                ),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 12,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.saved,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: .w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Form field
        _buildFieldWidget(
          context,
          ref,
          field,
          label,
          l10n,
          controllers,
          formValues,
          colorScheme,
        ),
      ],
    );
  }

  Widget _buildFieldWidget(
    BuildContext context,
    WidgetRef ref,
    InputField field,
    String label,
    AppLocalizations l10n,
    Map<String, TextEditingController> controllers,
    Map<String, String> formValues,
    ColorScheme colorScheme,
  ) {
    switch (field.type) {
      case 'text':
        final savedValues = ref.watch(SavedValuesController.provider(field.id));

        return Autocomplete<SavedFieldValue>(
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<SavedFieldValue>.empty();
            }
            return savedValues.where((item) =>
              item.value.toLowerCase().contains(textEditingValue.text.toLowerCase())
            );
          },
          displayStringForOption: (option) => option.value,
          onSelected: (selection) {
            controllers[field.id]!.text = selection.value;
            ref
                .read(FormController.provider(formParams).notifier)
                .updateField(field.id, selection.value);
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: AlignmentDirectional.topStart,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        dense: true,
                        title: Text(option.value),
                        subtitle: Text(
                          option.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
            // Sync the autocomplete controller with our controller
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (controllers[field.id]!.text != textController.text) {
                textController.text = controllers[field.id]!.text;
              }
            });

            return TextFormField(
              controller: textController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: l10n.enterField(label),
                prefixIcon: Icon(
                  _getFieldIcon(field.id),
                  color: colorScheme.onSurfaceVariant,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.bookmark_border, size: 20, color: colorScheme.primary),
                  onPressed: () => _handleBookmarkPressed(
                    context, ref, field, label, controllers[field.id]!,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.fieldRequired(label);
                }
                return null;
              },
              onChanged: (value) {
                controllers[field.id]!.text = value;
                ref
                    .read(FormController.provider(formParams).notifier)
                    .updateField(field.id, value);
              },
            );
          },
        );

      case 'dropdown':
        return DropdownButtonFormField<String>(
          initialValue: formValues[field.id]?.isNotEmpty == true
              ? formValues[field.id]
              : null,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(
              _getFieldIcon(field.id),
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          items: field.options?.map((option) {
                final isArabic =
                    Localizations.localeOf(context).languageCode == 'ar';
                final optionLabel = isArabic ? option.labelAr : option.labelEn;
                return DropdownMenuItem(
                  value: option.value,
                  child: Text(optionLabel),
                );
              }).toList() ??
              [],
          validator: (value) {
            if (value == null) {
              return l10n.fieldRequired(label);
            }
            return null;
          },
          onChanged: (value) {
            if (value != null) {
              // Update form values in real-time via controller
              ref
                  .read(FormController.provider(formParams).notifier)
                  .updateField(field.id, value);
            }
          },
        );

      default:
        return const SizedBox();
    }
  }

  void _handleBookmarkPressed(
    BuildContext context,
    WidgetRef ref,
    InputField field,
    String label,
    TextEditingController textController,
  ) {
    final currentValue = textController.text.trim();

    if (currentValue.isNotEmpty) {
      // Field has value - show save dialog with name autocomplete
      _showSaveNameDialog(context, ref, field, label, currentValue);
    } else {
      // Field is empty - show saved values to select from
      _showSavedValuesSheet(context, ref, field, label, textController);
    }
  }

  void _showSavedValuesSheet(
    BuildContext context,
    WidgetRef ref,
    InputField field,
    String label,
    TextEditingController textController,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SavedValuesBottomSheet(
        fieldId: field.id,
        fieldLabel: label,
        onValueSelected: (value) {
          textController.text = value;
          ref
              .read(FormController.provider(formParams).notifier)
              .updateField(field.id, value);
        },
      ),
    );
  }

  void _showSaveNameDialog(
    BuildContext context,
    WidgetRef ref,
    InputField field,
    String label,
    String valueToSave,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.saveCurrentValue),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show the value being saved
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.text_fields, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        valueToSave,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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
                    .read(SavedValuesController.provider(field.id).notifier)
                    .addValue(SavedFieldValue(
                      name: nameController.text.trim(),
                      value: valueToSave,
                    ));
                Navigator.of(ctx).pop();
                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.saved),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  IconData _getFieldIcon(String fieldId) {
    if (fieldId.contains('account')) {
      return Icons.account_balance;
    } else if (fieldId.contains('pin')) {
      return Icons.lock;
    } else if (fieldId.contains('amount')) {
      return Icons.attach_money;
    } else if (fieldId.contains('phone')) {
      return Icons.phone;
    } else {
      return Icons.edit;
    }
  }
}
