# Models & Serialization

> json_serializable, Equatable, and model patterns.

---

## Required Pattern

Every model MUST follow this pattern:

1. **Extend Equatable** for value equality
2. **Use `@JsonSerializable()`** annotation
3. **All fields are `final`**
4. **`const` constructor**
5. **Override `props`** for Equatable
6. **Manual `copyWith` method**
7. **Custom `fromJson`** with null-safe transformations
8. **Generated `toJson`** via json_serializable

---

## Model Example

```dart
// domain/model/order.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order extends Equatable {
  const Order({
    required this.id,
    required this.status,
    required this.items,
    required this.createdAt,
  });

  @JsonKey(name: 'order_id')
  final String id;
  final OrderStatus status;
  final List<OrderItem> items;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, status, items, createdAt];

  // Manual copyWith
  Order copyWith({
    String? id,
    OrderStatus? status,
    List<OrderItem>? items,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      status: status ?? this.status,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Custom fromJson for flexible API handling
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson({
    ...json,
    'order_id': json['order_id']?.toString() ?? json['id']?.toString() ?? '',
  });

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

enum OrderStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('PROCESSING')
  processing,
  @JsonValue('DELIVERED')
  delivered,
}
```

---

## Null-Safe fromJson Pattern

Always handle potentially null or varying API responses:

```dart
factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson({
  ...json,
  // Handle id that could be 'id' or 'uuid'
  'id': json['id']?.toString() ?? json['uuid']?.toString() ?? '',
  // Handle name that could be null
  'name': json['name']?.toString() ?? '',
  // Handle nested object extraction
  'category': _extractCategory(json),
  // Handle numeric fields that could be strings
  'price': _parseDouble(json['price']) ?? 0.0,
});

static double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
```

---

## Equatable for Value Equality

> **Rule**: Always use `Equatable` for classes that need value equality. Never manually implement `==` and `hashCode`.

```dart
// ❌ WRONG — Manual equality is verbose and error-prone
@immutable
class UserParams {
  const UserParams({required this.id});
  final String id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserParams &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ✅ CORRECT — Use Equatable
import 'package:equatable/equatable.dart';

@immutable
class UserParams extends Equatable {
  const UserParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
```

**When to use Equatable:**
- Family provider parameters
- State classes that need comparison
- Any immutable value objects
- All domain models

---

## Models Without Generated JSON

For models with complex custom parsing, skip `@JsonSerializable()`:

```dart
// No @JsonSerializable() - fully manual
class ProductMedia extends Equatable {
  const ProductMedia({...});

  // Custom fromJson handles complex API formats
  factory ProductMedia.fromJson(Map<String, dynamic> json) {
    // Handle gallery which can be List<String> or List<{path: String}>
    List<String> galleryImages = [];
    final galleryData = json['gallery'];
    if (galleryData is List) {
      for (final item in galleryData) {
        if (item is String) {
          galleryImages.add(item);
        } else if (item is Map<String, dynamic>) {
          final path = item['path']?.toString();
          if (path != null) galleryImages.add(path);
        }
      }
    }
    return ProductMedia(gallery: galleryImages, ...);
  }

  // Manual toJson
  Map<String, dynamic> toJson() => {...};
}
```

---

## Code Generation

After adding or modifying models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## PR Blockers

- [ ] **Use `Equatable`** — All models extend Equatable for value equality
- [ ] **No freezed** — Use plain Dart classes with json_serializable + equatable
- [ ] **Type inference** — No explicit generics when Dart can infer
- [ ] All fields `final`, constructor `const`
- [ ] Override `props` getter
- [ ] Add `copyWith` method
- [ ] Null-safe `fromJson` with transformations
