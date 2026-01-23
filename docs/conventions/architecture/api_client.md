# API Client Architecture

> **Last Updated**: January 2026

## Overview

The app uses a **single Dio instance** for all HTTP requests. This ensures consistent configuration, interceptors, and error handling across the entire application.

---

## Single API Client Rule

### ⚠️ Non-Negotiable

There is **ONE** Dio instance for the entire app, provided via Riverpod:

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

**Never create additional Dio instances.** All API classes receive the shared instance via injection.

---

## Single Endpoints File

### Location

All API endpoints are defined in a **single file**:

```
lib/api/
├── dio_provider.dart      # Dio instance & configuration
├── endpoints.dart         # ALL API endpoints
├── interceptors/
│   ├── auth_interceptor.dart
│   ├── logging_interceptor.dart
│   └── error_interceptor.dart
└── api.dart               # Barrel export
```

### Endpoints File Structure

```dart
// lib/api/endpoints.dart

/// Central registry of all API endpoints.
/// 
/// This file serves as the single source of truth for all API paths.
/// When adding new endpoints, add them here to maintain consistency.
abstract class Endpoints {
  Endpoints._();

  // ─────────────────────────────────────────────────────────────
  // Auth
  // ─────────────────────────────────────────────────────────────
  
  /// Send OTP SMS to phone number
  static const String otpRequest = '/api/v1/otp/requests';
  
  /// Verify OTP code
  /// Usage: Endpoints.otpVerify(uuid)
  static String otpVerify(String uuid) => '/api/v1/otp/requests/$uuid/verify';
  
  /// Logout current user
  static const String logout = '/api/v1/logout';

  // ─────────────────────────────────────────────────────────────
  // Products
  // ─────────────────────────────────────────────────────────────
  
  /// List all products (with optional filters)
  static const String products = '/api/v1/products';
  
  /// Get single product details
  /// Usage: Endpoints.product(uuid)
  static String product(String uuid) => '/api/v1/products/$uuid';

  // ─────────────────────────────────────────────────────────────
  // Reactions
  // ─────────────────────────────────────────────────────────────
  
  /// Toggle product reaction
  /// Usage: Endpoints.productReaction(productUuid)
  static String productReaction(String productUuid) => 
      '/api/v1/reacted-products/$productUuid';

  // ─────────────────────────────────────────────────────────────
  // Plans
  // ─────────────────────────────────────────────────────────────
  
  /// List available subscription plans
  static const String plans = '/api/v1/plans';

  // ─────────────────────────────────────────────────────────────
  // Seller Store
  // ─────────────────────────────────────────────────────────────
  
  /// Create/view/update seller store
  static const String sellerStore = '/api/v1/seller/store';
  
  /// List seller's products
  static const String sellerProducts = '/api/v1/seller/products';
  
  /// Get/update/delete seller product
  /// Usage: Endpoints.sellerProduct(uuid)
  static String sellerProduct(String uuid) => '/api/v1/seller/products/$uuid';
  
  /// Add media to product
  /// Usage: Endpoints.sellerProductMedia(productUuid)
  static String sellerProductMedia(String productUuid) => 
      '/api/v1/seller/products/$productUuid/media';
  
  /// Delete product media
  /// Usage: Endpoints.sellerProductMediaDelete(productUuid, mediaUuid)
  static String sellerProductMediaDelete(String productUuid, String mediaUuid) => 
      '/api/v1/seller/products/$productUuid/media/$mediaUuid';
  
  /// Create/update seller subscription
  static const String sellerSubscriptions = '/api/v1/seller/subscriptions';

  // ─────────────────────────────────────────────────────────────
  // Profile
  // ─────────────────────────────────────────────────────────────
  
  /// View/update profile
  static const String profile = '/api/profile';
  
  /// Check/request account deletion
  static const String profileDeleteRequest = '/api/profile/delete-request';

  // ─────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────
  
  /// List countries
  static const String countries = '/api/v1/countries';
  
  /// List cities
  static const String cities = '/api/v1/cities';
  
  /// List categories
  static const String categories = '/api/v1/categories';
  
  /// List brands
  static const String brands = '/api/v1/brands';
  
  /// List occasions
  static const String occasions = '/api/v1/occasions';
  
  /// List colors
  static const String colors = '/api/v1/colors';
  
  /// List sizes (use filter[type] for eu/uk/letter)
  static const String sizes = '/api/v1/sizes';
  
  /// List renting statuses
  static const String rentingStatuses = '/api/v1/renting-statuses';
  
  /// List quality statuses
  static const String qualityStatuses = '/api/v1/quality-statuses';
  
  /// List delivery types
  static const String deliveryTypes = '/api/v1/delivery-types';
  
  /// List reaction types
  static const String reactionTypes = '/api/v1/reaction-types';
}
```

