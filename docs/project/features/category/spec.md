# Technical Spec: Category Feature

> **Last Updated**: January 2026

---

## Overview

The category feature allows users to browse products through category navigation, search, filter, and sort capabilities. It uses multiple API endpoints to fetch categories and products.

---

## API Endpoints

### Get Categories

Fetches all available categories.

```http
GET /api/v1/categories HTTP/1.1
```

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Women's Fashion",
      "name_ar": "أزياء نسائية",
      "image_url": "https://...",
      "parent_id": null,
      "product_count": 245,
      "children": [
        {
          "id": "uuid",
          "name": "Dresses",
          "name_ar": "فساتين",
          "image_url": "https://...",
          "parent_id": "parent-uuid",
          "product_count": 89
        }
      ]
    }
  ]
}
```

---

### Get Products (with filters & sorting)

Fetches products with optional filtering and sorting.

```http
GET /api/v1/products HTTP/1.1
```

**Query Parameters:**

| Param | Type | Example | Description |
|-------|------|---------|-------------|
| `filter[category]` | `uuid` | `filter[category]=abc123` | Filter by category ID |
| `filter[brand]` | `uuid` | `filter[brand]=xyz789` | Filter by brand ID |
| `filter[color]` | `uuid` | `filter[color]=red123` | Filter by color ID |
| `filter[occasion]` | `uuid` | `filter[occasion]=casual` | Filter by occasion |
| `filter[price_from]` | `number` | `filter[price_from]=50` | Minimum price |
| `filter[price_to]` | `number` | `filter[price_to]=200` | Maximum price |
| `filter[quality_status]` | `string` | `filter[quality_status]=new` | Product condition |
| `filter[trending]` | `boolean` | `filter[trending]=true` | Trending products |
| `filter[discounted]` | `boolean` | `filter[discounted]=true` | Discounted products |
| `filter[most_liked]` | `boolean` | `filter[most_liked]=true` | Most liked products |
| `search` | `string` | `search=blue dress` | Search query |
| `sort` | `string` | `sort=-date` | Sort order |
| `page` | `number` | `page=1` | Page number |
| `per_page` | `number` | `per_page=20` | Items per page |

**Sort Options:**

| Value | Description |
|-------|-------------|
| `-date` | Newest first (default) |
| `date` | Oldest first |
| `price` | Price: Low to High |
| `-price` | Price: High to Low |
| `discount` | Most discounted |

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Summer Dress",
      "description": "Beautiful summer dress...",
      "image_url": "https://...",
      "images": ["https://...", "https://..."],
      "price": 120.00,
      "price_after_discount": 99.00,
      "category": {
        "id": "uuid",
        "name": "Dresses"
      },
      "brand": {
        "id": "uuid",
        "name": "Zara"
      },
      "color": {
        "id": "uuid",
        "name": "Navy Blue",
        "hex": "#000080"
      },
      "quality_status": "like_new",
      "sizes": {
        "eu": "38",
        "uk": "10",
        "letter": "M"
      },
      "store": {
        "id": "uuid",
        "name": "Sarah's Closet"
      },
      "created_at": "2026-01-05T10:30:00Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 20,
    "total": 98
  }
}
```

---

### Get Filter Options

Fetches available filter options (colors, sizes, brands).

```http
GET /api/v1/colors HTTP/1.1
```

```http
GET /api/v1/sizes HTTP/1.1
```

```http
GET /api/v1/brands HTTP/1.1
```

```http
GET /api/v1/quality-statuses HTTP/1.1
```

**Colors Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Black",
      "name_ar": "أسود",
      "hex": "#000000"
    }
  ]
}
```

**Sizes Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "type": "letter",
      "value": "M",
      "display": "Medium (M)"
    }
  ]
}
```

**Quality Statuses Response:**
```json
{
  "data": [
    {
      "id": "new",
      "name": "New",
      "name_ar": "جديد"
    },
    {
      "id": "like_new",
      "name": "Like New",
      "name_ar": "كالجديد"
    },
    {
      "id": "good",
      "name": "Good",
      "name_ar": "جيد"
    },
    {
      "id": "fair",
      "name": "Fair",
      "name_ar": "مقبول"
    }
  ]
}
```

---

## Data Models

### Category

