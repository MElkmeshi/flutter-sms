# Authentication Architecture

> **For AI Agents & Developers**: This document defines the authentication architecture and security rules for Flutter apps.

---

## Overview

This document outlines the **mandatory** authentication patterns for secure, performant token management in Flutter applications.

These are **architectural principles**, not feature-specific requirements. They apply to any authentication implementation.

---

## 🔐 Non-negotiable Principles

**Security is mandatory. Performance is mandatory.**
Architecture must satisfy **both**.

> **Status**: ACTIVE
> **Enforcement**: PR BLOCKER
> **Last Updated**: January 11, 2026

---

## 10 Hard Rules

### 1. NEVER block app startup on secure storage ❌

**Rule**: `runApp()` must not await:
- `FlutterSecureStorage.read()`
- Network calls
- Token refresh logic

**Requirement**: First Flutter frame must render immediately.

**Example Implementation**:
- AppInitializer doesn't await secure storage reads
- Explicitly skips token loading at startup

---

### 2. Tokens MUST be stored in secure storage ✅

**Rule**: Access tokens, refresh tokens, JWTs MUST NOT be stored in:
- SharedPreferences
- Memory-only variables
- Files or databases

**Requirement**: Use `flutter_secure_storage` only.

**Example Implementation**:
- Store access token in FlutterSecureStorage
- Implement in-memory cache to avoid repeated reads
- Lazy loading on first API request

---

### 3. SharedPreferences is ONLY for routing hints ✅

**Rule - Allowed Keys**:
- `isLoggedIn` (bool)
- `userId`
- UI / preference flags

**Rule - Disallowed**:
- Tokens
- Secrets
- Authorization headers

**Example Implementation**:
- Use `isLoggedIn` flag for routing
- Store tokens in SecureStorage
- Separation of concerns: routing hints vs. sensitive data

---

### 4. App launch flow is FIXED ✅

**Rule**:
1. App reads `isLoggedIn` from SharedPreferences
2. App routes immediately:
   - `true` → Home
   - `false` → Login
3. Secure token read happens **after navigation**, not before

**Example Implementation**:
- AuthController uses `isLoggedIn()` flag for auth state
- AuthGuard routes based on `isLoggedIn()` flag
- Token loaded lazily on first API request (not at startup)

---

### 5. Token access MUST be lazy ✅

**Rule**: Tokens are loaded:
- On first API request
- Or when required by interceptor
- Cached in memory after first read
- Secure storage must not be read repeatedly

**Example Implementation**:
- AppInitializer skips token loading at startup
- Token read on first API request via HTTP interceptor
- In-memory cache prevents repeated reads

---

### 6. HTTP layer owns tokens ✅

**Rule**: UI code MUST NOT read tokens directly.

Token access is centralized in:
- AuthRepository
- TokenManager
- HTTP interceptor

**Example Implementation**:
- AuthInterceptor owns token access
- UI code only reacts to authenticated/unauthenticated state

---

### 7. Optimistic routing is REQUIRED ✅

**Rule**:
- If `isLoggedIn == true`, show Home immediately
- If secure read or refresh fails:
  - Clear secure storage
  - Set `isLoggedIn = false`
  - Force logout
- No splash delays. No loading spinners on boot.

**Example Implementation**:
- Route based on `isLoggedIn()` flag (synchronous)
- AuthGuard makes instant routing decision
- 401 errors trigger full auth clear
- No blocking operations at startup

---

### 8. Logout MUST be destructive ✅

**Rule**: On logout:
- Clear secure storage
- Clear in-memory token cache
- Set `isLoggedIn = false`
- Reset app state

Partial logout is forbidden.

**Example Implementation**:
- AuthController calls `clearAuth()` for full cleanup
- Destructive operation that clears:
  - Secure storage token
  - In-memory cache
  - SharedPreferences `isLoggedIn` flag
- State updated to trigger UI re-render

---

### 9. One secure read per launch ✅

**Rule**:
- Secure storage reads MUST be cached
- Multiple reads per launch = bug

**Example Implementation**:
- AuthRepository has in-memory `_tokenCache` field
- Implements cache-first lookup pattern
- Secure storage read only on cache miss (first API request)
- All subsequent requests use cached value

---

### 10. Performance is a requirement ✅

**Rule**:
- Splash screen ≤ 800ms
- Secure storage access must never be in `main()`
- Any regression above this is a release blocker

**Example Implementation**:
- No secure storage reads at startup
- Routing decision based on SharedPreferences (~1ms)
- Secure storage read deferred to first API request
- In-memory caching prevents repeated slow reads
- No blocking operations before runApp()

---

## Compliance Summary

