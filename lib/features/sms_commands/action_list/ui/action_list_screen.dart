import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sms/core/routing/app_router.dart';
import 'package:sms/ui/widget/x_scaffold.dart';
import 'package:sms/ui/widget/x_app_bar.dart';
import 'package:sms/domain/model/category.dart';
import 'package:sms/domain/model/service_provider.dart';
import 'package:sms/features/sms_commands/action_list/logic/action_list_controller.dart';
import 'package:sms/features/sms_commands/shared/widgets/action_list_item.dart';

@RoutePage()
class ActionListScreen extends HookConsumerWidget {
  const ActionListScreen({
    super.key,
    required this.provider,
    required this.category,
  });

  final ServiceProvider provider;
  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final providerName = isArabic ? provider.nameAr : provider.nameEn;

    // Watch actions from controller
    final params = ActionListParams(provider: provider);
    final actions = ref.watch(ActionListController.provider(params));

    return XScaffold(
      appBar: XAppBar(
        title: Text(providerName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ActionListItem(
              action: action,
              onTap: () {
                context.router.push(
                  FormRoute(
                    action: action,
                    provider: provider,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
