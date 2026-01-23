# XContainer

> Theme-aware container wrapper.

---

## Purpose

`XContainer` wraps Flutter's `Container` to:

- Enforce theme-based colors (no hardcoded values)
- Use consistent border radius from theme
- Encourage spacing via `context.spacing`

---

## Source File

`lib/ui/widget/x_container.dart`

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `child` | `Widget?` | - | Child widget |
| `color` | `Color?` | `null` | Background color (use ColorScheme) |
| `padding` | `EdgeInsetsGeometry?` | `null` | Inner padding |
| `margin` | `EdgeInsetsGeometry?` | `null` | Outer margin |
| `borderRadius` | `BorderRadius?` | `null` | Corner radius |
| `width` | `double?` | `null` | Fixed width |
| `height` | `double?` | `null` | Fixed height |
| `constraints` | `BoxConstraints?` | `null` | Size constraints |
| `decoration` | `BoxDecoration?` | `null` | Custom decoration |

---

## Usage Examples

### Basic Usage

```dart
XContainer(
  padding: EdgeInsets.all(context.spacing.md),
  child: Text('Hello'),
)
```

### With Theme Color

```dart
XContainer(
  color: Theme.of(context).colorScheme.surfaceContainerHighest,
  padding: EdgeInsets.all(context.spacing.md),
  borderRadius: BorderRadius.circular(12),
  child: Text('Card-like container'),
)
```

### With Constraints

```dart
XContainer(
  width: double.infinity,
  height: 200,
  padding: EdgeInsets.all(context.spacing.lg),
  child: content,
)
```

---

## Do/Don't

```dart
// ✅ DO — Use theme colors
XContainer(
  color: colorScheme.surfaceContainerLow,
  child: content,
)

// ❌ DON'T — Hardcode colors
XContainer(
  color: Color(0xFFF5F5F5),  // WRONG
  child: content,
)

// ✅ DO — Use context.spacing
XContainer(
  padding: EdgeInsets.all(context.spacing.md),
)

// ❌ DON'T — Hardcode padding
XContainer(
  padding: EdgeInsets.all(16),  // WRONG - use context.spacing.md
)
```

---

## Implementation

```dart
// lib/ui/widget/x_container.dart

import 'package:flutter/material.dart';

class XContainer extends StatelessWidget {
  const XContainer({
    super.key,
    this.child,
    this.color,
    this.padding,
    this.margin,
    this.borderRadius,
    this.width,
    this.height,
    this.constraints,
    this.decoration,
  });

  final Widget? child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      constraints: constraints,
      decoration: decoration ??
          (color != null || borderRadius != null
              ? BoxDecoration(
                  color: color,
                  borderRadius: borderRadius,
                )
              : null),
      child: child,
    );
  }
}
```
