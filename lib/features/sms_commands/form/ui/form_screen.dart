import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/ui/widget/x_scaffold.dart';
import 'package:sms/ui/widget/x_app_bar.dart';
import 'package:sms/ui/widget/x_card.dart';
import 'package:sms/domain/model/action_item.dart';
import 'package:sms/domain/model/service_provider.dart';
import 'package:sms/features/sms_commands/form/logic/form_controller.dart';
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
}
