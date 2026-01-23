# XIcon

> Consistent icon styling with Lucide Icons.

---

## Purpose

`XIcon` wraps Lucide Icons to:

- Ensure consistent stroke width (1.25) across the app
- Provide default sizing
- Enforce Lucide icon usage (not Material icons)

---

## Source File

`lib/ui/widget/x_icon.dart`

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `icon` | `IconData` | required | Lucide icon data |
| `size` | `double?` | `24` | Icon size |
| `color` | `Color?` | `null` | Icon color (uses onSurface if null) |
| `matchTextDirection` | `bool` | `false` | Mirror icon in RTL languages |

---

## Usage Examples

### Basic Usage

```dart
XIcon(LucideIcons.home)
```

### With Color

```dart
XIcon(
  LucideIcons.heart,
  color: Theme.of(context).colorScheme.primary,
)
```

### With Size

```dart
XIcon(
  LucideIcons.search,
  size: 20,
)
```

### In Navigation

```dart
NavigationDestination(
  icon: XIcon(LucideIcons.house, color: colorScheme.onSurfaceVariant),
  selectedIcon: XIcon(LucideIcons.house, color: colorScheme.primary),
  label: context.t.nav.home,
)
```

### RTL-Aware Directional Icons

For arrows and chevrons that should flip in RTL languages (Arabic):

```dart
// Back button — points left in English, right in Arabic
XIcon(LucideIcons.arrowLeft, matchTextDirection: true)

// Forward chevron — points right in English, left in Arabic
XIcon(LucideIcons.chevronRight, matchTextDirection: true)

// Next arrow
XIcon(LucideIcons.arrowRight, matchTextDirection: true)
```

---

## Common Icons

| Purpose | Icon | Code |
|---------|------|------|
| Home | 🏠 | `LucideIcons.home` |
| Search | 🔍 | `LucideIcons.search` |
| User | 👤 | `LucideIcons.user` |
| Settings | ⚙️ | `LucideIcons.settings` |
| Back | ← | `LucideIcons.arrowLeft` |
| Close | ✕ | `LucideIcons.x` |
| Menu | ☰ | `LucideIcons.menu` |
| Heart | ♥ | `LucideIcons.heart` |
| Shopping Bag | 🛍 | `LucideIcons.shoppingBag` |
| Phone | 📞 | `LucideIcons.phone` |
| Check | ✓ | `LucideIcons.check` |
| Plus | + | `LucideIcons.plus` |
| Trash | 🗑 | `LucideIcons.trash2` |
| Edit | ✏️ | `LucideIcons.pencil` |
| Filter | 🔽 | `LucideIcons.slidersHorizontal` |
| Sort | ↕ | `LucideIcons.arrowUpDown` |

---

## Do/Don't

```dart
// ✅ DO — Use XIcon
XIcon(LucideIcons.home)
XIcon(LucideIcons.search, size: 20)

// ✅ DO — Use matchTextDirection for directional icons
XIcon(LucideIcons.arrowLeft, matchTextDirection: true)
XIcon(LucideIcons.chevronRight, matchTextDirection: true)

// ❌ DON'T — Use raw Icon with LucideIcons
Icon(LucideIcons.home)  // WRONG - inconsistent stroke width

// ❌ DON'T — Forget matchTextDirection on directional icons
XIcon(LucideIcons.arrowLeft)  // WRONG - won't flip in Arabic

// ❌ DON'T — Mix with Material icons
Icon(Icons.home)  // WRONG - use Lucide icons only
```

---

## Implementation

```dart
// lib/ui/widget/x_icon.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class XIcon extends StatelessWidget {
  const XIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.matchTextDirection = false,
  });

  final IconData icon;
  final double? size;
  final Color? color;
  final bool matchTextDirection;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      _toThinVariant(icon),
      size: size ?? 24,
      color: color,
    );

    if (!matchTextDirection) return iconWidget;

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    if (!isRtl) return iconWidget;

    return Transform.scale(scaleX: -1, child: iconWidget);
  }
}
```

---

## Resources

- [Lucide Icon Browser](https://lucide.dev/icons/) — Search all 1600+ icons
- [lucide_icons_flutter package](https://pub.dev/packages/lucide_icons_flutter)