| Rule | Priority | Key Files |
|------|----------|-----------|
| 1. No blocking on secure storage | Critical | `main.dart`, `app_initializer.dart` |
| 2. Tokens in secure storage | Critical | `auth_repository.dart` |
| 3. SharedPrefs for hints only | Critical | `auth_repository.dart` |
| 4. Fixed launch flow | High | `auth_controller.dart`, `auth_guard.dart` |
| 5. Lazy token access | High | `dio_provider.dart`, `auth_repository.dart` |
| 6. HTTP layer owns tokens | High | `dio_provider.dart` |
| 7. Optimistic routing | Medium | `auth_guard.dart` |
| 8. Destructive logout | High | `auth_controller.dart`, `auth_repository.dart` |
| 9. One secure read | Medium | `auth_repository.dart` |
| 10. Performance ≤800ms | Critical | `main.dart` |

---

## Implementation Pattern

### Storage Layer Separation

```dart
// ✅ CORRECT - Dual storage strategy
class AuthRepository {
  final SharedPreferences _prefs;           // Fast routing hints
  final FlutterSecureStorage _secureStorage; // Encrypted tokens
  String? _tokenCache;                       // In-memory cache

  // Fast synchronous check for routing
  bool isLoggedIn() => _prefs.getBool('isLoggedIn') ?? false;

  // Lazy async token loading with cache
  Future<String?> getAccessToken() async {
    _tokenCache ??= await _secureStorage.read(key: 'access_token');
    return _tokenCache;
  }

  // Set both flag and token
  Future<void> setAccessToken(String token) async {
    await _secureStorage.write(key: 'access_token', value: token);
    _tokenCache = token;
    await _prefs.setBool('isLoggedIn', true);
  }

  // Clear everything on logout
  Future<void> clearAuth() async {
    await _secureStorage.delete(key: 'access_token');
    _tokenCache = null;
    await _prefs.setBool('isLoggedIn', false);
  }
}
```

### Startup Flow

```dart
// ✅ CORRECT - No blocking operations
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services (~50ms total)
  final services = await AppInitializer.initialize();

  runApp(
    ProviderScope(
      overrides: AppProviders.overrides(services),
      child: const MyApp(),
    ),
  );
}

// ✅ CORRECT - Instance creation only
static Future<AppServices> initialize() async {
  final secureStorage = _initSecureStorage();  // Sync, instant
  final prefs = await _initSharedPreferences(); // ~50ms

  // ❌ NEVER do this:
  // await secureStorage.read(key: 'token');  // Would add ~400ms!

  return AppServices(
    sharedPreferences: prefs,
    secureStorage: secureStorage,
  );
}
```

### Routing Guard

```dart
// ✅ CORRECT - Instant routing decision
class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(resolver, router) async {
    final repository = _ref.read(authRepositoryProvider);

    // Fast check (~1ms)
    if (repository.isLoggedIn()) {
      return resolver.next();
    }

    // Not logged in - redirect
    await router.replaceAll([const WelcomeRoute()]);
    return resolver.next(false);
  }
}
```

### HTTP Interceptor

```dart
// ✅ CORRECT - Lazy token loading
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(options, handler) async {
    if (requiresAuth) {
      final repository = _ref.read(authRepositoryProvider);

      // First call: ~400ms (reads from secure storage)
      // Subsequent: ~instant (returns cached value)
      final token = await repository.getAccessToken();

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(err, handler) {
    if (err.response?.statusCode == 401) {
      // Token invalid - clear everything
      unawaited(_clearAuthState());
    }
    handler.next(err);
  }

  Future<void> _clearAuthState() async {
    await _ref.read(authRepositoryProvider).clearAuth();
    _ref.invalidate(AuthController.provider);
  }
}
```

---

## Performance Breakdown

| Operation | Storage | Time | When |
|-----------|---------|------|------|
| Read `isLoggedIn` | SharedPreferences | ~1ms | App startup, routing |
| Read token (first) | FlutterSecureStorage | ~400ms | First API request |
| Read token (cached) | Memory | ~instant | All subsequent requests |
| Write token | FlutterSecureStorage | ~400ms | After login |
| Clear auth | Both | ~400ms | Logout |

**Startup Budget**:
- SharedPreferences init: ~50ms
- SecureStorage instance: ~0ms (sync)
- **Total**: ~50ms (well under 800ms target)

**First API Request**:
- Token load + decrypt: ~400ms (one-time cost)
- Acceptable since user is already past splash screen

---

## Implementation Checklist

When implementing this architecture in your app:

- [ ] Migrate token storage to FlutterSecureStorage
- [ ] Implement in-memory token cache
- [ ] Add `isLoggedIn` flag to SharedPreferences
- [ ] Update AuthController to use `isLoggedIn` flag
- [ ] Update AuthGuard to use `isLoggedIn` flag
- [ ] Update logout to clear all storage layers
- [ ] Run `flutter analyze` (0 issues)
- [ ] Verify splash screen ≤ 800ms (requires runtime testing)
- [ ] Add performance monitoring
- [ ] Update tests for new flow

---

## Enforcement

These rules are **PR blockers**. Code reviews must verify compliance.

Any violations must be fixed before merging to `master`.

---

## References

- [App Initializer Architecture](./initializer.md) - Startup patterns
- [HTTP Client Architecture](./http.md) - API request patterns
- [State Management](./state.md) - Controller patterns