### Usage in API Classes

```dart
// feature/auth/phone_entry/data/auth_api.dart

class AuthApi {
  const AuthApi(this._dio);
  final Dio _dio;

  Future<OtpResponse> requestOtp(String phoneNumber) async {
    final response = await _dio.post(
      Endpoints.otpRequest,  // ✅ Use Endpoints class
      data: {'phone_number': phoneNumber},
    );
    return OtpResponse.fromJson(response.data);
  }

  Future<AuthResponse> verifyOtp(String uuid, VerifyOtpRequest request) async {
    final response = await _dio.post(
      Endpoints.otpVerify(uuid),  // ✅ Use Endpoints method for dynamic paths
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }
}
```

---

## Interceptors

### Order Matters

Interceptors execute in the order they're added:

```dart
dio.interceptors.addAll([
  AuthInterceptor(ref),    // 1. Adds auth token to requests
  LoggingInterceptor(),    // 2. Logs requests/responses
  ErrorInterceptor(ref),   // 3. Transforms errors
]);
```

### Auth Interceptor

Adds Bearer token to authenticated requests:

```dart
// lib/api/interceptors/auth_interceptor.dart

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref);
  final Ref _ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _ref.read(authTokenProvider);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle token expiration
      _ref.read(authControllerProvider.notifier).logout();
    }
    handler.next(err);
  }
}
```

### Logging Interceptor

Logs requests and responses (dev only):

```dart
// lib/api/interceptors/logging_interceptor.dart

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppEnvironment.flavor == Flavor.dev) {
      log('→ ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (AppEnvironment.flavor == Flavor.dev) {
      log('← ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppEnvironment.flavor == Flavor.dev) {
      log('✗ ${err.response?.statusCode} ${err.requestOptions.uri}');
    }
    handler.next(err);
  }
}
```

### Error Interceptor

Transforms Dio errors into app-specific errors:

```dart
// lib/api/interceptors/error_interceptor.dart

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this._ref);
  final Ref _ref;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log to Sentry
    Sentry.captureException(err, stackTrace: err.stackTrace);

    // Transform to app error
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

---

## PR Blockers

These will **automatically reject PRs**:

- [ ] Creating additional Dio instances
- [ ] Hardcoded endpoint strings (not using `Endpoints` class)
- [ ] Skipping interceptors for "special" requests
- [ ] Manual auth header injection (use `AuthInterceptor`)
- [ ] Catching and swallowing errors without logging

---

## Checklist: Adding New Endpoints

1. [ ] Add endpoint to `lib/api/endpoints.dart`
2. [ ] Use static method for dynamic paths (with parameters)
3. [ ] Document the endpoint with a comment
4. [ ] Update API spec in `docs/api.md` if new endpoint
5. [ ] Use endpoint constant in API class

---

## References

- [API Documentation](/docs/api.md)
- [Error Handling](/agent.md#error-handling)
- [Dio Package Specs](/docs/packages/dio.md)


