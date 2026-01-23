# Home API

> Endpoints for home screen data (products, categories, brands, banners).

---

## Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/products` | List products | No |
| GET | `/api/v1/categories` | List categories | No |
| GET | `/api/v1/brands` | List brands | No |

---

## List Products

Returns products for the home screen sections (trending, discounted, most liked).

```http
GET /api/v1/products
```

### Query Parameters

| Parameter | Type | Example | Description |
|-----------|------|---------|-------------|
| `filter[trending]` | `boolean` | `true` | Trending products |
| `filter[discounted]` | `boolean` | `true` | Discounted products |
| `filter[most_liked]` | `boolean` | `true` | Most liked products |

### Response

Returns paginated list of products.

---

## List Categories

Returns all available categories.

```http
GET /api/v1/categories
```

---

## List Brands

Returns all available brands.

```http
GET /api/v1/brands
```

---

## Dart Implementation

```dart
// lib/api/endpoints.dart
static const String products = '/api/v1/products';
static const String categories = '/api/v1/categories';
static const String brands = '/api/v1/brands';
```

```dart
// feature/home/data/home_api.dart
class HomeApi {
  const HomeApi(this._dio);
  final Dio _dio;

  Future<HomeData> getHomeData() async {
    // Fetch trending, discounted, categories, brands in parallel
    final responses = await Future.wait([
      _dio.get(Endpoints.products, queryParameters: {'filter[trending]': true}),
      _dio.get(Endpoints.products, queryParameters: {'filter[discounted]': true}),
      _dio.get(Endpoints.categories),
      _dio.get(Endpoints.brands),
    ]);

    return HomeData(
      trendingProducts: _parseProducts(responses[0]),
      discountedProducts: _parseProducts(responses[1]),
      categories: _parseCategories(responses[2]),
      brands: _parseBrands(responses[3]),
    );
  }
}
```
