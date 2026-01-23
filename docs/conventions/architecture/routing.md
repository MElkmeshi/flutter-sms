# Routing

> auto_route configuration and navigation patterns.

---

## Router Definition

```dart
// ui/app_router/app_router.dart

import 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: HomeRoute.page, children: [
      AutoRoute(page: OrderListRoute.page),
      AutoRoute(page: ProfileRoute.page),
    ]),
    AutoRoute(page: OrderDetailsRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    AuthGuard(ref),
  ];
}
```

---

## Screen Annotation

```dart
// feature/orders/order_details/ui/order_details_screen.dart

@RoutePage()
class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({
    super.key,
    @PathParam('id') required this.orderId,
  });

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ...
  }
}
```

---

## Navigation

```dart
// ✅ Type-safe navigation
context.router.push(OrderDetailsRoute(orderId: '123'));

// ✅ Replace
context.router.replace(const HomeRoute());

// ✅ Pop
context.router.maybePop();

// ❌ Never use string-based navigation
Navigator.pushNamed(context, '/orders/123'); // WRONG
```

---

## Code Generation

After adding or modifying routes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## PR Blockers

- [ ] No string-based navigation (`Navigator.pushNamed`)
- [ ] All screens have `@RoutePage()` annotation
- [ ] Routes registered in `app_router.dart`
