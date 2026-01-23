# Testing Strategy

> Test types, patterns, and minimum coverage requirements.

---

## Test Types

| Type | Location | Purpose |
|------|----------|---------|
| Unit | `test/domain/` | Models, utils, pure functions |
| Controller | `test/feature/*/logic/` | State management logic |
| Widget | `test/feature/*/ui/` | UI components |
| Integration | `integration_test/` | Full flows |

---

## Controller Testing

```dart
// test/feature/orders/logic/order_list_controller_test.dart

void main() {
  late ProviderContainer container;
  late MockOrdersRepository mockRepository;

  setUp(() {
    mockRepository = MockOrdersRepository();
    container = ProviderContainer(
      overrides: [
        ordersRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('fetches orders on build', () async {
    when(() => mockRepository.getOrders())
        .thenAnswer((_) async => [testOrder]);

    final controller = container.read(OrderListController.provider.notifier);
    await container.read(OrderListController.provider.future);

    expect(container.read(OrderListController.provider).value, [testOrder]);
  });
}
```

---

## Model Testing (Serialization Round-Trip)

```dart
// test/domain/model/order_test.dart

void main() {
  test('Order serializes and deserializes correctly', () {
    const order = Order(
      id: '123',
      status: OrderStatus.pending,
      items: [],
      createdAt: DateTime(2024, 1, 1),
    );

    final json = order.toJson();
    final restored = Order.fromJson(json);

    expect(restored, equals(order));
  });
}
```

---

## Minimum Coverage

- All models: serialization round-trip
- All controllers: happy path + error cases
- Critical widgets: render + interaction

---

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/domain/model/order_test.dart
```
