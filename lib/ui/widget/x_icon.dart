import 'package:flutter/material.dart';

/// Material 3 wrapper for Icon with consistent sizing and theme colors
class XIcon extends StatelessWidget {
  const XIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Icon(
      icon,
      size: size ?? 24,
      color: color ?? colorScheme.onSurface,
      semanticLabel: semanticLabel,
    );
  }
}
