import 'package:flutter/material.dart';
import 'package:sms/ui/theme/design_tokens.dart';

/// Material 3 wrapper for Container with theme-aware colors and styling
class XContainer extends StatelessWidget {
  const XContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.alignment,
    this.constraints,
  });

  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      constraints: constraints,
      decoration: decoration ??
          (color != null
              ? BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                )
              : BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                )),
      child: child,
    );
  }
}
