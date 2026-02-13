import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/domain/model/input_field.dart';
import 'package:sms/domain/model/action_item.dart';
import 'package:sms/features/sms_commands/form/logic/form_controller.dart';
import 'package:sms/features/sms_commands/form/logic/saved_values_controller.dart';
import 'package:sms/features/sms_commands/form/models/saved_field_value.dart';
import 'package:sms/features/sms_commands/form/ui/saved_values_bottom_sheet.dart';
import 'package:sms/ui/theme/design_tokens.dart';

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
    final textTheme = Theme.of(context).textTheme;

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

    // Check if there are any values to clear
    final hasValuesToClear = formState.formValues.values.any((value) => value.isNotEmpty);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form Header with Clear Button - only show if there are fields
          if (fields.isNotEmpty) ...[
            SizedBox(
              height: 40, // Fixed height to prevent layout shift
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    l10n.formFields,
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: AppFontSize.xl,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (hasValuesToClear)
                    TextButton.icon(
                      onPressed: () {
                        // Clear all controllers
                        for (final controller in controllers.values) {
                          controller.clear();
                        }
                        // Clear form values in controller
                        ref.read(FormController.provider(formParams).notifier).clearForm();
                      },
                      icon: Icon(Icons.clear, size: AppIconSize.sm),
                      label: Text(
                        l10n.clearAll,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: AppFontSize.sm,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
          ],

          // Form fields
          ...fields.map((field) {
            final isArabic = Localizations.localeOf(context).languageCode == 'ar';
            final label = isArabic ? field.labelAr : field.labelEn;

            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xl),
              child: _buildFormField(
                context,
                ref,
                field,
                label,
                l10n,
                controllers,
                formState.formValues,
                colorScheme,
                textTheme,
              ),
            );
          }),

          SizedBox(height: AppSpacing.xxxl),

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
                style: TextStyle(
                  fontSize: AppFontSize.xl,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
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
    TextTheme textTheme,
  ) {
    final hasSavedValue = formValues[field.id]?.isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label with saved indicator
        SizedBox(
          height: 24, // Fixed height to prevent layout shift
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: AppFontSize.md,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (hasSavedValue)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: colorScheme.primary),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: AppIconSize.xs,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        l10n.saved,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: AppFontSize.xs,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.sm),

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
        return _TextFieldWithDropdown(
          field: field,
          label: label,
          controller: controllers[field.id]!,
          formParams: formParams,
          l10n: l10n,
          colorScheme: colorScheme,
          onBookmarkPressed: () => _handleBookmarkPressed(
            context, ref, field, label, controllers[field.id]!,
          ),
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
    final savedValues = ref.read(SavedValuesController.provider(field.id));
    final isValueNew = currentValue.isNotEmpty &&
        !savedValues.any((saved) => saved.value == currentValue);

    if (isValueNew) {
      // Show save dialog for new value
      _showSaveNewValueDialog(context, ref, field, label, currentValue);
    } else {
      // Show saved values management sheet
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
      backgroundColor: Colors.transparent,
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

  void _showSaveNewValueDialog(
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
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    Icon(Icons.text_fields, size: AppIconSize.md, color: colorScheme.primary),
                    SizedBox(width: AppSpacing.sm),
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
              SizedBox(height: AppSpacing.lg),
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

/// Text field with saved values dropdown on focus.
/// Uses CompositedTransformTarget/Follower + Overlay so the dropdown
/// renders above all other content and updates as the user types.
class _TextFieldWithDropdown extends HookConsumerWidget {
  const _TextFieldWithDropdown({
    required this.field,
    required this.label,
    required this.controller,
    required this.formParams,
    required this.l10n,
    required this.colorScheme,
    required this.onBookmarkPressed,
  });

  final InputField field;
  final String label;
  final TextEditingController controller;
  final FormParams formParams;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final VoidCallback onBookmarkPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final layerLink = useMemoized(() => LayerLink());
    final overlayEntry = useRef<OverlayEntry?>(null);
    final currentText = useState(controller.text);

    // Helper to rebuild the overlay when text or saved values change
    void updateOverlay() {
      overlayEntry.value?.markNeedsBuild();
    }

    // Show/hide overlay on focus changes
    useEffect(() {
      void listener() {
        if (focusNode.hasFocus) {
          _showOverlay(context, ref, layerLink, overlayEntry, currentText, updateOverlay);
        } else {
          _hideOverlay(overlayEntry);
        }
      }
      focusNode.addListener(listener);
      return () {
        focusNode.removeListener(listener);
        _hideOverlay(overlayEntry);
      };
    }, [focusNode]);

    // Listen to text changes and update overlay
    useEffect(() {
      void listener() {
        currentText.value = controller.text;
        updateOverlay();
      }
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    // Rebuild overlay when saved values change
    final savedValues = ref.watch(SavedValuesController.provider(field.id));
    useEffect(() {
      updateOverlay();
      return null;
    }, [savedValues]);

    // Determine if current value is new (not saved)
    final currentValue = controller.text.trim();
    final isValueNew = currentValue.isNotEmpty &&
        !savedValues.any((saved) => saved.value == currentValue);

    return CompositedTransformTarget(
      link: layerLink,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enableInteractiveSelection: true,
        canRequestFocus: true,
        decoration: InputDecoration(
          hintText: l10n.enterField(label),
          prefixIcon: Icon(
            _getFieldIcon(field.id),
            color: colorScheme.onSurfaceVariant,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isValueNew ? Icons.add : Icons.bookmark_border,
              size: AppIconSize.lg,
              color: colorScheme.primary,
            ),
            onPressed: onBookmarkPressed,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return l10n.fieldRequired(label);
          }
          return null;
        },
        onChanged: (value) {
          ref
              .read(FormController.provider(formParams).notifier)
              .updateField(field.id, value);
        },
      ),
    );
  }

  void _showOverlay(
    BuildContext context,
    WidgetRef ref,
    LayerLink layerLink,
    ObjectRef<OverlayEntry?> overlayEntry,
    ValueNotifier<String> currentText,
    VoidCallback onUpdate,
  ) {
    _hideOverlay(overlayEntry);

    final overlay = Overlay.of(context);
    final textTheme = Theme.of(context).textTheme;

    overlayEntry.value = OverlayEntry(
      builder: (overlayContext) {
        final savedValuesNotifier =
            ref.read(SavedValuesController.provider(field.id).notifier);
        final filteredValues =
            savedValuesNotifier.searchValues(currentText.value);

        return Positioned(
          width: _getFieldWidth(context),
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 60),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (filteredValues.isNotEmpty) ...[
                      Flexible(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.xs),
                          shrinkWrap: true,
                          itemCount: filteredValues.length,
                          itemBuilder: (context, index) {
                            final value = filteredValues[index];
                            return InkWell(
                              onTap: () {
                                controller.text = value.value;
                                ref
                                    .read(FormController.provider(formParams)
                                        .notifier)
                                    .updateField(field.id, value.value);
                                final savedValues = ref.read(
                                    SavedValuesController.provider(field.id));
                                final idx = savedValues.indexOf(value);
                                if (idx >= 0) {
                                  ref
                                      .read(SavedValuesController.provider(
                                              field.id)
                                          .notifier)
                                      .updateUsage(idx);
                                }
                                FocusScope.of(context).unfocus();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.bookmark,
                                          size: AppIconSize.sm,
                                          color: colorScheme.primary,
                                        ),
                                        SizedBox(width: AppSpacing.sm),
                                        Expanded(
                                          child: Text(
                                            value.name,
                                            style: textTheme.bodyMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  colorScheme.onSurface,
                                            ),
                                            overflow:
                                                TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (value.usageCount > 0)
                                          Container(
                                            padding:
                                                EdgeInsets.symmetric(
                                              horizontal: AppSpacing.xs,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: colorScheme
                                                  .primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppRadius.sm / 2),
                                            ),
                                            child: Text(
                                              '${value.usageCount}',
                                              style: textTheme.bodySmall
                                                  ?.copyWith(
                                                fontSize: AppFontSize.xs,
                                                color:
                                                    colorScheme.primary,
                                                fontWeight:
                                                    FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: AppSpacing.xs / 2),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: AppIconSize.sm +
                                              AppSpacing.sm),
                                      child: Text(
                                        value.value,
                                        style: textTheme.bodySmall
                                            ?.copyWith(
                                          color: colorScheme
                                              .onSurfaceVariant,
                                        ),
                                        overflow:
                                            TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(
                          height: 1,
                          color: colorScheme.outline
                              .withValues(alpha: 0.2)),
                    ] else if (currentText.value.isEmpty) ...[
                      Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Center(
                          child: Text(
                            l10n.noSavedValues,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                          height: 1,
                          color: colorScheme.outline
                              .withValues(alpha: 0.2)),
                    ],
                    // Footer: Manage button
                    Padding(
                      padding: EdgeInsets.all(AppSpacing.xs),
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          onBookmarkPressed();
                        },
                        borderRadius:
                            BorderRadius.circular(AppRadius.sm),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.sm,
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.settings,
                                size: AppIconSize.sm,
                                color: colorScheme.primary,
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Text(
                                l10n.manageSavedValues,
                                style:
                                    textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry.value!);
  }

  void _hideOverlay(ObjectRef<OverlayEntry?> overlayEntry) {
    overlayEntry.value?.remove();
    overlayEntry.value = null;
  }

  double _getFieldWidth(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? MediaQuery.of(context).size.width - 40;
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
