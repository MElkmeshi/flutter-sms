# Lucide Icons Flutter

## Package

```yaml
lucide_icons_flutter: ^3.1.9
```

## Overview

This project uses `lucide_icons_flutter` for all icons. This package provides font-based Lucide icons with multiple stroke width variants.

**Website:** https://lucide.dev/

## Stroke Width

The app uses a stroke width of approximately **1.25** (thin icons).

This is achieved by using the `Lucide200` font family which corresponds to stroke width 1.0 (the closest available to 1.25).

### Available Stroke Widths

| Font Family | Stroke Width |
|-------------|--------------|
| `Lucide` (default) | 2.0 |
| `Lucide100` | 0.5 |
| `Lucide200` | 1.0 |
| `Lucide300` | 1.5 |
| `Lucide400` | 2.0 |
| `Lucide500` | 2.5 |
| `Lucide600` | 3.0 |

## Usage

### Using AppIcon Widget (Recommended)

Always use the `AppIcon` widget for consistent stroke width across the app:

```dart
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:your_app/ui/widget/app_icon.dart';

// Basic usage
AppIcon(LucideIcons.home)

// With custom size
AppIcon(LucideIcons.search, size: 20)

// With custom color
AppIcon(LucideIcons.bell, color: Colors.red)

// With both
AppIcon(
  LucideIcons.heart,
  size: 32,
  color: colorScheme.primary,
)
```

### AppIcon Implementation

The `AppIcon` widget (`lib/ui/widget/app_icon.dart`) automatically converts icons to use the thin stroke variant:

```dart
class AppIcon extends StatelessWidget {
  const AppIcon(this.icon, {super.key, this.size, this.color});

  final IconData icon;
  final double? size;
  final Color? color;

  static const double defaultSize = 24;

  static IconData _toThinVariant(IconData icon) {
    return IconData(
      icon.codePoint,
      fontFamily: 'Lucide200',  // Thin stroke
      fontPackage: 'lucide_icons_flutter',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _toThinVariant(icon),
      size: size ?? defaultSize,
      color: color,
    );
  }
}
```

## Icon Names

Some icons have different names in `lucide_icons_flutter` compared to the original `lucide_icons` package:

| Old Name (lucide_icons) | New Name (lucide_icons_flutter) |
|-------------------------|--------------------------------|
| `home` | `house` |
| `alertCircle` | `circleAlert` |
| `plusCircle` | `circlePlus` |
| `userCircle2` | `circleUserRound` |
| `filter` | `funnel` |
| `layoutGrid` | `grid2x2` |

## Common Icons Used

### Navigation
- `LucideIcons.house` - Home tab
- `LucideIcons.grid2x2` - Categories tab
- `LucideIcons.circlePlus` - Sell tab
- `LucideIcons.packageCheck` - Sold tab
- `LucideIcons.circleUserRound` - Account tab

### Actions
- `LucideIcons.search` - Search
- `LucideIcons.bell` - Notifications
- `LucideIcons.arrowLeft` - Back navigation
- `LucideIcons.arrowRight` - Forward navigation
- `LucideIcons.x` - Close/dismiss
- `LucideIcons.refreshCw` - Refresh/retry
- `LucideIcons.share2` - Share

### Feedback
- `LucideIcons.circleAlert` - Error/warning
- `LucideIcons.heart` - Favorite/like
- `LucideIcons.heartHandshake` - Wishlisted

### Features
- `LucideIcons.slidersHorizontal` - Filter
- `LucideIcons.arrowUpDown` - Sort
- `LucideIcons.funnel` - Filter indicator
- `LucideIcons.packageOpen` - Empty state

## Rules

### MUST DO

1. **Always use `AppIcon`** - Never use `Icon(LucideIcons.xxx)` directly
2. **Import both packages** - Always import `lucide_icons_flutter` and `app_icon.dart`
3. **Default size is 24** - Only specify size when different from default
4. **Use semantic icons** - Choose icons that clearly represent the action

### NEVER DO

1. **Never use `Icon(LucideIcons.xxx)`** - This bypasses stroke width configuration
2. **Never use `lucide_icons` package** - Use `lucide_icons_flutter` instead
3. **Never hardcode icon font families** - Let `AppIcon` handle stroke width

### PR Blockers

These will cause PR rejection:

- [ ] Using `Icon(LucideIcons.xxx)` instead of `AppIcon(LucideIcons.xxx)`
- [ ] Importing `lucide_icons` instead of `lucide_icons_flutter`
- [ ] Missing `app_icon.dart` import when using icons
- [ ] Hardcoding `Lucide200` or other font families outside `AppIcon`

## Finding Icons

1. Browse icons at https://lucide.dev/icons
2. Convert kebab-case to camelCase: `circle-plus` -> `circlePlus`
3. Some icons may have different names - check the mapping table above
4. Use IDE autocomplete on `LucideIcons.` to find available icons

## Example: Adding Icons to a Screen

```dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:your_app/ui/widget/app_icon.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Screen'),
        actions: [
          IconButton(
            icon: AppIcon(LucideIcons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: AppIcon(
              LucideIcons.bell,
              color: colorScheme.onSurface,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: AppIcon(
          LucideIcons.circleAlert,
          size: 64,
          color: colorScheme.error,
        ),
      ),
    );
  }
}
```
