# Spacing System

> How to implement and use spacing tokens via Theme Extensions in Flutter.

---

## Philosophy

Use a consistent spacing scale via Theme Extensions. **Never hardcode padding/margin values** in widgets.

### Benefits
- ✅ Consistent spacing across the app
- ✅ Easy to maintain and update
- ✅ Accessible via context
- ✅ Type-safe spacing tokens

---

## Implementation Pattern

### 1. Define Spacing Extension

Create an `app_spacing.dart` file:

```dart
// lib/ui/theme/app_spacing.dart
import 'package:flutter/material.dart';
import 'dart:ui';

@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    this.xs = 4,
    this.sm = 8,
    this.md = 16,
    this.lg = 24,
    this.xl = 32,
    this.xxl = 48,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  @override
  AppSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return AppSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  AppSpacing lerp(AppSpacing? other, double t) {
    if (other == null) return this;
    return AppSpacing(
      xs: lerpDouble(xs, other.xs, t) ?? xs,
      sm: lerpDouble(sm, other.sm, t) ?? sm,
      md: lerpDouble(md, other.md, t) ?? md,
      lg: lerpDouble(lg, other.lg, t) ?? lg,
      xl: lerpDouble(xl, other.xl, t) ?? xl,
      xxl: lerpDouble(xxl, other.xxl, t) ?? xxl,
    );
  }
}
```

### 2. Create Context Extension

```dart
// Extension for easy access
extension AppSpacingExtension on BuildContext {
  AppSpacing get spacing => Theme.of(this).extension<AppSpacing>()!;
}
```

### 3. Register in Theme

```dart
// lib/ui/theme/app_theme.dart
static ThemeData light = ThemeData(
  useMaterial3: true,
  colorScheme: AppColors.lightColorScheme,
  extensions: const [
    AppSpacing(),  // Register spacing extension
  ],
);

static ThemeData dark = ThemeData(
  useMaterial3: true,
  colorScheme: AppColors.darkColorScheme,
  extensions: const [
    AppSpacing(),  // Same spacing for dark mode
  ],
);
```

---

## Usage Patterns

### ✅ CORRECT - Use Spacing Tokens

Always access spacing via `context.spacing`:

```dart
// Padding
Padding(
  padding: EdgeInsets.all(context.spacing.md),
  child: Text('Content'),
)

// Vertical spacing
Column(
  children: [
    Text('Title'),
    SizedBox(height: context.spacing.sm),
    Text('Body'),
  ],
)

// Mixed spacing
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: context.spacing.lg,
    vertical: context.spacing.md,
  ),
  child: Widget(),
)

// Custom combinations
Container(
  margin: EdgeInsets.only(
    top: context.spacing.xl,
    bottom: context.spacing.lg,
  ),
)
```

### ❌ WRONG - Hardcoded Values

Never use:

```dart
// ❌ Hardcoded numbers
Padding(
  padding: EdgeInsets.all(16),  // WRONG
)

// ❌ Magic numbers in SizedBox
SizedBox(height: 8)  // WRONG

// ❌ Static constants
Padding(
  padding: EdgeInsets.all(AppSpacing.md),  // WRONG - no context
)
```

---

## Spacing Token Reference

Choose spacing based on relationship and hierarchy:

| Token | Value | Use For |
|-------|-------|---------|
| `xs` | 4dp | Tight spacing between tightly related elements |
| `sm` | 8dp | Small gaps, related list items |
| `md` | 16dp | Standard padding (most common) |
| `lg` | 24dp | Section spacing, card internal padding |
| `xl` | 32dp | Large gaps between sections |
| `xxl` | 48dp | Page margins, major section dividers |

---

## Common Patterns

