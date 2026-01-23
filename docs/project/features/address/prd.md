# Address Feature PRD

**Status:** Implemented
**Last Updated:** 2026-01-10

---

## Goal

Enable users to manage their delivery addresses from the Account screen, with addresses reusable across the checkout flow.

## Non-Goals

- Backend API synchronization (addresses stored locally only)
- Address validation against real postal services
- Address autocomplete/suggestions

---

## User Stories

### US-ADDR-001: View Addresses
**As a** user
**I want to** see all my saved addresses
**So that** I can manage my delivery locations

### US-ADDR-002: Add Address
**As a** user
**I want to** add a new delivery address
**So that** I can have products delivered there

### US-ADDR-003: Edit Address
**As a** user
**I want to** edit an existing address
**So that** I can update my delivery information

### US-ADDR-004: Delete Address
**As a** user
**I want to** delete an address I no longer use
**So that** my address list stays organized

### US-ADDR-005: Set Default Address
**As a** user
**I want to** set a default address
**So that** it's pre-selected during checkout

---

## Screens

### 1. Address Listing Screen

**Route:** `/addresses`

**Description:** Lists all saved delivery addresses with options to add, edit, delete, and set default.

```
┌─────────────────────────────────────┐
│ ←  Addresses                        │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Home            [Default]   │   │
│  │ 123 Main St, Downtown       │   │
│  │ Tripoli                     │ ⋮ │
│  │ 📞 +218 91 234 5678         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Office                      │   │
│  │ 456 Business Ave            │ ⋮ │
│  │ Benghazi                    │   │
│  └─────────────────────────────┘   │
│                                     │
│                                     │
│                              [+]    │
└─────────────────────────────────────┘
```

**Elements:**

| Element | Type | Description |
|---------|------|-------------|
| Title | AppBar | "Addresses" |
| Address Card | Card | Shows label, address, phone, default badge |
| Menu Button | IconButton | Opens edit/delete/default options |
| FAB | FloatingActionButton | Navigate to add address |

**Empty State:**
- Icon: MapPin
- Title: "No addresses saved"
- Hint: "Add an address for faster checkout"
- Action: "Add Address" button

### 2. Address Form Screen

**Route:** `/addresses/new` or `/addresses/:addressId`

**Description:** Form for adding or editing a delivery address.

```
┌─────────────────────────────────────┐
│ ←  Add Address                      │
├─────────────────────────────────────┤
│                                     │
│  Label                              │
│  ┌─────────────────────────────┐   │
│  │ Home                        │   │
│  └─────────────────────────────┘   │
│                                     │
│  Street Address *                   │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  City *                             │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Area / District                    │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Phone Number                       │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │       Save Address          │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

**Fields:**

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| Label | Text | No | Defaults to "Home" |
| Street Address | Text | Yes | Non-empty |
| City | Text | Yes | Non-empty |
| Area | Text | No | - |
| Phone | Phone | No | - |

---

## Data Model

```dart
class DeliveryAddress {
  final String id;
  final String label;
  final String streetAddress;
  final String cityId;
  final String cityName;
  final String? area;
  final String? phone;
  final bool isDefault;
}
```

---

## Functional Requirements

| ID | Requirement |
|----|-------------|
| FR-ADDR-001 | First address added is automatically set as default |
| FR-ADDR-002 | Only one address can be default at a time |
| FR-ADDR-003 | Deleting default address makes first remaining address default |
| FR-ADDR-004 | Addresses persist locally using FlutterSecureStorage |
| FR-ADDR-005 | Address list refreshes after add/edit/delete operations |

---

## Edge Cases

| Scenario | Handling |
|----------|----------|
| No addresses | Show empty state with "Add Address" button |
| Delete only address | List becomes empty, show empty state |
| Delete default address | First remaining address becomes default |
| Edit mode with invalid ID | Navigate back (address not found) |

---

## Acceptance Criteria

- [ ] User can view list of all saved addresses
- [ ] User can add a new address
- [ ] User can edit an existing address
- [ ] User can delete an address with confirmation
- [ ] User can set an address as default
- [ ] Default badge displays on default address
- [ ] Empty state displays when no addresses exist
- [ ] Form validation prevents empty required fields
- [ ] First address is auto-set as default
- [ ] Addresses persist between app sessions

---

## Localization Keys

```json
{
  "address": {
    "title": "Addresses",
    "empty": "No addresses saved",
    "emptyHint": "Add an address for faster checkout",
    "addAddress": "Add Address",
    "editAddress": "Edit Address",
    "deleteAddress": "Delete Address",
    "deleteConfirm": "Are you sure you want to delete this address?",
    "setDefault": "Set as Default",
    "defaultBadge": "Default",
    "label": "Label",
    "labelHint": "e.g., Home, Office",
    "streetAddress": "Street Address",
    "city": "City",
    "area": "Area / District",
    "phone": "Phone Number",
    "save": "Save Address",
    "required": "This field is required",
    "home": "Home",
    "delete": "Delete",
    "cancel": "Cancel"
  }
}
```