```dart
@immutable
class Category extends Equatable {
  const Category({
    required this.id,
    required this.name,
    this.nameAr,
    this.imageUrl,
    this.parentId,
    this.productCount,
    this.children = const [],
  });

  final String id;
  final String name;
  final String? nameAr;
  final String? imageUrl;
  final String? parentId;
  final int? productCount;
  final List<Category> children;

  bool get hasChildren => children.isNotEmpty;
  bool get isRoot => parentId == null;

  @override
  List<Object?> get props => [id, name, nameAr, imageUrl, parentId, productCount, children];
}
```

### ProductFilter

```dart
@immutable
class ProductFilter extends Equatable {
  const ProductFilter({
    this.categoryId,
    this.brandIds = const [],
    this.colorIds = const [],
    this.qualityStatuses = const [],
    this.priceMin,
    this.priceMax,
    this.searchQuery,
  });

  final String? categoryId;
  final List<String> brandIds;
  final List<String> colorIds;
  final List<String> qualityStatuses;
  final double? priceMin;
  final double? priceMax;
  final String? searchQuery;

  bool get hasActiveFilters =>
      brandIds.isNotEmpty ||
      colorIds.isNotEmpty ||
      qualityStatuses.isNotEmpty ||
      priceMin != null ||
      priceMax != null;

  int get activeFilterCount {
    int count = 0;
    if (brandIds.isNotEmpty) count++;
    if (colorIds.isNotEmpty) count++;
    if (qualityStatuses.isNotEmpty) count++;
    if (priceMin != null || priceMax != null) count++;
    return count;
  }

  ProductFilter copyWith({
    String? categoryId,
    List<String>? brandIds,
    List<String>? colorIds,
    List<String>? qualityStatuses,
    double? priceMin,
    double? priceMax,
    String? searchQuery,
  }) {
    return ProductFilter(
      categoryId: categoryId ?? this.categoryId,
      brandIds: brandIds ?? this.brandIds,
      colorIds: colorIds ?? this.colorIds,
      qualityStatuses: qualityStatuses ?? this.qualityStatuses,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  ProductFilter clear() => ProductFilter(categoryId: categoryId);

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (categoryId != null) params['filter[category]'] = categoryId;
    if (brandIds.isNotEmpty) params['filter[brand]'] = brandIds.join(',');
    if (colorIds.isNotEmpty) params['filter[color]'] = colorIds.join(',');
    if (qualityStatuses.isNotEmpty) params['filter[quality_status]'] = qualityStatuses.join(',');
    if (priceMin != null) params['filter[price_from]'] = priceMin;
    if (priceMax != null) params['filter[price_to]'] = priceMax;
    if (searchQuery != null && searchQuery!.isNotEmpty) params['search'] = searchQuery;
    return params;
  }

  @override
  List<Object?> get props => [categoryId, brandIds, colorIds, qualityStatuses, priceMin, priceMax, searchQuery];
}
```

### ProductSort

```dart
enum ProductSort {
  newest('-date', 'Newest First'),
  oldest('date', 'Oldest First'),
  priceLowToHigh('price', 'Price: Low to High'),
  priceHighToLow('-price', 'Price: High to Low'),
  mostDiscounted('discount', 'Most Discounted');

  const ProductSort(this.value, this.displayName);

  final String value;
  final String displayName;
}
```

### Color

```dart
@immutable
class ProductColor extends Equatable {
  const ProductColor({
    required this.id,
    required this.name,
    this.nameAr,
    this.hex,
  });

  final String id;
  final String name;
  final String? nameAr;
  final String? hex;

  Color? get color => hex != null ? Color(int.parse(hex!.replaceFirst('#', '0xFF'))) : null;

  @override
  List<Object?> get props => [id, name, nameAr, hex];
}
```

### Size

```dart
@immutable
class ProductSize extends Equatable {
  const ProductSize({
    required this.id,
    required this.type,
    required this.value,
    this.display,
  });

  final String id;
  final String type; // 'eu', 'uk', 'letter'
  final String value;
  final String? display;

  @override
  List<Object?> get props => [id, type, value, display];
}
```

### FilterOptions

