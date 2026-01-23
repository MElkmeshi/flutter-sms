# Dio Specs

> **Package**: `dio`  
> **Docs**: https://pub.dev/packages/dio

## Overview

Dio is our HTTP client for making network requests. We use it with custom interceptors for authentication, logging, and error handling.

## Configuration

See the main API client configuration in the architecture docs: [API Client Architecture](/docs/architecture/api_client.md)

## Usage Patterns

### Never Create Dio Instances Directly

Always inject Dio through Riverpod providers:

```dart
// ✅ CORRECT — Use provider
class OrdersApi {
  const OrdersApi(this._dio);
  final Dio _dio;
}

final ordersApiProvider = Provider<OrdersApi>((ref) {
  return OrdersApi(ref.watch(dioProvider));
});

// ❌ WRONG — Direct instantiation
class OrdersApi {
  final dio = Dio();  // NEVER DO THIS
}
```

### Request Methods

```dart
// GET request
final response = await dio.get('/api/v1/products');

// GET with query params
final response = await dio.get(
  '/api/v1/products',
  queryParameters: {'filter[category]': categoryId},
);

// POST request
final response = await dio.post(
  '/api/v1/otp/requests',
  data: {'phone_number': phoneNumber},
);

// POST with FormData (file uploads)
final formData = FormData.fromMap({
  'file': await MultipartFile.fromFile(filePath),
});
final response = await dio.post('/api/upload', data: formData);

// PATCH request
final response = await dio.patch(
  '/api/v1/products/$productId',
  data: productData,
);

// DELETE request
await dio.delete('/api/v1/products/$productId');
```

## Common Gotchas

### 1. Don't Parse Responses in API Classes

Let interceptors handle error transformation:

```dart
// ✅ CORRECT — Simple response handling
Future<List<Order>> getOrders() async {
  final response = await _dio.get('/orders');
  return (response.data as List)
      .map((json) => Order.fromJson(json))
      .toList();
}

// ❌ WRONG — Manual error handling (interceptors do this)
Future<List<Order>> getOrders() async {
  try {
    final response = await _dio.get('/orders');
    if (response.statusCode == 200) {
      // ...
    }
  } catch (e) {
    // ...
  }
}
```

### 2. Timeouts Are Set Globally

Don't override timeouts per-request unless absolutely necessary:

```dart
// ❌ AVOID — Per-request timeout override
await dio.get('/slow-endpoint', options: Options(
  receiveTimeout: Duration(seconds: 60),  // Usually not needed
));
```

### 3. FormData for Multipart Requests

Always use `FormData` for file uploads:

```dart
// ✅ CORRECT — FormData for files
final formData = FormData.fromMap({
  'profile_picture': await MultipartFile.fromFile(imagePath),
  'name': 'Ahmed',
});

// ❌ WRONG — Map won't work for files
await dio.post('/profile', data: {
  'profile_picture': File(imagePath),  // WRONG
});
```

## References

- [API Client Architecture](/docs/architecture/api_client.md)
- [Error Handling](/agent.md#error-handling)


