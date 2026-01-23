# Color System

> How to implement and use Material 3 ColorScheme in Flutter.

---

## Philosophy

Use Material 3's `ColorScheme` system for all colors. **Never hardcode color values** in widgets.

### Benefits
- ✅ Automatic dark mode support
- ✅ Consistent color semantics
- ✅ Accessible contrast ratios
- ✅ Easy theme switching

---

## Implementation Pattern

### 1. Define Your Color Palette

Create an `app_colors.dart` file with your brand colors:

```dart
// lib/ui/theme/app_colors.dart
import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();

  // Brand color (seed color for Material 3)
  static const Color primary = Color(0xFF924DBF);

  // Additional brand colors
  static const Color secondaryContainer = Color(0xFFF5E7FF);
  static const Color outline = Color(0xFFD1D5DC);

  // Light theme color scheme
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF1C1B1E),
    secondaryContainer: secondaryContainer,
    outline: outline,
    outlineVariant: outline,
  );

  // Dark theme color scheme
  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
    surface: const Color(0xFF1C1B1E),
    onSurface: const Color(0xFFE6E1E6),
    secondaryContainer: secondaryContainer,
    outline: outline,
    outlineVariant: outline,
  );
}
```

### 2. Register in Theme

```dart
// lib/ui/theme/app_theme.dart
static ThemeData light = ThemeData(
  useMaterial3: true,
  colorScheme: AppColors.lightColorScheme,
);

static ThemeData dark = ThemeData(
  useMaterial3: true,
  colorScheme: AppColors.darkColorScheme,
);
```

---

## Usage Patterns

### ✅ CORRECT - Use ColorScheme Tokens

Always access colors via `Theme.of(context).colorScheme`:

```dart
// Container with theme color
Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    'Hello',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
    ),
  ),
)

// Primary button
FilledButton(
  // Color automatically uses colorScheme.primary
  onPressed: () {},
  child: Text('Submit'),
)

// Custom colored widget
Card(
  color: Theme.of(context).colorScheme.primaryContainer,
  child: Text(
    'Content',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    ),
  ),
)
```

### ❌ WRONG - Hardcoded Colors

Never use:

```dart
// ❌ Hardcoded hex values
Container(color: Color(0xFF123456))

// ❌ Material color constants
Container(color: Colors.purple)

// ❌ Direct color references
Text(style: TextStyle(color: Colors.black))
```

---

## Color Role Reference

| ColorScheme Token | When to Use |
|-------------------|-------------|
| `primary` | Primary actions, FABs, prominent buttons |
| `onPrimary` | Text/icons on primary color |
| `primaryContainer` | Tonal backgrounds, chips, selection states |
| `onPrimaryContainer` | Text/icons on primary container |
| `secondary` | Less prominent actions, alternative actions |
| `onSecondary` | Text/icons on secondary |
| `tertiary` | Accents, highlights, special emphasis |
| `surface` | Card backgrounds, bottom sheets, dialogs |
| `onSurface` | Primary text and icons on surfaces |
| `surfaceVariant` | Dividers, disabled states, subtle backgrounds |
| `onSurfaceVariant` | Secondary text, subtle icons |
| `error` | Error states, destructive actions |
| `onError` | Text/icons on error color |
| `outline` | Borders, dividers, outlined buttons |
| `background` | App canvas, behind all other content |

---

## Dark Mode Support

ColorScheme automatically adapts when you:

1. Define both light and dark color schemes
2. Use `brightness` parameter in `ColorScheme.fromSeed()`
3. Access colors via `Theme.of(context).colorScheme`

```dart
// This automatically switches between light/dark
final bgColor = Theme.of(context).colorScheme.surface;
```

---

## Common Patterns

### Surface with Text
```dart
Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    'Content',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
    ),
  ),
)
```

### Primary Action
```dart
FilledButton(
  // Automatically uses primary/onPrimary
  onPressed: () {},
  child: Text('Action'),
)
```

### Tonal Background
```dart
Container(
  color: Theme.of(context).colorScheme.primaryContainer,
  padding: EdgeInsets.all(16),
  child: Text(
    'Highlighted content',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    ),
  ),
)
```

### Border/Outline
```dart
Container(
  decoration: BoxDecoration(
    border: Border.all(
      color: Theme.of(context).colorScheme.outline,
    ),
    borderRadius: BorderRadius.circular(12),
  ),
)
```

---

## PR Blockers

- [ ] No hardcoded `Color(0xFFxxxxxx)` values in widgets
- [ ] No `Colors.*` constants (Colors.black, Colors.blue, etc.)
- [ ] All colors accessed via `Theme.of(context).colorScheme.*`
- [ ] Both light and dark color schemes defined

---

## Resources

- [Material 3 Color System](https://m3.material.io/styles/color/overview)
- [Flutter ColorScheme](https://api.flutter.dev/flutter/material/ColorScheme-class.html)