```dart
@immutable
class FilterOptions extends Equatable {
  const FilterOptions({
    required this.colors,
    required this.sizes,
    required this.brands,
    required this.qualityStatuses,
    this.priceRange,
  });

  final List<ProductColor> colors;
  final List<ProductSize> sizes;
  final List<Brand> brands;
  final List<QualityStatus> qualityStatuses;
  final PriceRange? priceRange;

  @override
  List<Object?> get props => [colors, sizes, brands, qualityStatuses, priceRange];
}

@immutable
class PriceRange extends Equatable {
  const PriceRange({required this.min, required this.max});

  final double min;
  final double max;

  @override
  List<Object?> get props => [min, max];
}
```

---

## Controllers

### CategoryController

```dart
class CategoryController extends AsyncNotifier<List<Category>> {
  static final provider = AsyncNotifierProvider<CategoryController, List<Category>>(
    CategoryController.new,
  );

  @override
  Future<List<Category>> build() async {
    return _fetchCategories();
  }

  Future<List<Category>> _fetchCategories() async {
    final api = ref.read(categoryApiProvider);
    return api.getCategories();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchCategories);
  }

  List<Category> getSubcategories(String parentId) {
    final categories = state.valueOrNull ?? [];
    for (final category in categories) {
      if (category.id == parentId) {
        return category.children;
      }
      for (final child in category.children) {
        if (child.id == parentId) {
          return child.children;
        }
      }
    }
    return [];
  }
}
```

### CategoryProductsController

```dart
class CategoryProductsController extends AutoDisposeFamilyAsyncNotifier<PaginatedProducts, String> {
  static final provider = AsyncNotifierProvider.autoDispose
      .family<CategoryProductsController, PaginatedProducts, String>(
    CategoryProductsController.new,
  );

  late ProductFilter _filter;
  late ProductSort _sort;

  @override
  Future<PaginatedProducts> build(String categoryId) async {
    _filter = ProductFilter(categoryId: categoryId);
    _sort = ProductSort.newest;
    return _fetchProducts(page: 1);
  }

  Future<PaginatedProducts> _fetchProducts({required int page}) async {
    final api = ref.read(productApiProvider);
    return api.getProducts(
      filter: _filter,
      sort: _sort,
      page: page,
    );
  }

  Future<void> applyFilter(ProductFilter filter) async {
    _filter = filter.copyWith(categoryId: arg);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchProducts(page: 1));
  }

  Future<void> applySort(ProductSort sort) async {
    _sort = sort;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchProducts(page: 1));
  }

  Future<void> search(String query) async {
    _filter = _filter.copyWith(searchQuery: query.isEmpty ? null : query);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchProducts(page: 1));
  }

  Future<void> loadMore() async {
    final currentData = state.valueOrNull;
    if (currentData == null || !currentData.hasMore) return;

    final nextPage = currentData.currentPage + 1;
    final newData = await _fetchProducts(page: nextPage);

    state = AsyncData(PaginatedProducts(
      products: [...currentData.products, ...newData.products],
      currentPage: newData.currentPage,
      lastPage: newData.lastPage,
      total: newData.total,
    ));
  }

  void clearFilters() {
    _filter = ProductFilter(categoryId: arg);
    applyFilter(_filter);
  }

  ProductFilter get currentFilter => _filter;
  ProductSort get currentSort => _sort;
}
```

### FilterOptionsController

```dart
class FilterOptionsController extends AsyncNotifier<FilterOptions> {
  static final provider = AsyncNotifierProvider<FilterOptionsController, FilterOptions>(
    FilterOptionsController.new,
  );

  @override
  Future<FilterOptions> build() async {
    return _fetchFilterOptions();
  }

  Future<FilterOptions> _fetchFilterOptions() async {
    final api = ref.read(helperApiProvider);

    // Fetch all filter options in parallel
    final results = await Future.wait([
      api.getColors(),
      api.getSizes(),
      api.getBrands(),
      api.getQualityStatuses(),
    ]);

    return FilterOptions(
      colors: results[0] as List<ProductColor>,
      sizes: results[1] as List<ProductSize>,
      brands: results[2] as List<Brand>,
      qualityStatuses: results[3] as List<QualityStatus>,
      priceRange: const PriceRange(min: 0, max: 1000), // Default range
    );
  }
}
```

---

## API Services

### CategoryApi

```dart
abstract class CategoryApi {
  Future<List<Category>> getCategories();
}

class CategoryApiImpl implements CategoryApi {
  CategoryApiImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<Category>> getCategories() async {
    final response = await _client.get('/api/v1/categories');
    final List<dynamic> data = response.data['data'];
    return data.map((json) => Category.fromJson(json)).toList();
  }
}

final categoryApiProvider = Provider<CategoryApi>((ref) {
  return CategoryApiImpl(ref.read(apiClientProvider));
});
```

