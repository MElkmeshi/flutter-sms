# App Initializer Architecture

> **For AI Agents & Developers**: This document defines the initialization pattern for third-party services.

---

## Overview

The App Initializer is responsible for initializing all third-party services **before** the app launches. This ensures services are ready when widgets need them, avoiding async initialization in widgets.

---

## Why This Pattern?

1. **Synchronous Access**: Services are initialized before `runApp()`, so providers can access them synchronously
2. **Fail Fast**: Initialization errors are caught before the app starts
3. **Centralized**: All service setup in one place, easy to audit and maintain
4. **Testable**: Services can be mocked by providing different overrides

---

## 🔐 Critical Security Rule: NEVER Block App Startup

**RULE**: The initializer MUST NOT await:
- ❌ `FlutterSecureStorage.read()` or `.write()`
- ❌ Network calls
- ❌ Token refresh logic

**WHY**: First Flutter frame must render immediately (≤800ms target).
- SecureStorage operations take ~400ms due to encryption overhead
- This would delay app startup and create poor user experience

**SOLUTION**: Lazy Loading Pattern
1. **At Startup**: Read `isLoggedIn` from SharedPreferences (~1ms)
2. **For Routing**: Use the flag for instant navigation decisions
3. **On First API Request**: Load token from SecureStorage (~400ms)
4. **Cache in Memory**: Store token to avoid repeated reads (~instant)

**Performance Impact**:
- Routing decision: ~1ms (SharedPreferences)
- First API request: +400ms (one-time secure storage read)
- Subsequent requests: ~instant (cached)

**See**: [Authentication Architecture](./authentication.md) for full requirements.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         main.dart                                │
├─────────────────────────────────────────────────────────────────┤
│  1. WidgetsFlutterBinding.ensureInitialized()                   │
│  2. final services = await AppInitializer.initialize()           │
│  3. runApp(ProviderScope(                                        │
│       overrides: AppProviders.overrides(services),               │
│       child: MyApp(),                                        │
│     ))                                                           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      AppInitializer                              │
├─────────────────────────────────────────────────────────────────┤
│  static Future<AppServices> initialize() async {                 │
│    // ✅ Fast operations only (~50ms)                            │
│    final sharedPreferences = await SharedPreferences.getInstance │
│    final secureStorage = FlutterSecureStorage()  // No read!     │
│                                                                  │
│    // 🔐 NEVER do this at startup:                              │
│    // ❌ await secureStorage.read(key: 'token')  // ~400ms!!    │
│    // ❌ await http.get('/refresh-token')                       │
│                                                                  │
│    return AppServices(                                           │
│      sharedPreferences: sharedPreferences,                       │
│      secureStorage: secureStorage,                               │
│    );                                                            │
│  }                                                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                       AppServices                                │
├─────────────────────────────────────────────────────────────────┤
│  @immutable                                                      │
│  class AppServices {                                             │
│    final SharedPreferences sharedPreferences;  // Fast (~1ms)    │
│    final FlutterSecureStorage secureStorage;   // Instance only  │
│    // Future: Firebase, Sentry, Pusher, etc.                    │
│  }                                                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      AppProviders                                │
├─────────────────────────────────────────────────────────────────┤
│  static List<Override> overrides(AppServices services) => [      │
│    sharedPreferencesProvider.overrideWithValue(...),             │
│    firebaseAppProvider.overrideWithValue(...),                   │
│    pusherClientProvider.overrideWithValue(...),                  │
│  ];                                                              │
└─────────────────────────────────────────────────────────────────┘
```

---

## File Structure

```
lib/core/initializer/
├── app_initializer.dart    # Initialization logic + AppServices class
└── app_providers.dart      # Provider definitions + overrides helper
```

---

## Implementation

### AppServices (Data Class)

Holds all initialized service instances:

```dart
@immutable
class AppServices {
  const AppServices({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  // Future services:
  // final FirebaseApp firebaseApp;
  // final PusherClient pusherClient;
}
```

### AppInitializer

Static class that initializes all services:

```dart
abstract class AppInitializer {
  AppInitializer._();

  static Future<AppServices> initialize() async {
    // Initialize secure storage (sync, just creates object)
    final secureStorage = _initSecureStorage();

    // Initialize SharedPreferences (async, disk I/O ~50ms)
    final sharedPreferences = await _initSharedPreferences();

    // 🔐 CRITICAL: We do NOT load tokens here!
    // SecureStorage.read() takes ~400ms and would block startup.
    // Use SharedPreferences `isLoggedIn` flag for routing instead.

    return AppServices(
      sharedPreferences: sharedPreferences,
      secureStorage: secureStorage,
    );
  }

  static Future<SharedPreferences> _initSharedPreferences() {
    return SharedPreferences.getInstance();
  }

  static FlutterSecureStorage _initSecureStorage() {
    return const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
  }
}
```

### AppProviders

Defines providers and creates overrides:

```dart
// Provider definitions (throw if not overridden)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden. '
    'Use AppProviders.overrides(services) in ProviderScope.',
  );
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  throw UnimplementedError(
    'secureStorageProvider must be overridden. '
    'Use AppProviders.overrides(services) in ProviderScope.',
  );
});

