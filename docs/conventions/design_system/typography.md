# Typography System

> How to implement and use Material 3 text styles in Flutter.

---

## Philosophy

Use Material 3's `TextTheme` system for all text styling. **Never hardcode font sizes or weights** in widgets.

### Benefits
- ✅ Consistent text hierarchy
- ✅ Automatic font scaling
- ✅ Locale-aware fonts
- ✅ Accessible text sizes

---

## Implementation Pattern

### 1. Define Font Choices

Create an `app_typography.dart` file:

```dart
// lib/ui/theme/app_typography.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTypography {
  AppTypography._();

  static const String defaultFont = 'Roboto';
  static const String arabicFont = 'Almarai';

  /// Apply typography based on locale
  static ThemeData applyTypography({
    required ThemeData theme,
    required Locale locale,
  }) {
    final isArabic = locale.languageCode == 'ar';
    final fontFamily = isArabic ? arabicFont : defaultFont;

    final textTheme = isArabic
        ? GoogleFonts.almaraiTextTheme(theme.textTheme)
        : GoogleFonts.robotoTextTheme(theme.textTheme);

    return theme.copyWith(textTheme: textTheme);
  }
}
```

### 2. Apply in App

```dart
// main.dart
MaterialApp(
  theme: AppTypography.applyTypography(
    theme: AppTheme.light,
    locale: locale,
  ),
  darkTheme: AppTypography.applyTypography(
    theme: AppTheme.dark,
    locale: locale,
  ),
)
```

---

## Usage Patterns

### ✅ CORRECT - Use TextTheme Styles

Always access text styles via `Theme.of(context).textTheme`:

```dart
// Headline
Text(
  'Welcome Back',
  style: Theme.of(context).textTheme.headlineMedium,
)

// Body text
Text(
  'Description text goes here',
  style: Theme.of(context).textTheme.bodyLarge,
)

// Button text
Text(
  'Submit',
  style: Theme.of(context).textTheme.labelLarge,
)

// With color override
Text(
  'Subtitle',
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  ),
)
```

### ❌ WRONG - Hardcoded Styles

Never use:

```dart
// ❌ Hardcoded font sizes
Text(
  'Title',
  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
)

// ❌ No text style at all
Text('Hello')  // Uses default, not theme-aware

// ❌ Hardcoded font families
Text(
  style: TextStyle(fontFamily: 'Roboto'),
)
```

---

## Text Style Reference

| TextTheme Style | Use For |
|-----------------|---------|
| `displayLarge` | Hero text (57sp) - rarely used |
| `displayMedium` | Large headings (45sp) |
| `displaySmall` | Section headings (36sp) |
| `headlineLarge` | Page titles (32sp) |
| `headlineMedium` | Section titles (28sp) |
| `headlineSmall` | Card titles (24sp) |
| `titleLarge` | App bar titles (22sp, medium weight) |
| `titleMedium` | List item titles (16sp, medium weight) |
| `titleSmall` | Subtitles (14sp, medium weight) |
| `bodyLarge` | Primary body text (16sp) |
| `bodyMedium` | Default body text (14sp) |
| `bodySmall` | Captions (12sp) |
| `labelLarge` | Button text (14sp, medium weight) |
| `labelMedium` | Chips, badges (12sp, medium weight) |
| `labelSmall` | Small labels (11sp, medium weight) |

---

## Common Patterns

### Page Title
```dart
Text(
  'Settings',
  style: Theme.of(context).textTheme.headlineLarge,
)
```

### Section Title
```dart
Text(
  'Account Information',
  style: Theme.of(context).textTheme.headlineMedium,
)
```

### Body Text
```dart
Text(
  'This is a description of the product...',
  style: Theme.of(context).textTheme.bodyLarge,
)
```

### Secondary Text
```dart
Text(
  'Last updated 2 days ago',
  style: Theme.of(context).textTheme.bodySmall?.copyWith(
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  ),
)
```

### Button Text
```dart
FilledButton(
  onPressed: () {},
  child: Text(
    'Continue',
    style: Theme.of(context).textTheme.labelLarge,
  ),
)
```

### List Item
```dart
ListTile(
  title: Text(
    'Item Title',
    style: Theme.of(context).textTheme.titleMedium,
  ),
  subtitle: Text(
    'Item description',
    style: Theme.of(context).textTheme.bodyMedium,
  ),
)
```

---

## Modifying Text Styles

Use `copyWith()` to modify theme styles:

```dart
// Change color only
Text(
  'Error message',
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    color: Theme.of(context).colorScheme.error,
  ),
)

// Change weight only
Text(
  'Important',
  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    fontWeight: FontWeight.bold,
  ),
)

// Multiple changes
Text(
  'Special text',
  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  ),
)
```

---

## Locale-Aware Fonts

### Setup Multiple Fonts

```dart
// Define fonts for different locales
static TextStyle getFontForLocale(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return GoogleFonts.almarai();
    case 'ja':
      return GoogleFonts.notoSansJP();
    default:
      return GoogleFonts.roboto();
  }
}
```

### Apply Based on Locale

The typography is automatically applied when the locale changes via `AppTypography.applyTypography()`.

---

## Quick Reference

```dart
// Get TextTheme
final textTheme = Theme.of(context).textTheme;

// Common styles
textTheme.headlineLarge   // Page titles
textTheme.headlineMedium  // Section titles
textTheme.bodyLarge       // Primary body
textTheme.bodyMedium      // Default body
textTheme.bodySmall       // Captions
textTheme.labelLarge      // Buttons
```

---

## PR Blockers

- [ ] No hardcoded `fontSize` values
- [ ] No hardcoded `fontWeight` values
- [ ] All text uses `Theme.of(context).textTheme.*`
- [ ] Text modifications use `copyWith()` on theme styles

---

## Resources

- [Material 3 Typography](https://m3.material.io/styles/typography/overview)
- [Flutter TextTheme](https://api.flutter.dev/flutter/material/TextTheme-class.html)
- [Google Fonts Package](https://pub.dev/packages/google_fonts)
