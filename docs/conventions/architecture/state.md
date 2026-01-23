# State Management

> Riverpod patterns, Flutter Hooks, and the static provider pattern.

---

## Provider Types

| Use Case | Provider Type |
|----------|--------------|
| Static value / singleton | `Provider` |
| Async data fetch (read-only) | `FutureProvider` |
| Real-time stream | `StreamProvider` |
| Sync state with actions | `NotifierProvider` |
| Async state with actions | `AsyncNotifierProvider` |

---

## Static Provider Pattern (MANDATORY)

> ⚠️ **CRITICAL** — All controllers MUST define their provider as a `static` member inside the controller class.
>
> ⚠️ **ALWAYS use type inference** — Never specify generic types explicitly.

```dart
// ✅ CORRECT — Static provider with type inference
class OrderListController extends AsyncNotifier<List<Order>> {
  static final provider = AsyncNotifierProvider(OrderListController.new);

  @override
  Future<List<Order>> build() async {
    return _fetchOrders();
  }
}

// ✅ CORRECT — Family provider with type inference
class MyController extends FamilyNotifier<MyState, MyParams> {
  static final provider = NotifierProvider.family(MyController.new);
}

// Usage:
final orders = ref.watch(OrderListController.provider);
ref.read(OrderListController.provider.notifier).refresh();
```

```dart
// ❌ WRONG — Explicit generic types (unnecessary)
static final provider = AsyncNotifierProvider<OrderListController, List<Order>>(
  OrderListController.new,
);

// ❌ WRONG — Provider outside controller
final orderListControllerProvider = AsyncNotifierProvider(...);
```

---

## Flutter Hooks

> ⚠️ **CRITICAL** — Use Flutter Hooks for ephemeral state and controllers. **Never use StatefulWidget.**

### Why Hooks?

- **No boilerplate**: No `dispose()`, `initState()`, `didUpdateWidget()`
- **Automatic cleanup**: Controllers auto-dispose
- **Composable**: Extract and reuse stateful logic
- **Testable**: Easier to test than StatefulWidget

### Required Setup

Use `HookConsumerWidget` instead of `ConsumerWidget` or `ConsumerStatefulWidget`:

```dart
// ✅ CORRECT — Use HookConsumerWidget with hooks
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class PhoneEntryScreen extends HookConsumerWidget {
  const PhoneEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TextEditingController with auto-dispose
    final phoneController = useTextEditingController();

    // FocusNode with auto-dispose
    final focusNode = useFocusNode();

    // Local state (like useState in React)
    final isObscured = useState(true);

    // Animation controller with auto-dispose
    final animController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    return Scaffold(
      body: TextField(
        controller: phoneController,
        focusNode: focusNode,
        obscureText: isObscured.value,
      ),
    );
  }
}

// ❌ WRONG — Never use StatefulWidget with manual dispose
class PhoneEntryScreen extends ConsumerStatefulWidget { ... }
```

### Common Hooks

| Hook | Purpose | Replaces |
|------|---------|----------|
| `useTextEditingController()` | Text input controller | `TextEditingController` + dispose |
| `useFocusNode()` | Focus management | `FocusNode` + dispose |
| `useState<T>(initial)` | Local state | `setState()` |
| `useAnimationController()` | Animations | `AnimationController` + dispose |
| `useScrollController()` | Scroll position | `ScrollController` + dispose |
| `usePageController()` | PageView control | `PageController` + dispose |
| `useEffect()` | Side effects | `initState` + `didUpdateWidget` |
| `useMemoized()` | Expensive computation | Manual caching |

---

## useEffect Rules

**NEVER modify providers inside useEffect:**

```dart
// ❌ WRONG — Modifying provider during build causes errors
useEffect(() {
  ref.read(someProvider.notifier).init();  // ERROR!
  return null;
}, const []);

// ❌ WRONG — Using Future.microtask is a hack, not a solution
useEffect(() {
  Future.microtask(() {
    ref.read(someProvider.notifier).init();  // Still bad!
  });
  return null;
}, const []);

// ✅ CORRECT — Use family providers with parameters instead
final params = useMemoized(() => SomeParams(...), [...]);
final state = ref.watch(someProvider(params));  // Params passed directly
```

