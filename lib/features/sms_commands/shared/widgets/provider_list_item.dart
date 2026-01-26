import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/domain/model/service_provider.dart';
import 'package:sms/core/utils/icon_mapper.dart';

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

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Image or Icon
              _buildProviderImage(provider.image, icon, color),
              const SizedBox(width: 14),

              // Name, description & action count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: _getTextStyle(
                        isArabic: isArabic,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _getTextStyle(
                          isArabic: isArabic,
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      '${provider.actions.length} ${l10n.actions}',
                      style: _getTextStyle(
                        isArabic: isArabic,
                        fontSize: 12,
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
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProviderImage(String? image, IconData icon, Color color) {
    const double size = 44;
    const double iconSize = 24;

    if (image != null && image.isNotEmpty) {
      final isSvg = image.toLowerCase().endsWith('.svg');

      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: _buildImageWidget(image, isSvg, icon, color, iconSize),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
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

  TextStyle _getTextStyle({
    required bool isArabic,
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'IBMPlexSansArabic',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
