# HTTP & API Layer

> Dio setup, Endpoints pattern, error handling, and pagination.

---

## Key Rules

1. **Single Dio Instance**: One Dio client for the entire app via `dioProvider`
2. **Single Endpoints File**: All API paths in `lib/api/endpoints.dart`
3. **Use Interceptors**: Auth, logging, and error handling via interceptors

---

## Dio Setup

```dart
// lib/api/dio_provider.dart

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppEnvironment.apiBaseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  dio.interceptors.addAll([
    AuthInterceptor(ref),
    LoggingInterceptor(),
    ErrorInterceptor(ref),
  ]);

  return dio;
});
```

---

## Centralized Endpoints

All API endpoints are defined in a single file:

```dart
// lib/api/endpoints.dart

abstract class Endpoints {
  Endpoints._();

  // Auth
  static const String otpRequest = '/api/v1/otp/requests';
  static String otpVerify(String uuid) => '/api/v1/otp/requests/$uuid/verify';
  static const String logout = '/api/v1/logout';

  // Products
  static const String products = '/api/v1/products';
  static String product(String uuid) => '/api/v1/products/$uuid';

  // ... all other endpoints
}
```

---

## API Client Pattern

```dart
// feature/orders/order_list/data/orders_api.dart

class OrdersApi {
  const OrdersApi(this._dio);
  final Dio _dio;

  Future<List<Order>> getOrders() async {
    final response = await _dio.get(Endpoints.products);  // ✅ Use Endpoints
    return (response.data as List)
        .map((json) => Order.fromJson(json))
        .toList();
  }

  Future<Order> getOrder(String id) async {
    final response = await _dio.get(Endpoints.product(id));  // ✅ Use Endpoints
    return Order.fromJson(response.data);
  }
}
```

---

## Paginated Responses

> ⚠️ **CRITICAL** — Always use the generic `Paginated<T>` class. **NEVER** create type-specific paginated classes.

The generic pagination class is at `lib/core/utils/paginated.dart`.

```dart
// ✅ CORRECT — Use generic Paginated<T>
Future<Paginated<Product>> getProducts({int page = 1}) async {
  final response = await _dio.get(
    Endpoints.products,
    queryParameters: {'page': page},
  );

  return Paginated<Product>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Product.fromJson(json as Map<String, dynamic>),
  );
}

// ❌ WRONG — Never create type-specific paginated classes
class PaginatedProducts { ... }  // DON'T DO THIS
class PaginatedOrders { ... }    // DON'T DO THIS
```

### Paginated<T> Properties

| Property/Method | Description |
|-----------------|-------------|
| `items` | The list of items (`List<T>`) |
| `currentPage` | Current page number |
| `lastPage` | Total number of pages |
| `total` | Total item count |
| `hasMore` | Whether more pages exist |
| `canLoadMore` | Whether load more can be triggered |
| `nextPage` | Next page number (or null) |
| `isLoadingMore` | Loading state for pagination UI |

### Controller Usage

```dart
class ProductListController extends AsyncNotifier<Paginated<Product>> {
  static final provider = AsyncNotifierProvider(ProductListController.new);

  @override
  Future<Paginated<Product>> build() => _fetchProducts(page: 1);

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.canLoadMore) return;

    state = AsyncData(current.startLoadingMore());

    try {
      final nextPage = await _fetchProducts(page: current.currentPage + 1);
      state = AsyncData(current.appendPage(nextPage));
    } catch (e) {
      state = AsyncData(current.setLoadMoreError(AppError.from(e)));
    }
  }
}
```

---

## Error Handling

### Error Types

```dart
// domain/util/app_error.dart

sealed class AppError implements Exception {
  const AppError(this.message);
  final String message;
}

class NetworkError extends AppError {
  const NetworkError([super.message = 'Network unavailable']);
}

class ServerError extends AppError {
  const ServerError(super.message, {required this.statusCode});
  final int statusCode;
}

class UnauthorizedError extends AppError {
  const UnauthorizedError() : super('Session expired');
}
```

### Error Interceptor

```dart
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this._ref);
  final Ref _ref;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appError = switch (err.type) {
      DioExceptionType.connectionError => const NetworkError(),
      DioExceptionType.connectionTimeout => const NetworkError('Connection timeout'),
      _ when err.response?.statusCode == 401 => const UnauthorizedError(),
      _ when err.response?.statusCode != null =>
        ServerError(err.message ?? 'Server error', statusCode: err.response!.statusCode!),
      _ => AppError(err.message ?? 'Unknown error'),
    };

    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: appError,
    ));
  }
}
```

### Try-Catch-Finally Pattern

> ⚠️ **CRITICAL** — Always use `finally` to reset loading states.

```dart
// ✅ CORRECT — Always use finally to reset state
Future<void> submitForm() async {
  state = state.copyWith(isLoading: true);

  try {
    await _api.submit(state.data);
    state = state.copyWith(isSuccess: true);
  } on DioException catch (e) {
    state = state.copyWith(errorMessage: e.message);
  } finally {
    state = state.copyWith(isLoading: false);  // Always resets
  }
}
```

---

## PR Blockers

- [ ] Single Dio instance only (via `dioProvider`)
- [ ] All endpoints use `Endpoints` class (no hardcoded paths)
- [ ] Generic `Paginated<T>` — No type-specific paginated classes
- [ ] All async code has error handling
- [ ] Use `finally` to reset `isLoading` state
