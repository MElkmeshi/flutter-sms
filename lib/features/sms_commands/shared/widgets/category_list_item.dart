import 'package:flutter/material.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/domain/model/category.dart';
import 'package:sms/core/utils/icon_mapper.dart';
import 'package:sms/ui/theme/design_tokens.dart';
import 'package:sms/ui/widget/x_card.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryListItem({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final name = isArabic ? category.nameAr : category.nameEn;
    final icon = IconMapper.fromString(category.icon);
    final color = IconMapper.colorFromHex(
      category.color,
      fallback: colorScheme.primary,
    );

    return XCard(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: color, size: AppIconSize.xl),
            ),
            SizedBox(width: AppSpacing.md),

            // Name & provider count
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textTheme.bodyLarge?.copyWith(
                      fontSize: AppFontSize.lg,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    '${category.providers.length} ${l10n.providers}',
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: AppFontSize.sm,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
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
