import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/core/routing/app_router.dart';
import 'package:sms/core/initializer/app_providers.dart';
import 'package:sms/core/services/config_service.dart';
import 'package:sms/features/sms_commands/category_list/logic/category_list_controller.dart';
import 'package:sms/features/sms_commands/shared/widgets/category_list_item.dart';

@RoutePage()
class CategoryListScreen extends HookConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final categoriesAsync = ref.watch(CategoryListController.provider);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: () => _showConfigUrlDialog(context, ref),
          child: Text(
            l10n.appTitle,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: categories.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l10n.selectCategoryDescription,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 14,
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ref.read(CategoryListController.provider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh, size: 18),
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
