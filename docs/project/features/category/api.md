# Category API

> Endpoints for category products with filtering and sorting.

---

## Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/products` | List products with filters | No |
| GET | `/api/v1/categories` | List categories | No |
| GET | `/api/v1/brands` | List brands for filter | No |
| GET | `/api/v1/colors` | List colors for filter | No |
| GET | `/api/v1/occasions` | List occasions for filter | No |

---

## List Products with Filters

Returns products filtered by category and other criteria.

```http
GET /api/v1/products
```

### Filter Parameters

| Parameter | Type | Example | Description |
|-----------|------|---------|-------------|
| `filter[category]` | `uuid` | `?filter[category]=123` | Filter by category |
| `filter[occasion]` | `uuid` | `?filter[occasion]=456` | Filter by occasion |
| `filter[color]` | `uuid` | `?filter[color]=789` | Filter by color |
| `filter[brand]` | `uuid` | `?filter[brand]=abc` | Filter by brand |
| `filter[price_from]` | `number` | `?filter[price_from]=30` | Minimum price |
| `filter[price_to]` | `number` | `?filter[price_to]=50` | Maximum price |
| `filter[discounted]` | `boolean` | `?filter[discounted]=true` | Only discounted |

### Sort Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| `sort` | `date` | Oldest to newest |
| `sort` | `-date` | Newest to oldest |
| `sort` | `price` | Cheapest to most expensive |
| `sort` | `-price` | Most expensive to cheapest |
| `sort` | `discount` | Most discounted first |

### Pagination

| Parameter | Type | Description |
|-----------|------|-------------|
| `page` | `number` | Page number (starts at 1) |

---

## List Categories

Returns all available categories.

```http
GET /api/v1/categories
```

---

## List Filter Options

```http
GET /api/v1/brands     # Available brands
GET /api/v1/colors     # Available colors
GET /api/v1/occasions  # Available occasions
```

---

## Dart Implementation

```dart
// lib/api/endpoints.dart
static const String products = '/api/v1/products';
static const String categories = '/api/v1/categories';
static const String brands = '/api/v1/brands';
static const String colors = '/api/v1/colors';
static const String occasions = '/api/v1/occasions';
```

```dart
// feature/category/data/product_api.dart
class ProductApi {
  const ProductApi(this._dio);
  final Dio _dio;

  Future<Paginated<Product>> getProducts({
    String? categoryId,
    String? brandId,
    String? colorId,
    double? priceFrom,
    double? priceTo,
    String? sort,
    int page = 1,
  }) async {
    final response = await _dio.get(
      Endpoints.products,
      queryParameters: {
        if (categoryId != null) 'filter[category]': categoryId,
        if (brandId != null) 'filter[brand]': brandId,
        if (colorId != null) 'filter[color]': colorId,
        if (priceFrom != null) 'filter[price_from]': priceFrom,
        if (priceTo != null) 'filter[price_to]': priceTo,
        if (sort != null) 'sort': sort,
        'page': page,
      },
    );

    return Paginated<Product>.fromJson(
      response.data,
      (json) => Product.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<FilterOptions> getFilterOptions() async {
    final responses = await Future.wait([
      _dio.get(Endpoints.brands),
      _dio.get(Endpoints.colors),
      _dio.get(Endpoints.occasions),
    ]);

    return FilterOptions(
      brands: _parseBrands(responses[0]),
      colors: _parseColors(responses[1]),
      occasions: _parseOccasions(responses[2]),
    );
  }
}
```
