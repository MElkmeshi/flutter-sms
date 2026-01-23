# Controller Architecture

> **For AI Agents & Developers**: This document defines the controller patterns for this codebase.

---

## Static Provider Pattern

> ⚠️ **MANDATORY** — All controllers MUST define their provider as a `static` member inside the controller class.

### Why?

- **Co-location**: Provider definition lives with the controller it creates
- **Discoverability**: Easy to find provider via `ControllerName.provider`
- **Type safety**: IDE autocomplete works naturally
- **No orphan providers**: Provider can't exist without its controller

### Standard Pattern

> ⚠️ **ALWAYS rely on type inference** — Never specify generic types explicitly when Dart can infer them.

```dart
// ✅ CORRECT — Provider inside controller, type inference
class MyController extends Notifier<MyState> {
  static final provider = NotifierProvider(MyController.new);

  @override
  MyState build() => const MyState();

  // ... methods
}

// Usage:
final state = ref.watch(MyController.provider);
final controller = ref.read(MyController.provider.notifier);
```

```dart
// ❌ WRONG — Explicit generic types (unnecessary verbosity)
class MyController extends Notifier<MyState> {
  static final provider = NotifierProvider<MyController, MyState>(
    MyController.new,
  );  // Don't do this!
}

// ❌ WRONG — Provider outside controller
final myControllerProvider = NotifierProvider(MyController.new);
```

### Family Provider Pattern

For controllers that need initialization parameters:

```dart
import 'package:equatable/equatable.dart';

// Parameters class with Equatable
@immutable
class MyParams extends Equatable {
  const MyParams({required this.id, required this.name});
  
  final String id;
  final String name;
  
  @override
  List<Object?> get props => [id, name];
}

// Controller with static family provider (type inference!)
class MyController extends FamilyNotifier<MyState, MyParams> {
  static final provider = NotifierProvider.family(MyController.new);

  @override
  MyState build(MyParams arg) {
    // Access params via `arg`
    return MyState(id: arg.id);
  }

  // Access params in methods
  void doSomething() {
    print(arg.name);
  }
}

// Usage:
final params = MyParams(id: '123', name: 'Test');
final state = ref.watch(MyController.provider(params));
final controller = ref.read(MyController.provider(params).notifier);
```

### AsyncNotifier Pattern

```dart
class MyAsyncController extends AsyncNotifier<List<Item>> {
  static final provider = AsyncNotifierProvider(MyAsyncController.new);

  @override
  Future<List<Item>> build() async {
    return _fetchItems();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchItems);
  }
}

// Usage:
final itemsAsync = ref.watch(MyAsyncController.provider);
itemsAsync.when(
  data: (items) => ListView(...),
  loading: () => CircularProgressIndicator(),
  error: (e, st) => ErrorWidget(e),
);
```

### Family AsyncNotifier Pattern

```dart
class ItemDetailController extends FamilyAsyncNotifier<Item, String> {
  static final provider = AsyncNotifierProvider.family(ItemDetailController.new);

  @override
  Future<Item> build(String arg) async {
    // arg is the item ID
    return _fetchItem(arg);
  }
}

// Usage:
final itemAsync = ref.watch(ItemDetailController.provider(itemId));
```

---

## Controller Responsibilities

### What Controllers Handle

- ✅ API calls and network requests
- ✅ Business logic and validation
- ✅ State transformations
- ✅ Error handling for async operations
- ✅ Cross-feature coordination

### What Controllers DON'T Handle

- ❌ Timers/countdowns (use hooks: `useCountdown`)
- ❌ Text editing (use hooks: `useTextEditingController`)
- ❌ Focus management (use hooks: `useFocusNode`)
- ❌ Animations (use hooks: `useAnimationController`)
- ❌ UI-only state (use hooks: `useState`)

---

## State Classes

State classes should be:

1. **Immutable** — Use `@immutable` annotation
2. **Const constructible** — `const` constructor with defaults
3. **Copyable** — Provide `copyWith` method

```dart
@immutable
class MyState {
  const MyState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Item> items;
  final bool isLoading;
  final String? errorMessage;

  // Computed properties
  bool get hasItems => items.isNotEmpty;
  bool get hasError => errorMessage != null;

  MyState copyWith({
    List<Item>? items,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MyState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
```

---

## Error Handling in Controllers

Always use `try-catch-finally` pattern:

```dart
Future<void> submitData() async {
  state = state.copyWith(isLoading: true, clearError: true);

  try {
    await _api.submit(state.data);
    state = state.copyWith(isSuccess: true);
  } on DioException catch (e) {
    final message = _extractErrorMessage(e);
    state = state.copyWith(errorMessage: message);
  } catch (e) {
    state = state.copyWith(errorMessage: 'Unexpected error');
  } finally {
    // ALWAYS reset loading state
    state = state.copyWith(isLoading: false);
  }
}
```

---

## File Organization

```
feature/my_feature/
├── logic/
│   └── my_controller.dart    # Controller + State + Params (if family)
├── ui/
│   └── my_screen.dart
└── deps/
    └── my_deps.dart          # API providers, repositories
```

The controller file contains:
- State class
- Params class (if family provider)
- Controller class with static provider

---

## Checklist

- [ ] Provider is `static final` inside controller class
- [ ] **Type inference** — No explicit generic types on providers
- [ ] State class is `@immutable` with `const` constructor
- [ ] Family params use `Equatable`
- [ ] Error handling uses `try-catch-finally`
- [ ] Loading state always reset in `finally`
- [ ] No timers/animations in controllers (use hooks)