### Card Padding
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(context.spacing.lg),
    child: Column(
      children: [...],
    ),
  ),
)
```

### List Item Spacing
```dart
Column(
  children: items.map((item) =>
    Padding(
      padding: EdgeInsets.only(bottom: context.spacing.sm),
      child: ItemWidget(item),
    ),
  ).toList(),
)
```

### Page Layout
```dart
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: context.spacing.lg,
    vertical: context.spacing.md,
  ),
  child: Column(
    children: [
      PageTitle(),
      SizedBox(height: context.spacing.xl),
      Content(),
    ],
  ),
)
```

### Form Field Spacing
```dart
Column(
  children: [
    TextField(...),
    SizedBox(height: context.spacing.md),
    TextField(...),
    SizedBox(height: context.spacing.md),
    TextField(...),
  ],
)
```

### Section Divider
```dart
Column(
  children: [
    Section1(),
    SizedBox(height: context.spacing.xxl),
    Section2(),
  ],
)
```

---

## Border Radius (Material 3 Shapes)

Use theme shapes instead of hardcoded radius values:

```dart
// ✅ CORRECT - Use theme shapes
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),  // Medium shape
    color: Theme.of(context).colorScheme.surface,
  ),
)

// Or access via theme
final shape = Theme.of(context).cardTheme.shape as RoundedRectangleBorder;
final radius = shape.borderRadius;
```

### Shape Reference

| Shape | Radius | Use For |
|-------|--------|---------|
| Extra Small | 4dp | Chips, small elements |
| Small | 8dp | Buttons, text fields |
| Medium | 12dp | Cards (most common) |
| Large | 16dp | Bottom sheets, dialogs |
| Extra Large | 28dp | FABs |

---

## Elevation

Material 3 uses tonal elevation (color shift) instead of shadows:

```dart
// Card with elevation
Card(
  elevation: 1,  // Level 1: Cards
  child: Content(),
)

// FAB with higher elevation
FloatingActionButton(
  elevation: 6,  // Level 3: FABs
  onPressed: () {},
)
```

### Elevation Reference

| Level | dp | Use For |
|-------|-----|---------|
| 0 | 0dp | Flat surfaces, backgrounds |
| 1 | 1dp | Cards, sheets |
| 2 | 3dp | Menus, dropdowns |
| 3 | 6dp | FABs, snackbars |
| 4 | 8dp | Navigation drawers |
| 5 | 12dp | Modal bottom sheets |

---

## Gap Widget (Alternative)

For simple spacing, consider using the `Gap` widget from `flutter_gap` package:

```dart
import 'package:gap/gap.dart';

Column(
  children: [
    Text('Title'),
    Gap(context.spacing.sm),  // Vertical gap
    Text('Body'),
  ],
)

Row(
  children: [
    Icon(Icons.home),
    Gap(context.spacing.xs),  // Horizontal gap
    Text('Home'),
  ],
)
```

---

## Responsive Spacing (Advanced)

For responsive apps, you can make spacing scale based on screen size:

```dart
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.screenWidth,
  }) : xs = screenWidth < 600 ? 4 : 6,
       sm = screenWidth < 600 ? 8 : 12,
       md = screenWidth < 600 ? 16 : 20,
       lg = screenWidth < 600 ? 24 : 32,
       xl = screenWidth < 600 ? 32 : 40,
       xxl = screenWidth < 600 ? 48 : 64;

  final double screenWidth;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  // ... rest of implementation
}
```

---

## Quick Reference

```dart
// Access spacing
context.spacing.xs    // 4dp
context.spacing.sm    // 8dp
context.spacing.md    // 16dp (most common)
context.spacing.lg    // 24dp
context.spacing.xl    // 32dp
context.spacing.xxl   // 48dp

// Common patterns
EdgeInsets.all(context.spacing.md)
SizedBox(height: context.spacing.sm)
Gap(context.spacing.lg)
```

---

## PR Blockers

- [ ] No hardcoded padding/margin values
- [ ] All spacing uses `context.spacing.*`
- [ ] No direct `AppSpacing()` instantiation (must use context)
- [ ] Border radius uses Material 3 shape values

---

## Resources

- [Material 3 Layout](https://m3.material.io/foundations/layout/overview)
- [Flutter Theme Extensions](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)
- [Gap Package](https://pub.dev/packages/gap)
