# Theming & Material 3

> Material 3 requirements, color system, and typography.

---

## Material 3 is Mandatory

> ⚠️ **CRITICAL** — All UI must strictly adhere to Material 3. **We do NOT support Material 2. Period.**

### Why Material 3?

- Dynamic color theming
- Updated component designs
- Better accessibility
- Consistent cross-platform experience

---

## Non-Negotiable Rules

```dart
// ✅ ALWAYS — Enable Material 3 in theme
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,  // MANDATORY
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
  ),
  darkTheme: ThemeData(
    useMaterial3: true,  // MANDATORY
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
  ),
)

// ❌ NEVER — Material 2 or missing useMaterial3
ThemeData(
  primarySwatch: Colors.blue,  // WRONG - M2 pattern
)

// ❌ NEVER — Explicitly disabling M3
ThemeData(
  useMaterial3: false,  // ABSOLUTELY FORBIDDEN
)
```

---

## Color System

```dart
// ✅ ALWAYS — Use ColorScheme tokens
Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    'Hello',
    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
  ),
)

// ✅ ALWAYS — Use semantic color roles
colorScheme.primary        // Primary brand color
colorScheme.onPrimary      // Text/icons on primary
colorScheme.secondary      // Secondary accent
colorScheme.surface        // Card/sheet backgrounds
colorScheme.onSurface      // Text on surface
colorScheme.error          // Error states
colorScheme.outline        // Borders, dividers

// ❌ NEVER — Hardcoded colors
Container(color: Color(0xFF123456))  // WRONG
Text(style: TextStyle(color: Colors.black))  // WRONG
```

---

## Typography

```dart
// ✅ ALWAYS — Use M3 text styles from theme
Text('Title', style: Theme.of(context).textTheme.headlineMedium)
Text('Body', style: Theme.of(context).textTheme.bodyLarge)
Text('Label', style: Theme.of(context).textTheme.labelMedium)

// M3 Typography Scale:
// displayLarge, displayMedium, displaySmall
// headlineLarge, headlineMedium, headlineSmall
// titleLarge, titleMedium, titleSmall
// bodyLarge, bodyMedium, bodySmall
// labelLarge, labelMedium, labelSmall

// ❌ NEVER — Custom text styles that ignore theme
Text('Title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))  // WRONG
```

---

## Required M3 Components

| Component | M3 Widget | ❌ Never Use |
|-----------|-----------|--------------|
| Buttons | `FilledButton`, `OutlinedButton`, `TextButton` | `RaisedButton`, `FlatButton` |
| Navigation | `NavigationBar`, `NavigationRail` | `BottomNavigationBar` (M2) |
| Cards | `Card` with M3 elevation | Custom shadows |
| Dialogs | `AlertDialog`, `Dialog` | Custom modal patterns |
| Inputs | `TextField` with M3 decoration | Custom input styling |
| Chips | `FilterChip`, `InputChip`, `ActionChip` | Custom chip implementations |
| Progress | `CircularProgressIndicator`, `LinearProgressIndicator` | Custom loaders |

---

## Elevation & Shadows

```dart
// ✅ ALWAYS — Use M3 elevation system
Card(
  elevation: 1,  // M3 uses tonal elevation
  child: content,
)

// M3 Elevation levels: 0, 1, 2, 3, 4, 5
// M3 uses tonal color shifts, not drop shadows

// ❌ NEVER — Custom shadow/elevation
Container(
  decoration: BoxDecoration(
    boxShadow: [BoxShadow(...)],  // WRONG - use Card or Surface
  ),
)
```

---

## Shapes

```dart
// ✅ ALWAYS — Use theme shapes
Card(
  shape: Theme.of(context).cardTheme.shape,  // Or let it default
)

// M3 shape scale (defined in theme):
// extraSmall: 4dp, small: 8dp, medium: 12dp, large: 16dp, extraLarge: 28dp

// ❌ NEVER — Arbitrary border radius
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(17),  // WRONG - use theme
  ),
)
```

---

## Button Examples

```dart
// Primary action
FilledButton(
  onPressed: () {},
  child: Text(context.t.common.submit),
)

// Secondary action
FilledButton.tonal(
  onPressed: () {},
  child: Text(context.t.common.cancel),
)

// Tertiary action
TextButton(
  onPressed: () {},
  child: Text(context.t.common.skip),
)

// With icon
FilledButton.icon(
  onPressed: () {},
  icon: AppIcon(LucideIcons.plus),
  label: Text(context.t.common.add),
)
```

---

## Navigation Bar Example

```dart
NavigationBar(
  selectedIndex: _currentIndex,
  onDestinationSelected: (index) => setState(() => _currentIndex = index),
  destinations: [
    NavigationDestination(
      icon: AppIcon(LucideIcons.house, color: colorScheme.onSurfaceVariant),
      selectedIcon: AppIcon(LucideIcons.house, color: colorScheme.primary),
      label: context.t.nav.home,
    ),
    NavigationDestination(
      icon: AppIcon(LucideIcons.shoppingBag, color: colorScheme.onSurfaceVariant),
      selectedIcon: AppIcon(LucideIcons.shoppingBag, color: colorScheme.primary),
      label: context.t.nav.orders,
    ),
  ],
)
```

---

## PR Blockers

- [ ] `useMaterial3: false` anywhere in codebase
- [ ] Missing `useMaterial3: true` in ThemeData
- [ ] Using deprecated M2 widgets (RaisedButton, FlatButton, etc.)
- [ ] Hardcoded colors instead of ColorScheme tokens
- [ ] Custom text styles instead of theme typography
- [ ] `BottomNavigationBar` instead of `NavigationBar`
- [ ] Custom shadows instead of M3 elevation
- [ ] Arbitrary border radius instead of theme shapes
