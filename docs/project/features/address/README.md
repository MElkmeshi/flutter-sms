# Address Feature

Standalone delivery address management feature for the Nazaka app.

## Overview

The address feature provides full CRUD operations for delivery addresses:
- List all saved addresses
- Add new addresses
- Edit existing addresses
- Delete addresses
- Set default address

## User Flow

```
Account Screen
     |
     v
[Addresses] ──────> Address Listing Screen
                           |
                    ┌──────┴──────┐
                    v             v
              [Add New]      [Edit/Delete]
                    |             |
                    v             v
             Address Form    Address Form
              (Create)        (Edit)
```

## Integration Points

### Account Screen
- "Addresses" list item navigates to `AddressListingScreen`

### Cart Checkout
- `OrderSummaryScreen` uses `AddressCard` for address selection
- Navigation to `AddressFormScreen` for adding new addresses during checkout

## Code Location

```
lib/feature/address/
├── data/
│   └── address_repository.dart    # Local storage persistence
├── logic/
│   └── address_controller.dart    # AsyncNotifier state management
├── deps/
│   └── address_deps.dart          # Provider definitions
└── ui/
    ├── address_listing_screen.dart
    ├── address_form_screen.dart
    └── widget/
        ├── address_card.dart
        └── address_empty_state.dart
```

## Shared Components

| Component | Location | Usage |
|-----------|----------|-------|
| `DeliveryAddress` model | `lib/domain/model/delivery_address.dart` | Shared data model |
| `AddressCard` | `lib/feature/address/ui/widget/` | Reusable in checkout |

## Documentation

- [PRD](prd.md) - Product requirements and user stories
- [Spec](spec.md) - Technical implementation details
