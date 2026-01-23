# Flavorizr & Environment Configuration

> **Package**: `flutter_flavorizr` ^2.4.1  
> **Docs**: [flutter_flavorizr](https://pub.dev/packages/flutter_flavorizr)

---

## Overview

We use **flutter_flavorizr** for build flavors (dev/prod) and `--dart-define-from-file` for compile-time environment variables.

**Key Benefits:**
- Single `main.dart` entry point
- All env vars in one file per environment
- Compile-time constants (tree-shaking, no runtime overhead)
- Native iOS/Android flavor support

---

## File Structure

```
project/
├── env/
│   ├── dev.env           # Development environment
│   └── prod.env          # Production environment
├── flavorizr.yaml        # Flavorizr configuration
└── lib/
    ├── main.dart         # Single entry point
    └── domain/util/
        └── app_environment.dart  # Env constants
```

---

## Environment Files

### `env/dev.env`

```env
FLAVOR=dev
API_BASE_URL=https://api-dev.yourapp.com
SENTRY_DSN=
SENTRY_ENVIRONMENT=development
ANALYTICS_ENABLED=false
```

### `env/prod.env`

```env
FLAVOR=prod
API_BASE_URL=https://api.yourapp.com
SENTRY_DSN=https://xxx@sentry.io/xxx
SENTRY_ENVIRONMENT=production
ANALYTICS_ENABLED=true
```

> ⚠️ **Security Note**: For sensitive values like `SENTRY_DSN`, use CI/CD secrets and don't commit real values.

---

## Environment Configuration

### Definition (`lib/domain/util/app_environment.dart`)

```dart
abstract class Env {
  const Env._();

  /// Current flavor (dev, prod)
  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  /// API base URL
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api-dev.yourapp.com',
  );

  /// Sentry DSN for error tracking
  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  /// Sentry environment name
  static const String sentryEnvironment = String.fromEnvironment(
    'SENTRY_ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Whether analytics is enabled
  static const bool analyticsEnabled = bool.fromEnvironment(
    'ANALYTICS_ENABLED',
    defaultValue: false,
  );

  /// Whether this is development mode
  static bool get isDev => flavor == 'dev';

  /// Whether this is production mode
  static bool get isProd => flavor == 'prod';
}
```

### Usage

```dart
// ✅ Compile-time constants
final url = Env.apiBaseUrl;
final dsn = Env.sentryDsn;

if (Env.isDev) {
  // Dev-only code
}

if (Env.analyticsEnabled) {
  // Track analytics
}
```

---

## Flavorizr Configuration

### `flavorizr.yaml`

```yaml
flavors:
  dev:
    app:
      name: "MyApp Dev"
    android:
      applicationId: "com.yourcompany.yourapp.dev"
    ios:
      bundleId: "com.yourcompany.yourapp.dev"

  prod:
    app:
      name: "MyApp"
    android:
      applicationId: "com.yourcompany.yourapp"
    ios:
      bundleId: "com.yourcompany.yourapp"
```

---

## Commands

### Generate Flavors (First Time Setup)

```bash
dart run flutter_flavorizr
```

This generates:
- Android: `productFlavors` in `build.gradle`
- iOS: Schemes and xcconfig files

### Run App

```bash
# Development
flutter run --flavor dev --dart-define-from-file=env/dev.env

# Production
flutter run --flavor prod --dart-define-from-file=env/prod.env
```

### Build App

```bash
# Android APK
flutter build apk --flavor prod --dart-define-from-file=env/prod.env

# Android App Bundle
flutter build appbundle --flavor prod --dart-define-from-file=env/prod.env

# iOS
flutter build ipa --flavor prod --dart-define-from-file=env/prod.env
```

---

## Adding New Environment Variables

1. **Add to both `env/dev.env` and `env/prod.env`**:
   ```env
   NEW_VARIABLE=value
   ```

2. **Add to `app_environment.dart`**:
   ```dart
   static const String newVariable = String.fromEnvironment(
     'NEW_VARIABLE',
     defaultValue: 'default_value',
   );
   ```

---

## How It Works

### `--dart-define-from-file`

- Reads all `KEY=VALUE` pairs from the specified file
- Each becomes available via `String.fromEnvironment('KEY')`
- Resolved at **compile time** (not runtime)
- Values become `const` — enables tree-shaking

### `String.fromEnvironment`

```dart
// Reads KEY from --dart-define or --dart-define-from-file
static const String value = String.fromEnvironment(
  'KEY',
  defaultValue: 'fallback',
);
```

### `bool.fromEnvironment`

```dart
// 'true' → true, anything else → false
static const bool flag = bool.fromEnvironment(
  'FLAG',
  defaultValue: false,
);
```

---

## Common Gotchas

### 1. Values are compile-time only

```dart
// ❌ WRONG — Can't change at runtime
Env.apiBaseUrl = 'new-url';  // Won't compile

// ✅ CORRECT — Read-only const
print(Env.apiBaseUrl);
```

### 2. File must exist

```bash
# ❌ This will fail if file doesn't exist
flutter run --dart-define-from-file=env/missing.env

# ✅ Make sure file exists
flutter run --dart-define-from-file=env/dev.env
```

### 3. Boolean parsing

In env file:
```env
ANALYTICS_ENABLED=true   # → true
ANALYTICS_ENABLED=false  # → false
ANALYTICS_ENABLED=       # → false (empty = false)
```

### 4. Secrets in CI/CD

For CI/CD, generate the env file from secrets:

```yaml
# GitHub Actions example
- name: Create env file
  run: |
    cat > env/prod.env << EOF
    FLAVOR=prod
    API_BASE_URL=https://api.yourapp.com
    SENTRY_DSN=${{ secrets.SENTRY_DSN }}
    ANALYTICS_ENABLED=true
    EOF

- run: flutter build apk --flavor prod --dart-define-from-file=env/prod.env
```

---

## PR Blockers

- [ ] No hardcoded API URLs or secrets in code
- [ ] No `main_dev.dart` or `main_prod.dart` files
- [ ] Environment values only via `Env.*`
- [ ] All env vars have sensible defaults
- [ ] `env/dev.env` and `env/prod.env` exist

---

## References

- [flutter_flavorizr](https://pub.dev/packages/flutter_flavorizr)
- [Dart Environment Declarations](https://dart.dev/guides/environment-declarations)
- [Agent Guidelines](/agent.md#flavors--environments)