// Override helper
abstract class AppProviders {
  AppProviders._();

  static List<Override> overrides(AppServices services) {
    return [
      sharedPreferencesProvider.overrideWithValue(services.sharedPreferences),
      secureStorageProvider.overrideWithValue(services.secureStorage),
    ];
  }
}
```

### main.dart Usage

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all services
  final services = await AppInitializer.initialize();

  runApp(
    ProviderScope(
      overrides: AppProviders.overrides(services),
      child: const MyApp(),
    ),
  );
}
```

---

## Adding a New Service

### Step 1: Add to AppServices

```dart
@immutable
class AppServices {
  const AppServices({
    required this.sharedPreferences,
    required this.newService,  // Add here
  });

  final SharedPreferences sharedPreferences;
  final NewService newService;  // Add here
}
```

### Step 2: Initialize in AppInitializer

```dart
static Future<AppServices> initialize() async {
  final sharedPreferences = await _initSharedPreferences();
  final newService = await _initNewService();  // Add here

  return AppServices(
    sharedPreferences: sharedPreferences,
    newService: newService,  // Add here
  );
}

static Future<NewService> _initNewService() async {
  debugPrint('  → NewService');
  return NewService.initialize(...);
}
```

### Step 3: Add Provider in AppProviders

```dart
// Provider definition
final newServiceProvider = Provider<NewService>((ref) {
  throw UnimplementedError('newServiceProvider must be overridden.');
});

// Add to overrides
static List<Override> overrides(AppServices services) {
  return [
    sharedPreferencesProvider.overrideWithValue(services.sharedPreferences),
    newServiceProvider.overrideWithValue(services.newService),  // Add here
  ];
}
```

### Step 4: Use in Features

```dart
final myRepository = Provider<MyRepository>((ref) {
  final newService = ref.watch(newServiceProvider);
  return MyRepository(newService);
});
```

---

## Services to Initialize

| Service | Package | Status | Purpose | Startup Impact |
|---------|---------|--------|---------|----------------|
| SharedPreferences | `shared_preferences` | ✅ Done | Fast routing hints, UI preferences | ~50ms |
| FlutterSecureStorage | `flutter_secure_storage` | ✅ Done | Encrypted token storage (instance only) | ~0ms (sync) |
| Firebase | `firebase_core` | 🔜 TODO | Analytics, Crashlytics, FCM | TBD |
| Sentry | `sentry_flutter` | 🔜 TODO | Error tracking | TBD |
| Pusher | `pusher_channels_flutter` | 🔜 TODO | Real-time events | TBD |

**Note**: FlutterSecureStorage instance is created at startup, but actual `.read()` operations (~400ms) happen lazily on first API request.

---

## Error Handling

Initialization errors should crash the app early with a clear message:

```dart
static Future<AppServices> initialize() async {
  try {
    // ... initialization
  } catch (e, st) {
    debugPrint('❌ Failed to initialize app services: $e');
    // In production, you might want to show an error screen
    // or report to a crash service that doesn't need initialization
    rethrow;
  }
}
```

---

## Testing

In tests, provide mock services directly:

```dart
void main() {
  testWidgets('my test', (tester) async {
    final mockPrefs = MockSharedPreferences();
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
        child: const MyWidget(),
      ),
    );
  });
}
```

---

## Rules

1. **🔐 NEVER block on SecureStorage** — No `.read()` or `.write()` calls at startup (PR BLOCKER)
2. **Performance target: ≤800ms** — First Flutter frame must render immediately
3. **Lazy load sensitive data** — Use SharedPreferences flags for routing, load tokens on first API call
4. **All async initialization in AppInitializer** — Never initialize services in widgets
5. **Providers throw if not overridden** — Catch configuration errors early
6. **Services are immutable** — AppServices is `@immutable`
7. **Log initialization steps** — Helps debug startup issues
8. **Fail fast** — Let initialization errors crash the app

---

## References

- [Agent Guidelines](/agent.md) — Architecture and coding standards
- [Controller Architecture](/docs/architecture/controllers.md) — Provider patterns


