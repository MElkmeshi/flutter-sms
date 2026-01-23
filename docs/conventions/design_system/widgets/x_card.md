# XCard

> Material 3 outlined card with theme-based styling.

---

## Purpose

`XCard` wraps Flutter's `Card.outlined` to:

- Use M3 outlined card variant (flat with border)
- Border color from `ColorScheme.outline` (reusable across all outlined components)
- Background and elevation from `CardTheme`

---

## Source File

`lib/ui/widget/x_card.dart`

---

## Hard Rules

| Rule | Correct | Wrong |
|------|---------|-------|
| **Border color** | `ColorScheme.outline` in `app_colors.dart` | Hardcode in `CardTheme` or widget |
| **Card background** | `ColorScheme.surface` (M3 default) | Hardcode in `CardTheme` |
| **Card elevation** | M3 default (0 for outlined) | Hardcode in `CardTheme` |

**All card styling comes from `ColorScheme`. No `CardTheme` needed.**

- Border: `ColorScheme.outline` (reusable across cards, buttons, text fields)
- Background: `ColorScheme.surface` (M3 default for `Card.outlined`)
- Elevation: 0 (M3 default for `Card.outlined`)

---

## Theme Configuration

```dart
// lib/ui/theme/app_colors.dart

static const Color outline = Color(0xFFD1D5DC);  // #D1D5DC

static ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: primary,
  surface: const Color(0xFFFFFFFF),  // Card background (white)
  outline: outline,                   // Card border, OutlinedButton, TextField, etc.
  outlineVariant: outline,
);
```

**No `CardTheme` needed** - Material 3 defaults handle everything via `ColorScheme`.

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `child` | `Widget` | required | Card content |
| `padding` | `EdgeInsetsGeometry?` | `null` | Inner padding |
| `margin` | `EdgeInsetsGeometry?` | `EdgeInsets.zero` | Outer margin |
| `color` | `Color?` | from theme | Override background (prefer theme) |
| `onTap` | `VoidCallback?` | `null` | Tap handler |
| `borderRadius` | `BorderRadius?` | from theme | Override radius (prefer theme) |
| `clipBehavior` | `Clip` | `Clip.antiAlias` | Clip behavior |

---

## Usage Examples

### Basic Usage

```dart
XCard(
  padding: EdgeInsets.all(context.spacing.md),
  child: Text('Card content'),
)
```

### Tappable Card

```dart
XCard(
  onTap: () => context.router.push(DetailRoute()),
  padding: EdgeInsets.all(context.spacing.md),
  child: Row(
    children: [
      XIcon(LucideIcons.package),
      SizedBox(width: context.spacing.sm),
      Text('Tap me'),
    ],
  ),
)
```

---

## Do/Don't

```dart
// ✅ DO — Use XCard, styling comes from ColorScheme
XCard(
  padding: EdgeInsets.all(context.spacing.md),
  child: content,
)

// ✅ DO — Set colors in ColorScheme (reusable!)
static ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: primary,
  surface: Color(0xFFFFFFFF),  // Card background
  outline: Color(0xFFD1D5DC),  // All outlined components use this
);

// ❌ DON'T — Use CardTheme for styling
cardTheme: CardThemeData(
  color: Colors.white,  // WRONG - use ColorScheme.surface
  shape: RoundedRectangleBorder(
    side: BorderSide(...),  // WRONG - use ColorScheme.outline
  ),
)

// ❌ DON'T — Use raw Card or Card.outlined
Card.outlined(child: content)  // WRONG - use XCard
```

---

## Implementation

```dart
// lib/ui/widget/x_card.dart

import 'package:flutter/material.dart';

class XCard extends StatelessWidget {
  const XCard({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.color,
    this.onTap,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    var content = child;

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    // Card.outlined uses ColorScheme.outline for border
    final card = Card.outlined(
      color: color,
      margin: margin ?? EdgeInsets.zero,
      clipBehavior: clipBehavior,
      shape: borderRadius != null
          ? RoundedRectangleBorder(borderRadius: borderRadius!)
          : null,
      child: content,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: card,
      );
    }

    return card;
  }
}
```