**Why?** Providers should be self-initializing. Use family providers with parameters.

---

## Side Effects with useEffect

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final controller = useTextEditingController();

  // Run once on mount (like initState)
  useEffect(() {
    controller.text = 'Initial value';
    return null;  // No cleanup needed
  }, const []);  // Empty deps = run once

  // Run when dependency changes
  useEffect(() {
    final subscription = someStream.listen((_) {});
    return subscription.cancel;  // Cleanup function
  }, [someStream]);

  return TextField(controller: controller);
}
```

---

## Local vs Shared State

> **Key Rule**: Ephemeral UI state stays in hooks. Shared/persistent state goes in providers.

| State Type | Where | Example |
|------------|-------|---------|
| Text input value | Hooks (`useTextEditingController`) | Phone number input |
| Focus state | Hooks (`useFocusNode`) | Which field is focused |
| Countdown timer | Hooks (custom `useCountdown`) | OTP resend timer |
| Animation state | Hooks (`useAnimationController`) | Button animations |
| API loading state | Provider | `isLoading` for network calls |
| API response data | Provider | User profile, order list |
| Form validation | Provider | Cross-field validation |
| Auth state | Provider | Token, logged in user |

---

## Custom Hooks

Create custom hooks for reusable stateful logic. Place them in `lib/ui/hooks/`.

```dart
// lib/ui/hooks/use_countdown.dart

CountdownState useCountdown({required int initialSeconds}) {
  final remaining = useState(initialSeconds);
  final isFinished = useState(false);
  final restartTrigger = useState(0);

  useEffect(() {
    remaining.value = initialSeconds;
    isFinished.value = false;

    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remaining.value > 1) {
        remaining.value--;
      } else {
        timer.cancel();
        remaining.value = 0;
        isFinished.value = true;
      }
    });

    return timer.cancel;  // Cleanup
  }, [restartTrigger.value]);

  return CountdownState(
    remaining: remaining.value,
    isFinished: isFinished.value,
    restart: () => restartTrigger.value++,
  );
}

// Usage in widget:
final countdown = useCountdown(initialSeconds: 30);
if (countdown.isFinished) {
  // Show resend button
}
countdown.restart();  // Reset the timer
```

---

## Family Providers for Parameterized State

When a provider needs initialization data from the widget, use family providers:

```dart
// ✅ CORRECT — Family provider with Equatable parameters
import 'package:equatable/equatable.dart';

@immutable
class MyParams extends Equatable {
  const MyParams({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class MyController extends FamilyNotifier<MyState, MyParams> {
  static final provider = NotifierProvider.family(MyController.new);

  @override
  MyState build(MyParams arg) {
    // arg contains all initialization data
    return MyState(id: arg.id);
  }
}

// Usage in widget:
final params = useMemoized(
  () => MyParams(id: widget.id, name: widget.name),
  [widget.id, widget.name],
);
final state = ref.watch(MyController.provider(params));
```

---

## UI Consumption

```dart
class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(OrderListController.provider);

    return ordersAsync.when(
      loading: () => const LoadingIndicator(),
      error: (e, st) => ErrorDisplay(error: e, onRetry: () {
        ref.read(OrderListController.provider.notifier).refresh();
      }),
      data: (orders) => OrderListView(orders: orders),
    );
  }
}
```

---

## PR Blockers

- [ ] **No StatefulWidget** — Use `HookConsumerWidget` instead
- [ ] **No manual dispose** — Use hooks for auto-cleanup
- [ ] **No `createState()`** — Not needed with hooks
- [ ] **No `Future.microtask` in useEffect** — Use family providers instead
- [ ] **No provider init() methods called from useEffect** — Bad pattern
- [ ] **Timers/counters as hooks, not in providers** — Local UI state stays local
- [ ] **Provider inside controller** — `static final provider = ...` pattern
