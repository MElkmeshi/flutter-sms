# Widget Wrappers

> X* wrapper components for consistent theming.

---

## Philosophy

Instead of using raw Flutter widgets, use **wrapper components** (X* pattern) that enforce theme compliance:

| Raw Widget | Wrapper | Benefit |
|------------|---------|---------|
| `Container` | `XContainer` | Theme-aware colors, consistent border radius |
| `Scaffold` | `XScaffold` | Consistent background, safe area handling, edge-to-edge |
| `AppBar` | `XAppBar` | M3 styling, auto back button with XIcon, edge-to-edge |
| `Card` | `XCard` | M3 elevation, theme shapes |
| `FloatingActionButton` | `XFab` | M3 flat elevation, theme colors |

---

## Why Wrappers?

1. **Enforce theme compliance** — Can't accidentally hardcode colors
2. **Consistent styling** — Border radius, padding, shadows are standardized
3. **Easy maintenance** — Change in one place, applies everywhere
4. **Reduce boilerplate** — Common patterns are pre-configured

---

## Available Wrappers

| Wrapper | Source | Documentation |
|---------|--------|---------------|
| [XContainer](./x_container.md) | `lib/ui/widget/x_container.dart` | Theme-aware container |
| [XScaffold](./x_scaffold.md) | `lib/ui/widget/x_scaffold.dart` | Consistent page structure |
| [XAppBar](./x_app_bar.md) | `lib/ui/widget/x_app_bar.dart` | M3 app bar with auto back button |
| [XCard](./x_card.md) | `lib/ui/widget/x_card.dart` | M3 card with proper elevation |
| [XFab](./x_fab.md) | `lib/ui/widget/x_fab.dart` | M3 floating action button |
| [XIcon](./x_icon.md) | `lib/ui/widget/x_icon.dart` | Consistent icon styling |

---

## Usage Pattern

```dart
// ❌ WRONG — Raw widgets with hardcoded values
Container(
  color: Color(0xFFF5F5F5),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text('Hello'),
)

// ✅ CORRECT — Use wrapper with theme values
XContainer(
  padding: EdgeInsets.all(context.spacing.md),
  child: Text('Hello'),
)
```

---

## Adding New Wrappers

When you need to wrap a new widget:

1. Create `lib/ui/widget/x_<widget>.dart`
2. Extend or wrap the original widget
3. Use theme tokens for colors, spacing, shapes
4. Document in `docs/conventions/design_system/widgets/x_<widget>.md`
5. Add to this index

---

## PR Blockers

- [ ] Using raw `Container` instead of `XContainer`
- [ ] Using raw `Scaffold` instead of `XScaffold`
- [ ] Using raw `AppBar` instead of `XAppBar`
- [ ] Using raw `Card` instead of `XCard`
- [ ] Using raw `FloatingActionButton` instead of `XFab`
- [ ] Using `Icon(LucideIcons.x)` instead of `XIcon(LucideIcons.x)`