### ProductApi

```dart
abstract class ProductApi {
  Future<PaginatedProducts> getProducts({
    required ProductFilter filter,
    required ProductSort sort,
    int page = 1,
    int perPage = 20,
  });
}

class ProductApiImpl implements ProductApi {
  ProductApiImpl(this._client);

  final ApiClient _client;

  @override
  Future<PaginatedProducts> getProducts({
    required ProductFilter filter,
    required ProductSort sort,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = {
      ...filter.toQueryParams(),
      'sort': sort.value,
      'page': page,
      'per_page': perPage,
    };

    final response = await _client.get(
      '/api/v1/products',
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data['data'];
    final meta = response.data['meta'];

    return PaginatedProducts(
      products: data.map((json) => Product.fromJson(json)).toList(),
      currentPage: meta['current_page'],
      lastPage: meta['last_page'],
      total: meta['total'],
    );
  }
}

final productApiProvider = Provider<ProductApi>((ref) {
  return ProductApiImpl(ref.read(apiClientProvider));
});
```

---

## File Structure

```
lib/
├── domain/model/
│   ├── category.dart
│   ├── product.dart
│   ├── product_filter.dart
│   ├── product_sort.dart
│   ├── product_color.dart
│   ├── product_size.dart
│   ├── filter_options.dart
│   └── paginated_products.dart
│
├── feature/category/
│   ├── data/
│   │   ├── category_api.dart
│   │   └── product_api.dart
│   ├── deps/
│   │   └── category_deps.dart
│   ├── logic/
│   │   ├── category_controller.dart
│   │   ├── category_products_controller.dart
│   │   └── filter_options_controller.dart
│   └── ui/
│       ├── category_screen.dart
│       ├── category_grid.dart
│       ├── category_card.dart
│       ├── product_list_screen.dart
│       ├── filter_bottom_sheet.dart
│       ├── sort_bottom_sheet.dart
│       └── search_bar.dart
│
└── ui/widget/
    └── product_card.dart       # Shared widget
```

---

## Screen Implementation

### CategoryScreen

```dart
@RoutePage()
class CategoryScreen extends HookConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(CategoryController.provider);
    final searchQuery = useState('');
    final isSearching = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: isSearching.value
            ? CategorySearchBar(
                onChanged: (query) => searchQuery.value = query,
                onClose: () {
                  isSearching.value = false;
                  searchQuery.value = '';
                },
              )
            : const Text('Categories'),
        actions: [
          if (!isSearching.value)
            IconButton(
              icon: const Icon(LucideIcons.search),
              onPressed: () => isSearching.value = true,
            ),
        ],
      ),
      body: categoriesAsync.when(
        loading: () => const CategoryGridShimmer(),
        error: (e, _) => CategoryError(
          onRetry: () => ref.invalidate(CategoryController.provider),
        ),
        data: (categories) => CategoryGrid(
          categories: _filterCategories(categories, searchQuery.value),
          onCategoryTap: (category) {
            if (category.hasChildren) {
              context.pushRoute(SubcategoryRoute(category: category));
            } else {
              context.pushRoute(ProductListRoute(categoryId: category.id));
            }
          },
        ),
      ),
    );
  }

  List<Category> _filterCategories(List<Category> categories, String query) {
    if (query.isEmpty) return categories;
    return categories
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
```

### ProductListScreen

