# Address Feature Technical Specification

**Status:** Implemented
**Last Updated:** 2026-01-10

---

## Overview

The address feature provides local storage-based delivery address management using FlutterSecureStorage for persistence and Riverpod for state management.

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                        UI Layer                         │
│  ┌──────────────────┐  ┌──────────────────────────┐    │
│  │ AddressListing   │  │ AddressForm              │    │
│  │ Screen           │  │ Screen                   │    │
│  └────────┬─────────┘  └────────────┬─────────────┘    │
│           │                         │                   │
│  ┌────────┴─────────────────────────┴─────────────┐    │
│  │              AddressCard Widget                │    │
│  └────────────────────────────────────────────────┘    │
└───────────────────────────┬─────────────────────────────┘
                            │
┌───────────────────────────┴─────────────────────────────┐
│                      Logic Layer                        │
│  ┌────────────────────────────────────────────────┐    │
│  │              AddressController                  │    │
│  │         AsyncNotifier<List<DeliveryAddress>>    │    │
│  └────────────────────────┬───────────────────────┘    │
└───────────────────────────┬─────────────────────────────┘
                            │
┌───────────────────────────┴─────────────────────────────┐
│                      Data Layer                         │
│  ┌────────────────────────────────────────────────┐    │
│  │              AddressRepository                  │    │
│  │           FlutterSecureStorage                  │    │
│  └────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

---

## Storage

### Key
```
delivery_addresses
```

### Format
JSON array of `DeliveryAddress` objects:
```json
[
  {
    "id": "addr_1704844800000",
    "label": "Home",
    "street_address": "123 Main St",
    "city_id": "tripoli",
    "city_name": "Tripoli",
    "area": "Downtown",
    "phone": "+218 91 234 5678",
    "is_default": true
  }
]
```

---

## Provider Definitions

### `address_deps.dart`

```dart
final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AddressRepository(secureStorage);
});
```

---

## Controller API

### `AddressController`

```dart
class AddressController extends AsyncNotifier<List<DeliveryAddress>> {
  static final provider = AsyncNotifierProvider<...>(...);

  // Fetch all addresses
  Future<List<DeliveryAddress>> build();

  // Add new address
  Future<DeliveryAddress> addAddress({
    required String label,
    required String streetAddress,
    required String cityId,
    required String cityName,
    String? area,
    String? phone,
  });

  // Update existing address
  Future<void> updateAddress(DeliveryAddress address);

  // Delete address
  Future<void> deleteAddress(String addressId);

  // Set default address
  Future<void> setDefaultAddress(String addressId);

  // Refresh addresses
  Future<void> refresh();
}
```

---

## Repository API

### `AddressRepository`

```dart
class AddressRepository {
  // Get all addresses
  Future<List<DeliveryAddress>> getAddresses();

  // Add new address (returns created address with ID)
  Future<DeliveryAddress> addAddress({...});

  // Update address
  Future<void> updateAddress(DeliveryAddress address);

  // Delete address
  Future<void> deleteAddress(String addressId);

  // Set default address
  Future<void> setDefaultAddress(String addressId);

  // Get default address
  Future<DeliveryAddress?> getDefaultAddress();
}
```

---

## Routing

### Routes

| Route | Screen | Parameters |
|-------|--------|------------|
| `AddressListingRoute` | `AddressListingScreen` | None |
| `AddressFormRoute` | `AddressFormScreen` | `addressId?: String` |

### Registration in `app_router.dart`

```dart
AutoRoute(page: AddressListingRoute.page, guards: [onboardingGuard]),
AutoRoute(page: AddressFormRoute.page, guards: [onboardingGuard]),
```

---

## Widget Components

### `AddressCard`

Reusable card widget supporting two modes:

**Selection Mode (for checkout):**
```dart
AddressCard(
  address: address,
  isSelected: true,
  showRadio: true,
  onTap: () => selectAddress(address.id),
)
```

**Action Mode (for listing):**
```dart
AddressCard(
  address: address,
  showActions: true,
  onTap: () => editAddress(address.id),
  onEdit: () => editAddress(address.id),
  onDelete: () => confirmDelete(address.id),
  onSetDefault: () => setDefault(address.id),
)
```

### `AddressEmptyState`

Empty state widget with optional "Add Address" action:
```dart
AddressEmptyState(
  onAddAddress: () => navigateToAddAddress(),
)
```

---

## Integration with Cart

The cart checkout flow (`OrderSummaryScreen`) integrates with the address feature:

1. Watches `AddressController.provider` for address list
2. Uses `AddressCard` with `showRadio: true` for selection
3. Navigates to `AddressFormRoute` for adding new addresses
4. Auto-selects default address on load

---

## ID Generation

Address IDs are generated using timestamp:
```dart
static String _generateId() => 'addr_${DateTime.now().millisecondsSinceEpoch}';
```

---

## Default Address Logic

1. First address added is automatically set as default
2. When setting a new default, all other addresses have `isDefault` cleared
3. `getDefaultAddress()` returns the default address, or first address if none marked default
