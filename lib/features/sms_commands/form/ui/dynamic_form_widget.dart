import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/domain/model/input_field.dart';
import 'package:sms/features/sms_commands/form/logic/form_controller.dart';

class DynamicFormWidget extends HookConsumerWidget {
  const DynamicFormWidget({
    super.key,
    required this.fields,
    required this.formParams,
    required this.onSubmit,
  });

  final List<InputField> fields;
  final FormParams formParams;
  final VoidCallback onSubmit;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form Header with Clear Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.formFields,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
                    fontWeight: FontWeight.w500,
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
              icon: const Icon(Icons.send),
              label: Text(
                l10n.sendSms,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label with saved indicator
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
                  mainAxisSize: MainAxisSize.min,
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
                        fontWeight: FontWeight.w600,
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
        return TextFormField(
          controller: controllers[field.id],
          decoration: InputDecoration(
            labelText: label,
            hintText: l10n.enterField(label),
            prefixIcon: Icon(
              _getFieldIcon(field.id),
              color: colorScheme.onSurfaceVariant,
            ),
            suffixIcon: formValues[field.id]?.isNotEmpty == true
                ? Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    size: 20,
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.fieldRequired(label);
            }
            return null;
          },
          onChanged: (value) {
            // Update form values in real-time via controller
            ref
                .read(FormController.provider(formParams).notifier)
                .updateField(field.id, value);
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