```dart
@RoutePage()
class ProductListScreen extends HookConsumerWidget {
  const ProductListScreen({
    super.key,
    @PathParam('categoryId') required this.categoryId,
    this.categoryName,
  });

  final String categoryId;
  final String? categoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(CategoryProductsController.provider(categoryId));
    final controller = ref.read(CategoryProductsController.provider(categoryId).notifier);
    final scrollController = useScrollController();

    // Infinite scroll
    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          controller.loadMore();
        }
      }
      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName ?? 'Products'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () => _showSearch(context, controller),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Sort Bar
          FilterSortBar(
            filterCount: controller.currentFilter.activeFilterCount,
            sortLabel: controller.currentSort.displayName,
            onFilterTap: () => _showFilterSheet(context, ref),
            onSortTap: () => _showSortSheet(context, ref),
          ),

          // Product Grid
          Expanded(
            child: productsAsync.when(
              loading: () => const ProductGridShimmer(),
              error: (e, _) => ProductListError(
                onRetry: () => ref.invalidate(
                  CategoryProductsController.provider(categoryId),
                ),
              ),
              data: (data) => data.products.isEmpty
                  ? const EmptyProductList()
                  : ProductGrid(
                      controller: scrollController,
                      products: data.products,
                      onProductTap: (product) {
                        context.pushRoute(ProductDetailRoute(productId: product.id));
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterBottomSheet(
        categoryId: categoryId,
        currentFilter: ref.read(
          CategoryProductsController.provider(categoryId).notifier,
        ).currentFilter,
        onApply: (filter) {
          ref.read(
            CategoryProductsController.provider(categoryId).notifier,
          ).applyFilter(filter);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSortSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SortBottomSheet(
        currentSort: ref.read(
          CategoryProductsController.provider(categoryId).notifier,
        ).currentSort,
        onSelect: (sort) {
          ref.read(
            CategoryProductsController.provider(categoryId).notifier,
          ).applySort(sort);
          Navigator.pop(context);
        },
      ),
    );
  }
}
```

### FilterBottomSheet

```dart
class FilterBottomSheet extends HookConsumerWidget {
  const FilterBottomSheet({
    super.key,
    required this.categoryId,
    required this.currentFilter,
    required this.onApply,
  });

  final String categoryId;
  final ProductFilter currentFilter;
  final ValueChanged<ProductFilter> onApply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterOptionsAsync = ref.watch(FilterOptionsController.provider);
    final filter = useState(currentFilter);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filter', style: Theme.of(context).textTheme.titleLarge),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Filter Content
              Expanded(
                child: filterOptionsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Failed to load filters')),
                  data: (options) => ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Price Range
                      _buildPriceRange(context, filter, options.priceRange),
                      const Divider(),

                      // Condition
                      _buildConditionFilter(context, filter, options.qualityStatuses),
                      const Divider(),

                      // Colors
                      _buildColorFilter(context, filter, options.colors),
                      const Divider(),

                      // Brands
                      _buildBrandFilter(context, filter, options.brands),
                    ],
                  ),
                ),
              ),

              // Actions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => filter.value = ProductFilter(categoryId: categoryId),
                        child: const Text('Clear All'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => onApply(filter.value),
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ... filter section builders
}
```

---

## Analytics Events

| Event | When | Properties |
|-------|------|------------|
| `category_viewed` | Category screen opened | — |
| `category_tapped` | Category card clicked | `category_id`, `category_name` |
| `product_list_viewed` | Product list opened | `category_id` |
| `search_performed` | Search executed | `query`, `category_id`, `results_count` |
| `filter_applied` | Filters applied | `filter_type`, `values`, `category_id` |
| `filter_cleared` | Filters cleared | `category_id` |
| `sort_changed` | Sort option changed | `sort_value`, `category_id` |
| `product_tapped` | Product card clicked | `product_id`, `category_id` |
| `load_more` | Infinite scroll triggered | `page`, `category_id` |

---

## Checklist

- [ ] Category model created
- [ ] ProductFilter model created
- [ ] ProductSort enum created
- [ ] FilterOptions model created
- [ ] CategoryApi implemented
- [ ] ProductApi with filtering/sorting implemented
- [ ] CategoryController with static provider
- [ ] CategoryProductsController with pagination
- [ ] FilterOptionsController
- [ ] CategoryScreen with grid view
- [ ] CategoryCard widget
- [ ] ProductListScreen with grid
- [ ] FilterBottomSheet with all filter options
- [ ] SortBottomSheet with radio options
- [ ] Search functionality with debounce
- [ ] Infinite scroll pagination
- [ ] Loading shimmer states
- [ ] Error handling with retry
- [ ] Empty state handling
- [ ] Pull to refresh
- [ ] Analytics events
- [ ] Localization keys

---

## References

- [Category PRD](./prd.md) — Product requirements
- [Home Spec](/docs/features/home/spec.md) — ProductCard widget reference
- [API Documentation](/docs/api.md) — Backend API reference
- [Agent Guidelines](/agent.md) — Architecture and coding standards
