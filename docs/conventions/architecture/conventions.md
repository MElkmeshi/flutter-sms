# Conventions

> Core principles, project structure, naming conventions, and import rules.

---

## Core Principles

- **Predictable**: Consistent patterns everywhere — no surprises.
- **Modular**: Features are self-contained and independently testable.
- **Explicit**: Dependencies are injected, never global or implicit.
- **Immutable**: Models and state objects never mutate.
- **Dumb UI**: Widgets render state; controllers handle logic.
- **Material 3**: All UI must use Material 3 design system — no exceptions.
- **Localized**: ALL user-facing strings must use slang translations — no hardcoded text.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                         lib/                                │
├─────────────────────────────────────────────────────────────┤
│  domain/          Pure Dart. Models, value objects, utils.  │
│  feature/         Product features (auth, orders, etc.)     │
│  logic/           Cross-feature orchestration (rare)        │
│  ui/              Routing, l10n, shared widgets, resources  │
├─────────────────────────────────────────────────────────────┤
│  main.dart                  Shared bootstrap                │
│  main_dev.dart              Dev flavor entry point          │
│  main_prod.dart             Prod flavor entry point         │
└─────────────────────────────────────────────────────────────┘
```

### Layer Rules

| Layer | Can Import | Cannot Import |
|-------|-----------|---------------|
| `domain/` | Dart core, external pure-Dart packages | Flutter, `feature/`, `ui/` |
| `feature/` | `domain/`, other features (via providers) | `logic/`, `ui/` internals |
| `logic/` | `domain/`, `feature/` providers | Direct feature internals |
| `ui/` | Everything | N/A |

---

## Project Structure

```
lib/
├── core/
│   └── initializer/             # App initialization
│       ├── app_initializer.dart # Service initialization logic
│       └── app_providers.dart   # Provider definitions & overrides
│
├── domain/
│   ├── model/                   # Data models
│   └── util/                    # Utilities, extensions
│
├── feature/
│   ├── auth/
│   │   ├── login/
│   │   │   ├── ui/
│   │   │   ├── logic/
│   │   │   └── deps/
│   │   └── register/
│   └── orders/
│       ├── order_list/
│       │   ├── ui/
│       │   ├── logic/
│       │   ├── deps/
│       │   └── data/            # Optional: feature-specific API
│       └── order_details/
│
├── logic/                       # Cross-feature orchestration (rare)
│
├── ui/
│   ├── app_router/              # Routing
│   ├── hooks/                   # Custom Flutter hooks
│   ├── l10n/                    # Translations
│   ├── resources/               # Generated assets
│   └── widget/                  # Shared widgets
│
└── main.dart
```

---

## Feature Module Convention

Every subfeature follows this structure:

```
feature/<domain>/<subfeature>/
├── ui/
│   ├── <name>_screen.dart       # Main screen widget
│   └── <name>_widgets.dart      # Optional: extracted widgets
├── logic/
│   ├── <name>_controller.dart   # AsyncNotifier or Notifier
│   └── <name>_state.dart        # Optional: if state is complex
├── deps/
│   └── <name>_deps.dart         # Provider definitions
└── data/                        # Optional: feature-specific API
    ├── <name>_api.dart
    └── <name>_repository.dart
```

### The `deps/` Folder

This is where **all wiring happens**:

```dart
// feature/orders/order_list/deps/order_list_deps.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// API provider
final ordersApiProvider = Provider<OrdersApi>((ref) {
  return OrdersApi(ref.watch(dioProvider));
});

// Controller provider (OLD PATTERN - see state.md for new pattern)
final orderListControllerProvider =
    AsyncNotifierProvider<OrderListController, List<Order>>(
  OrderListController.new,
);
```

**Rule**: UI imports from `deps/`, never instantiates classes directly.

---

## Import Conventions

### Package Imports (Required)

Always use package imports instead of relative imports:

```dart
// ✅ ALWAYS — Use package imports
import 'package:your_app/domain/model/user.dart';
import 'package:your_app/feature/auth/login/logic/login_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ❌ NEVER — Relative imports with ../
import '../../../../domain/model/user.dart';
import '../../../auth/login/logic/login_controller.dart';
```

### Import Order

Organize imports in this order, separated by blank lines:

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter packages
import 'package:flutter/material.dart';

// 3. External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

// 4. Project packages (our code)
import 'package:your_app/domain/model/user.dart';
import 'package:your_app/feature/auth/login/logic/login_controller.dart';
```

---

## Naming Conventions

### Files

| Type | Pattern | Example |
|------|---------|---------|
| Screen | `*_screen.dart` | `login_screen.dart` |
| Controller | `*_controller.dart` | `login_controller.dart` |
| State | `*_state.dart` | `login_state.dart` |
| Dependencies | `*_deps.dart` | `login_deps.dart` |
| API client | `*_api.dart` | `orders_api.dart` |
| Repository | `*_repository.dart` | `orders_repository.dart` |
| Model | `<name>.dart` | `user.dart`, `order.dart` |

### Classes

| Type | Pattern | Example |
|------|---------|---------|
| Screen | `*Screen` | `LoginScreen` |
| Controller | `*Controller` | `LoginController` |
| State | `*State` | `LoginState` |
| API | `*Api` | `OrdersApi` |
| Repository | `*Repository` | `OrdersRepository` |
| Model | `PascalCase` | `User`, `Order`, `OrderItem` |

### Providers

| Type | Pattern | Example |
|------|---------|---------|
| Controller | `*Controller.provider` | `LoginController.provider` |
| Repository | `*RepositoryProvider` | `ordersRepositoryProvider` |
| API | `*ApiProvider` | `ordersApiProvider` |
| Simple | `*Provider` | `currentUserProvider` |

---

## Code Style

### Early Returns

Prefer early returns over nested if/else blocks. Exit early for edge cases, then handle the main logic.

```dart
// ❌ WRONG — nested if/else
Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
  final authState = await ref.read(AuthController.provider.future);
  if (authState == AuthState.authenticated) {
    resolver.next();
  } else {
    await router.replaceAll([const WelcomeRoute()]);
    resolver.next(false);
  }
}

// ✅ CORRECT — early return
Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
  final authState = await ref.read(AuthController.provider.future);

  if (authState == AuthState.authenticated) {
    return resolver.next();
  }

  await router.replaceAll([const WelcomeRoute()]);
  return resolver.next(false);
}
```

**Why?**
- Reduces nesting and cognitive load
- Makes the "happy path" clear
- Easier to read and maintain

---

## PR Blockers

- [ ] No UI imports in `domain/`
- [ ] No API calls in widgets
- [ ] No global singletons (use Riverpod)
- [ ] Features must not import other features' internals
- [ ] Package imports only (never relative imports)
- [ ] Use early returns (no nested if/else)
