import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/core/routing/app_router.dart';
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

    final params = ProviderListParams(category: category);
    final providers = ref.watch(ProviderListController.provider(params));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: providers.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.selectProviderDescription,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 14,
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
