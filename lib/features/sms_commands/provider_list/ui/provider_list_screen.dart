import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/core/routing/app_router.dart';
import 'package:sms/domain/model/category.dart';
import 'package:sms/features/sms_commands/provider_list/logic/provider_list_controller.dart';
import 'package:sms/features/sms_commands/shared/widgets/provider_list_item.dart';
import 'package:sms/ui/theme/design_tokens.dart';
import 'package:sms/ui/widget/x_scaffold.dart';
import 'package:sms/ui/widget/x_app_bar.dart';

@RoutePage()
class ProviderListScreen extends HookConsumerWidget {
  const ProviderListScreen({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final categoryName = isArabic ? category.nameAr : category.nameEn;

    final params = ProviderListParams(category: category);
    final providers = ref.watch(ProviderListController.provider(params));

    return XScaffold(
      appBar: XAppBar(
        title: Text(categoryName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        itemCount: providers.length + 1,
        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                l10n.selectProviderDescription,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: AppFontSize.md,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }
          final provider = providers[index - 1];
          return ProviderListItem(
            provider: provider,
            onTap: () {
              context.router.push(
                ActionListRoute(
                  provider: provider,
                  category: category,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
