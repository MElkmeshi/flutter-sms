import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/core/routing/app_router.dart';
import 'package:sms/core/initializer/app_providers.dart';
import 'package:sms/core/services/config_service.dart';
import 'package:sms/features/sms_commands/category_list/logic/category_list_controller.dart';
import 'package:sms/features/sms_commands/shared/widgets/category_list_item.dart';
import 'package:sms/ui/theme/design_tokens.dart';
import 'package:sms/ui/widget/x_scaffold.dart';
import 'package:sms/ui/widget/x_app_bar.dart';

@RoutePage()
class CategoryListScreen extends HookConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final categoriesAsync = ref.watch(CategoryListController.provider);

    return XScaffold(
      appBar: XAppBar(
        title: GestureDetector(
          onLongPress: () => _showConfigUrlDialog(context, ref),
          child: Text(l10n.appTitle),
        ),
        actions: [
          TextButton(
            onPressed: () => ref.read(localeProvider.notifier).toggle(),
            child: Text(
              ref.watch(localeProvider) == 'ar' ? 'EN' : 'ع',
              style: textTheme.bodyMedium?.copyWith(
                fontSize: AppFontSize.md,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              ref.watch(themeModeProvider)
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            ),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context, l10n),
          ),
        ],
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildErrorState(context, error.toString(), ref, l10n),
        data: (categories) => ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          itemCount: categories.length + 1,
          separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  l10n.selectCategoryDescription,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: AppFontSize.md,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }
            final category = categories[index - 1];
            return CategoryListItem(
              category: category,
              onTap: () {
                context.router.push(ProviderListRoute(category: category));
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String errorMessage,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: AppIconSize.xxl, color: colorScheme.error),
            SizedBox(height: AppSpacing.lg),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: AppFontSize.md,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSpacing.xxl),
            FilledButton.icon(
              onPressed: () {
                ref.read(CategoryListController.provider.notifier).refresh();
              },
              icon: Icon(Icons.refresh, size: AppIconSize.md),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfigUrlDialog(BuildContext context, WidgetRef ref) {
    final configService = ref.read(configServiceProvider);
    final controller = TextEditingController(text: configService.getConfigUrl());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Config URL'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter config URL'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.text = ConfigService.defaultConfigUrl;
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await configService.setConfigUrl(controller.text.trim());
              if (context.mounted) Navigator.pop(context);
              ref.read(CategoryListController.provider.notifier).refresh();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.about),
        content: Text(l10n.aboutDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
