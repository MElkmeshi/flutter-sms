import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/core/routing/app_router.dart';
import 'package:sms/ui/widget/x_scaffold.dart';
import 'package:sms/ui/widget/x_app_bar.dart';
import 'package:sms/domain/model/category.dart';
import 'package:sms/features/sms_commands/provider_list/logic/provider_list_controller.dart';
import 'package:sms/features/sms_commands/shared/widgets/provider_list_item.dart';

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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final categoryName = isArabic ? category.nameAr : category.nameEn;

    // Watch providers from controller
    final params = ProviderListParams(category: category);
    final providers = ref.watch(ProviderListController.provider(params));

    return XScaffold(
      appBar: XAppBar(
        title: Text(
          l10n.selectProvider,
          style: const TextStyle(fontWeight: .bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        categoryName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: .bold,
                              color: colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.selectProvider,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: .bold,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.selectProviderDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final provider = providers[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: ProviderListItem(
                        provider: provider,
                        onTap: () {
                          context.router.push(
                            ActionListRoute(
                              provider: provider,
                              category: category,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                childCount: providers.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
