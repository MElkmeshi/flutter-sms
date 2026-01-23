# Skeleton Loading (Shimmer)

## Overview

This project uses **simple container-based skeletons** for loading states instead of external shimmer packages.

> **Warning**: Do NOT use `skeletonizer` package. It causes app freezes on Flutter 3.38+ due to compatibility issues with the rendering engine.

## Implementation Pattern

All shimmer/skeleton widgets use plain Flutter containers with the theme's `surfaceContainerHighest` color:

```dart
class MyShimmer extends StatelessWidget {
  const MyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final spacing = context.spacing;
    final skeletonColor = colorScheme.surfaceContainerHighest;

    return Column(
      children: [
        // Rectangle skeleton
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: skeletonColor,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        SizedBox(height: spacing.md),
        // Text line skeleton
        Container(
          height: 16,
          width: 150,
          decoration: BoxDecoration(
            color: skeletonColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        // Circle skeleton (e.g., avatar)
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: skeletonColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
```

## Existing Shimmer Widgets

| Widget | Location | Used For |
|--------|----------|----------|
| `HomeShimmer` | `lib/feature/home/ui/home_shimmer.dart` | Home screen loading |
| `CategoryGridShimmer` | `lib/feature/category/ui/category_shimmer.dart` | Category grid loading |
| `ProductGridShimmer` | `lib/feature/category/ui/category_shimmer.dart` | Product grid loading |
| `ProductDetailShimmer` | `lib/feature/product/ui/product_detail_shimmer.dart` | Product detail loading |
| `SuggestedProductsSectionShimmer` | `lib/feature/product/ui/suggested_products_section.dart` | Suggested products loading |

## Best Practices

1. **Use theme colors**: Always use `colorScheme.surfaceContainerHighest` for skeleton color
2. **Match actual layout**: Skeleton should roughly match the shape of the actual content
3. **Use BorderRadius**: Apply `BorderRadius.circular(4)` for text, `BorderRadius.circular(12)` for cards/images
4. **Keep it simple**: No animations needed - static gray containers are sufficient
5. **Reuse patterns**: Create private skeleton widgets (e.g., `_ProductCardSkeleton`) for repeated items

## Why Not Skeletonizer?

The `skeletonizer` package was removed because:
- Causes complete app freeze on Flutter 3.38.5
- Incompatible with Impeller rendering backend
- The `UnitingCanvas` class conflicts with new Canvas API methods

Simple container-based skeletons are:
- More reliable across Flutter versions
- Zero external dependencies
- Easier to maintain
- No performance overhead
