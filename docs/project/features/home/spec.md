# Technical Spec: Home Feature

> **Last Updated**: January 2026

---

## Overview

The home screen fetches data from multiple API endpoints and displays them in a scrollable layout with multiple sections.

---

## API Endpoints

### Get Home Data (Aggregated)

If the backend provides an aggregated endpoint:

```http
GET /api/v1/home
Authorization: Bearer <token>  (optional for guests)
```

**Response:**
```json
{
  "data": {
    "banners": [...],
    "most_viewed": [...],
    "trending": [...],
    "brands": [...]
  }
}
```

### Alternative: Separate Endpoints

If data is fetched separately:

```http
GET /api/v1/banners
GET /api/v1/products?sort=most_viewed&limit=10
GET /api/v1/products?sort=trending&limit=10
GET /api/v1/brands
```

---

## Data Models

### Banner

```dart
@immutable
class Banner extends Equatable {
  const Banner({
    required this.id,
    required this.imageUrl,
    this.actionUrl,
    this.productId,
  });

  final String id;
  final String imageUrl;
  final String? actionUrl;   // External link
  final String? productId;   // Internal product link

  @override
  List<Object?> get props => [id, imageUrl, actionUrl, productId];
}
```

### Product

```dart
@immutable
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.price,
    this.discountPrice,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final double price;
  final double? discountPrice;

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  @override
  List<Object?> get props => [id, name, imageUrl, category, price, discountPrice];
}
```

### Brand

```dart
@immutable
class Brand extends Equatable {
  const Brand({
    required this.id,
    required this.name,
    required this.logoUrl,
  });

  final String id;
  final String name;
  final String logoUrl;

  @override
  List<Object?> get props => [id, name, logoUrl];
}
```

### HomeData

```dart
@immutable
class HomeData extends Equatable {
  const HomeData({
    required this.banners,
    required this.mostViewed,
    required this.trending,
    required this.brands,
  });

  final List<Banner> banners;
  final List<Product> mostViewed;
  final List<Product> trending;
  final List<Brand> brands;

  @override
  List<Object?> get props => [banners, mostViewed, trending, brands];
}
```

---

## Controller

### HomeController

```dart
class HomeController extends AsyncNotifier<HomeData> {
  static final provider = AsyncNotifierProvider(HomeController.new);

  @override
  Future<HomeData> build() async {
    return _fetchHomeData();
  }

  Future<HomeData> _fetchHomeData() async {
    final api = ref.read(homeApiProvider);
    return api.getHomeData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchHomeData);
  }
}
```

---

## Shared Widget: ProductCard

Located in `lib/ui/widget/product_card.dart`:

```dart
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.price,
    this.discountPrice,
    this.onTap,
  });

  final String imageUrl;
  final String category;
  final double price;
  final double? discountPrice;
  final VoidCallback? onTap;

  bool get _hasDiscount => discountPrice != null && discountPrice! < price;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final spacing = context.spacing;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing.sm),
            // Category
            Text(
              category,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: spacing.xs),
            // Price
            if (_hasDiscount) ...[
              Text(
                '\$${price.toStringAsFixed(0)}',
                style: textTheme.bodySmall?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '\$${discountPrice!.toStringAsFixed(0)}',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ] else
              Text(
                '\$${price.toStringAsFixed(0)}',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

---

## File Structure

```
lib/
├── domain/model/
│   ├── banner.dart
│   ├── product.dart
│   └── brand.dart
│
├── feature/home/
│   ├── data/
│   │   └── home_api.dart
│   ├── deps/
│   │   └── home_deps.dart
│   ├── logic/
│   │   └── home_controller.dart
│   └── ui/
│       ├── home_screen.dart
│       ├── ads_carousel.dart
│       ├── product_section.dart
│       └── brands_section.dart
│
└── ui/widget/
    └── product_card.dart       # Shared widget
```

---

## Screen Implementation

### HomeScreen

```dart
@RoutePage()
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(HomeController.provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nazaka'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {/* Navigate to search */},
          ),
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(LucideIcons.bell),
            ),
            onPressed: () {/* Navigate to notifications */},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(HomeController.provider.notifier).refresh(),
        child: homeDataAsync.when(
          loading: () => const HomeShimmer(),
          error: (e, _) => HomeError(onRetry: () => ref.invalidate(HomeController.provider)),
          data: (data) => HomeContent(data: data),
        ),
      ),
    );
  }
}
```

---

## Analytics Events

| Event | When | Properties |
|-------|------|------------|
| `home_viewed` | Screen opened | — |
| `banner_tapped` | Banner clicked | `banner_id`, `position` |
| `product_tapped` | Product card clicked | `product_id`, `section` |
| `brand_tapped` | Brand clicked | `brand_id` |
| `see_all_tapped` | See All clicked | `section` |

---

## Checklist

- [ ] Banner, Product, Brand models created
- [ ] HomeData model created
- [ ] HomeApi implemented
- [ ] HomeController with static provider
- [ ] ProductCard shared widget created
- [ ] AdsCarousel component
- [ ] ProductSection component (reusable)
- [ ] BrandsSection component
- [ ] HomeScreen with RefreshIndicator
- [ ] Loading shimmer states
- [ ] Error handling with retry
- [ ] Pull to refresh
- [ ] Analytics events
- [ ] Localization keys

---

## References

- [Home PRD](./prd.md) — Product requirements
- [Navigation PRD](/docs/features/navigation/prd.md) — Bottom navigation
- [Agent Guidelines](/agent.md) — Architecture and coding standards


