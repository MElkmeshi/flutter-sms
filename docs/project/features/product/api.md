# Product API

> Endpoints for product details and reactions.

---

## Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/products/{uuid}` | Get product details | No |
| POST | `/api/v1/reacted-products/{uuid}` | Toggle reaction | Yes |

---

## Get Product Details

Returns full product details.

```http
GET /api/v1/products/{productUuid}
```

### Path Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `productUuid` | `string` | Product UUID |

### Response

Returns product with all details including:
- Media (images, video)
- Sizes
- Color
- Brand
- Category
- Seller info
- Reactions

---

## Toggle Product Reaction

Adds or removes a reaction on a product.

```http
POST /api/v1/reacted-products/{productUuid}
Authorization: Bearer <token>
```

### Path Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `productUuid` | `string` | Product UUID |

### Request Body

| Field | Type | Validation | Options |
|-------|------|------------|---------|
| `reaction_type` | `string` | Required | `love`, `like`, `fire` |

### Response

Returns updated reaction status.

---

## Dart Implementation

```dart
// lib/api/endpoints.dart
static String product(String uuid) => '/api/v1/products/$uuid';
static String reactedProduct(String uuid) => '/api/v1/reacted-products/$uuid';
```

```dart
// feature/product/data/product_api.dart
class ProductApi {
  const ProductApi(this._dio);
  final Dio _dio;

  Future<ProductDetail> getProduct(String uuid) async {
    final response = await _dio.get(Endpoints.product(uuid));
    return ProductDetail.fromJson(response.data);
  }
}

// feature/product/data/reaction_api.dart
class ReactionApi {
  const ReactionApi(this._dio);
  final Dio _dio;

  Future<void> toggleReaction({
    required String productUuid,
    required String reactionType,
  }) async {
    await _dio.post(
      Endpoints.reactedProduct(productUuid),
      data: {'reaction_type': reactionType},
    );
  }
}
```
