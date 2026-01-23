# XFab

> Material 3 Floating Action Button wrapper.

---

## Purpose

`XFab` wraps Flutter's `FloatingActionButton` to:

- Ensure M3 compliance with flat elevation (0 by default)
- Use theme's `FloatingActionButtonThemeData` for consistent styling
- Provide both standard and extended variants
- Support accessibility with tooltip parameter

---

## Source File

`lib/ui/widget/x_fab.dart`

---

## Props

### Standard FAB

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `onPressed` | `VoidCallback?` | required | Callback when pressed |
| `child` | `Widget` | required | FAB content (typically XIcon) |
| `tooltip` | `String?` | `null` | Accessibility tooltip |
| `backgroundColor` | `Color?` | theme | Override background color |
| `foregroundColor` | `Color?` | theme | Override foreground color |
| `elevation` | `double` | `0` | FAB elevation |
| `heroTag` | `Object?` | `null` | Hero animation tag |

### Extended FAB

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `onPressed` | `VoidCallback?` | required | Callback when pressed |
| `label` | `Widget` | required | Label widget |
| `icon` | `Widget?` | `null` | Optional leading icon |
| `tooltip` | `String?` | `null` | Accessibility tooltip |
| `backgroundColor` | `Color?` | theme | Override background color |
| `foregroundColor` | `Color?` | theme | Override foreground color |
| `elevation` | `double` | `0` | FAB elevation |
| `heroTag` | `Object?` | `null` | Hero animation tag |

---

## Usage Examples

### Standard FAB

```dart
XFab(
  onPressed: () => addItem(),
  tooltip: 'Add item',
  child: XIcon(LucideIcons.plus),
)
```

### Extended FAB with Label

```dart
XFab.extended(
  onPressed: () => addToCart(),
  label: Text(context.t.products.addToCart),
)
```

### Extended FAB with Icon and Label

```dart
XFab.extended(
  onPressed: () => addToCart(),
  icon: XIcon(LucideIcons.shoppingCart),
  label: Text(context.t.products.addToCart),
)
```

### In XScaffold

```dart
XScaffold(
  appBar: XAppBar(title: Text(context.t.addresses.title)),
  floatingActionButton: XFab(
    onPressed: () => navigateToAdd(),
    tooltip: context.t.addresses.add,
    child: XIcon(LucideIcons.plus),
  ),
  body: content,
)
```

---

## Theme Configuration

FAB styling is configured in `AppTheme`:

```dart
floatingActionButtonTheme: FloatingActionButtonThemeData(
  backgroundColor: scheme.primary,
  foregroundColor: scheme.onPrimary,
),
```

This ensures all FABs use primary/onPrimary colors by default.

---

## Do/Don't

```dart
// DO - Use XFab
XFab(
  onPressed: () => action(),
  child: XIcon(LucideIcons.plus),
)

// DO - Use XFab.extended for labeled FABs
XFab.extended(
  onPressed: () => action(),
  icon: XIcon(LucideIcons.plus),
  label: Text('Add'),
)

// DON'T - Use raw FloatingActionButton
FloatingActionButton(
  onPressed: () => action(),
  backgroundColor: colorScheme.primaryContainer,  // WRONG
  foregroundColor: colorScheme.onPrimaryContainer,
  child: Icon(LucideIcons.plus),
)

// DON'T - Manually set colors (use theme)
XFab(
  onPressed: () => action(),
  backgroundColor: Colors.purple,  // WRONG - use theme
  child: XIcon(LucideIcons.plus),
)
```

---

## Accessibility

Always provide a `tooltip` for FABs to support screen readers:

```dart
XFab(
  onPressed: () => addAddress(),
  tooltip: context.t.addresses.addNew,  // Accessible label
  child: XIcon(LucideIcons.plus),
)
```

The tooltip appears on long-press and is announced by screen readers.
