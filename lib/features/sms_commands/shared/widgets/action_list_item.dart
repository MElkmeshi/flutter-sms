import 'package:flutter/material.dart';
import 'package:sms/domain/model/action_item.dart';
import 'package:sms/ui/theme/design_tokens.dart';
import 'package:sms/ui/widget/x_card.dart';

class ActionListItem extends StatelessWidget {
  final ActionItem action;
  final VoidCallback onTap;

  const ActionListItem({super.key, required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final name = isArabic ? action.nameAr : action.nameEn;

    return XCard(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: textTheme.bodyLarge?.copyWith(
                  fontSize: AppFontSize.lg,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: colorScheme.onSurfaceVariant,
              size: AppIconSize.sm,
            ),
          ],
        ),
      ),
    );
  }
}
