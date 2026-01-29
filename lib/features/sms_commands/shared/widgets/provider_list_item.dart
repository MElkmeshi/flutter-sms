import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/domain/model/service_provider.dart';
import 'package:sms/core/utils/icon_mapper.dart';
import 'package:sms/ui/theme/design_tokens.dart';
import 'package:sms/ui/widget/x_card.dart';

class ProviderListItem extends StatelessWidget {
  final ServiceProvider provider;
  final VoidCallback onTap;

  const ProviderListItem({
    super.key,
    required this.provider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final name = isArabic ? provider.nameAr : provider.nameEn;
    final description = isArabic
        ? provider.descriptionAr
        : provider.descriptionEn;
    final icon = IconMapper.fromString(provider.icon, fallback: Icons.business);
    final color = IconMapper.colorFromHex(
      provider.color,
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
            // Image or Icon
            _buildProviderImage(provider.image, icon, color, colorScheme),
            SizedBox(width: AppSpacing.md),

            // Name, description & action count
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
                  if (description != null) ...[
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: AppFontSize.sm,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    '${provider.actions.length} ${l10n.actions}',
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

  Widget _buildProviderImage(
    String? image,
    IconData icon,
    Color color,
    ColorScheme colorScheme,
  ) {
    const double size = 44;
    const double iconSize = AppIconSize.xl;

    if (image != null && image.isNotEmpty) {
      final isSvg = image.toLowerCase().endsWith('.svg');

      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: colorScheme.surface,
          border: Border.all(color: colorScheme.outline, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xs),
          child: _buildImageWidget(image, isSvg, icon, color, iconSize),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }

  Widget _buildImageWidget(
    String image,
    bool isSvg,
    IconData icon,
    Color color,
    double iconSize,
  ) {
    if (image.startsWith('http')) {
      if (isSvg) {
        return SvgPicture.network(
          image,
          fit: BoxFit.contain,
          placeholderBuilder: (context) =>
              _buildIconFallback(icon, color, iconSize),
        );
      }
      return Image.network(
        image,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            _buildIconFallback(icon, color, iconSize),
      );
    }

    if (isSvg) {
      return SvgPicture.asset(
        image,
        fit: BoxFit.contain,
        placeholderBuilder: (context) =>
            _buildIconFallback(icon, color, iconSize),
      );
    }

    return Image.asset(
      image,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          _buildIconFallback(icon, color, iconSize),
    );
  }

  Widget _buildIconFallback(IconData icon, Color color, double size) {
    return Center(
      child: Icon(icon, color: color, size: size),
    );
  }
}
