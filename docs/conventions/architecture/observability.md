# Observability

> Sentry, analytics, and error tracking.

---

## Sentry Setup

```dart
Future<void> bootstrap(Flavor flavor) async {
  AppEnvironment.flavor = flavor;

  await SentryFlutter.init(
    (options) {
      options.dsn = AppEnvironment.sentryDsn;
      options.environment = AppEnvironment.sentryEnvironment;
      options.tracesSampleRate = flavor == Flavor.prod ? 0.2 : 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
}
```

---

## What to Capture

| Event | Tool | Required |
|-------|------|----------|
| API failures | Sentry | ✅ |
| Parsing errors | Sentry | ✅ |
| Navigation failures | Sentry | ✅ |
| Unhandled exceptions | Crashlytics + Sentry | ✅ |
| User actions | Analytics | ✅ (prod) |
| Screen views | Analytics | ✅ (prod) |
| Performance traces | Sentry | Optional |

---

## Analytics Events

```dart
// Use consistent naming
analytics.logEvent(
  name: 'order_placed',
  parameters: {
    'order_id': orderId,
    'total_amount': amount,
    'item_count': items.length,
  },
);

// Screen tracking (auto_route observer)
analytics.setCurrentScreen(screenName: 'OrderDetails');
```

---

## PR Blockers

- [ ] All API errors logged to Sentry
- [ ] User-impacting actions have analytics events
- [ ] No shared analytics environments between flavors
