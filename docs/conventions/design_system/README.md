# Design System Conventions

> **Cross-project design patterns and implementation guidelines**

This directory contains reusable design system patterns that apply to ANY Flutter project using Material 3.

## Purpose

- ✅ **Implementation patterns** for colors, typography, spacing
- ✅ **Widget wrappers** (X* pattern) for consistent theming
- ✅ **Material 3** best practices
- ✅ **Reusable guidelines** across all Flutter projects

## What's Here

### Design Token Patterns
Implementation guides for design tokens:
- **colors.md** - How to implement ColorScheme and use theme colors
- **typography.md** - How to implement TextTheme and use text styles
- **spacing.md** - How to implement spacing via Theme Extensions

### `/widgets/`
X* wrapper components that enforce theme compliance:
- **x_container.md** - Theme-aware container wrapper
- **x_scaffold.md** - Consistent page structure with edge-to-edge
- **x_app_bar.md** - M3 app bar with auto back button
- **x_card.md** - M3 card with proper elevation
- **x_fab.md** - M3 floating action button
- **x_icon.md** - Consistent icon styling with RTL support

## Philosophy

Instead of using raw Flutter widgets with hardcoded values, use **wrapper components** that:
1. Enforce theme compliance
2. Provide consistent styling
3. Reduce boilerplate
4. Make maintenance easier

## Example

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

## What's NOT Here

**Project-specific design token VALUES** should be in your project's `/docs/project/design/` folder:
- Brand color values (hex codes)
- Font family choices
- Specific spacing scale values
- Typography sizes and weights

**This folder contains HOW to implement, your project contains WHAT values to use.**

### Example Split

| Convention (How) | Project (What) |
|------------------|----------------|
| `conventions/design_system/colors.md` - How to use ColorScheme | `project/design/colors.md` - Brand: Purple #924DBF |
| `conventions/design_system/typography.md` - How to use TextTheme | `project/design/typography.md` - Fonts: Roboto, Almarai |
| `conventions/design_system/spacing.md` - How to use spacing tokens | `project/design/spacing.md` - Scale: 4, 8, 16, 24dp |

## Usage in Your Project

1. Copy X* widget implementations to `lib/ui/widget/`
2. Adapt to your project's theme structure
3. Define your own colors/spacing in your project's design system
4. Use X* wrappers consistently throughout your app

## Related Docs

- See `/docs/conventions/architecture/` for architectural patterns
- See your project's `/docs/project/design/` for brand-specific design tokens
