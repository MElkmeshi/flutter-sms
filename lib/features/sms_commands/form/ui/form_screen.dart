import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/ui/widget/x_scaffold.dart';
import 'package:sms/ui/widget/x_app_bar.dart';
import 'package:sms/ui/widget/x_card.dart';
import 'package:sms/domain/model/action_item.dart';
import 'package:sms/domain/model/service_provider.dart';
import 'package:sms/domain/model/input_field.dart';
import 'package:sms/features/sms_commands/form/logic/form_controller.dart';
import 'package:sms/features/sms_commands/form/logic/form_state.dart' as form_logic;
import 'package:sms/features/sms_commands/form/logic/saved_values_controller.dart';
import 'package:sms/features/sms_commands/form/models/saved_field_value.dart';
import 'package:sms/features/sms_commands/form/ui/dynamic_form_widget.dart';
import 'package:sms/ui/theme/design_tokens.dart';

@RoutePage()
class FormScreen extends HookConsumerWidget {
  const FormScreen({
    super.key,
    required this.action,
    required this.provider,
  });

  final ActionItem action;
  final ServiceProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final title = isArabic ? action.nameAr : action.nameEn;

    // Watch form state
    final formParams = FormParams(action: action, provider: provider);
    final formState = ref.watch(FormController.provider(formParams));

    return XScaffold(
      resizeToAvoidBottomInset: false,
      appBar: XAppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Preview Section (SMS or USSD)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: XCard(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.primaryContainer.withAlpha(128),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              action.type == ActionType.ussd ? Icons.phone : Icons.sms,
                              color: colorScheme.primary,
                              size: AppIconSize.xl,
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Text(
                              action.type == ActionType.ussd ? l10n.ussdPreview : l10n.smsPreview,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.lg),
                        Container(
                          padding: EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: colorScheme.outline,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (action.type != ActionType.ussd) ...[
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: AppIconSize.sm,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    SizedBox(width: AppSpacing.sm),
                                    Text(
                                      'To: ${action.smsNumber}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSpacing.sm),
                              ],
                              Text(
                                formState.previewMessage,
                                textDirection: TextDirection.ltr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Form Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  XCard(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: DynamicFormWidget(
                        fields: action.fields,
                        formParams: formParams,
                        actionType: action.type,
                        onSubmit: () async {
                          // Send SMS or dial USSD based on action type
                          final bool success;
                          if (action.type == ActionType.ussd) {
                            success = await ref
                                .read(FormController.provider(formParams).notifier)
                                .dialUssd();
                          } else {
                            success = await ref
                                .read(FormController.provider(formParams).notifier)
                                .sendSms();
                          }

                          if (context.mounted) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: colorScheme.onPrimary,
                                      ),
                                      SizedBox(width: AppSpacing.sm),
                                      Text(action.type == ActionType.ussd
                                          ? l10n.ussdDialerOpenedSuccess
                                          : l10n.smsAppOpenedSuccess),
                                    ],
                                  ),
                                  backgroundColor: colorScheme.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                  ),
                                ),
                              );

                              // Show auto-save prompt for new values
                              _showAutoSavePrompt(
                                context,
                                ref,
                                formState,
                                action,
                                l10n,
                                colorScheme,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.error,
                                        color: colorScheme.onError,
                                      ),
                                      SizedBox(width: AppSpacing.sm),
                                      Text(action.type == ActionType.ussd
                                          ? l10n.ussdDialerFailed
                                          : l10n.smsAppFailed),
                                    ],
                                  ),
                                  backgroundColor: colorScheme.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: AppSpacing.xxl + MediaQuery.of(context).viewInsets.bottom,
            ),
          ),
        ],
      ),
    );
  }

  void _showAutoSavePrompt(
    BuildContext context,
    WidgetRef ref,
    form_logic.FormState formState,
    ActionItem action,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    // Only process text fields with non-empty values
    final fieldsToSave = <InputField>[];

    for (final field in action.fields) {
      if (field.type != 'text') continue;

      final value = formState.formValues[field.id];
      if (value == null || value.trim().isEmpty) continue;

      // Check if this value already exists in saved values
      final savedValues = ref.read(SavedValuesController.provider(field.id));
      final alreadyExists = savedValues.any((saved) => saved.value == value);

      if (!alreadyExists) {
        fieldsToSave.add(field);
      }
    }

    // If no new values to save, return
    if (fieldsToSave.isEmpty) return;

    // Show auto-save prompt for each field with delay between prompts
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (context.mounted) {
        _showAutoSavePromptForField(
          context,
          ref,
          formState,
          fieldsToSave,
          0,
          l10n,
          colorScheme,
        );
      }
    });
  }

  void _showAutoSavePromptForField(
    BuildContext context,
    WidgetRef ref,
    form_logic.FormState formState,
    List<InputField> fieldsToSave,
    int currentIndex,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    if (currentIndex >= fieldsToSave.length || !context.mounted) return;

    final field = fieldsToSave[currentIndex];
    final value = formState.formValues[field.id]!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final fieldLabel = isArabic ? field.labelAr : field.labelEn;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.saveValuePrompt(fieldLabel)),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: colorScheme.primary, width: 1),
        ),
        action: SnackBarAction(
          label: l10n.save,
          textColor: colorScheme.primary,
          onPressed: () {
            // Auto-generate name with timestamp
            final now = DateTime.now();
            final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
            final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
            final autoName = '$fieldLabel - $dateStr $timeStr';

            // Save the value
            ref.read(SavedValuesController.provider(field.id).notifier).addValue(
              SavedFieldValue(
                name: autoName,
                value: value,
                lastUsed: now,
                usageCount: 1,
              ),
            );

            // Show confirmation
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: colorScheme.onPrimary),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(l10n.valueSaved)),
                    ],
                  ),
                  duration: const Duration(seconds: 2),
                  backgroundColor: colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              );
            }

            // Show next prompt after a delay
            if (currentIndex + 1 < fieldsToSave.length) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (context.mounted) {
                  _showAutoSavePromptForField(
                    context,
                    ref,
                    formState,
                    fieldsToSave,
                    currentIndex + 1,
                    l10n,
                    colorScheme,
                  );
                }
              });
            }
          },
        ),
      ),
    ).closed.then((_) {
      // If user dismissed without saving, show next prompt
      if (currentIndex + 1 < fieldsToSave.length && context.mounted) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            _showAutoSavePromptForField(
              context,
              ref,
              formState,
              fieldsToSave,
              currentIndex + 1,
              l10n,
              colorScheme,
            );
          }
        });
      }
    });
  }
}
