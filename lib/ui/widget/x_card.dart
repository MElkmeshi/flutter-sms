import 'package:flutter/material.dart';
import 'package:sms/ui/theme/design_tokens.dart';

/// Material 3 wrapper for Card with consistent elevation and shape
class XCard extends StatelessWidget {
  const XCard({
    super.key,
    required this.child,
    this.color,
    this.elevation,
    this.margin,
    this.shape,
    this.clipBehavior,
    this.onTap,
  });

  final Widget child;
  final Color? color;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final card = Card(
      color: color ?? colorScheme.surfaceContainerLow,
      elevation: elevation ?? 1,
      margin: margin,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: card,
      );
    }

    return card;
  }
}
