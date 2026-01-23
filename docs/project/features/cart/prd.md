# PRD: Cart & Checkout

> **Status**: Draft
> **Last Updated**: January 2026
> **Owner**: TBD

---

## Goal

Enable users to add products to a shopping cart, manage cart items, and complete purchases through a checkout flow with delivery address selection.

---

## Non-goals

- Server-side cart synchronization (cart is device-local only)
- Guest cart (login required)
- Payment gateway integration (out of scope for v1)
- Order tracking after placement
- Wishlist-to-cart conversion
- Cart sharing

---

## User Stories

- [ ] **US-CART-001**: As a user, I want to add products to my cart so I can purchase multiple items together.
- [ ] **US-CART-002**: As a user, I want to see a floating cart indicator so I always know when I have items in cart.
- [ ] **US-CART-003**: As a user, I want to view all items in my cart so I can review before checkout.
- [ ] **US-CART-004**: As a user, I want to increase/decrease item quantities so I can buy multiple of the same product.
- [ ] **US-CART-005**: As a user, I want to remove items from my cart so I can change my mind.
- [ ] **US-CART-006**: As a user, I want to see the total price so I know how much I'll pay.
- [ ] **US-CART-007**: As a user, I want to proceed to checkout so I can complete my purchase.
- [ ] **US-CART-008**: As a user, I want to select a delivery address so my order is shipped correctly.
- [ ] **US-CART-009**: As a user, I want to add a new address during checkout so I don't have to leave the flow.
- [ ] **US-CART-010**: As a user, I want to review my order summary before placing it.
- [ ] **US-CART-011**: As a user, I want to place my order so I can complete the purchase.

---

## Navigation Change

### Current Navigation Bar (5 tabs)

| Position | Current | New |
|----------|---------|-----|
| 1 | Home | Home |
| 2 | Categories | Categories |
| 3 | Sell | Sell |
| 4 | **Sold** | **Cart** |
| 5 | Account | Account |

**Change**: Replace "Sold" tab with "Cart" tab
- Icon: `LucideIcons.shoppingCart` (was: `LucideIcons.packageCheck`)
- Label: `tr.nav.cart` (was: `tr.nav.sold`)
- Route: `CartTab()` (was: `SoldProductsTab()`)

---

## Screen 1: Floating Cart FAB (Global Component)

### Description
An extended floating action button centered at the bottom of the screen. Appears with animation when items are added to cart. Visible on all screens while cart has items.

### Visual Design

```
┌─────────────────────────────────────┐
│                                     │
│         [Any Screen Content]        │
│                                     │
│                                     │
│                                     │
│       ┌─────────────────────┐       │
│       │  Show Cart  $247.00 │       │  <- Extended FAB (centered, no icon)
│       └─────────────────────┘       │
│─────────────────────────────────────│
│  Home  Categories  Sell  Cart  Me   │
└─────────────────────────────────────┘
```

### Elements

| Element | Type | Description |
|---------|------|-------------|
| "Show Cart" | Text | `context.t.cart.showCart` label |
| Cart Total | Text | Formatted subtotal (e.g., "$247.00"), bold |
| FAB Container | FloatingActionButton.extended | Material 3 extended FAB, centered, no icon |

### Hard Rules

| Rule | Correct | Wrong |
|------|---------|-------|
| **FAB type** | `FloatingActionButton.extended` | `FloatingActionButton` (circular) |
| **Position** | `FloatingActionButtonLocation.centerFloat` | `endFloat` (right-aligned) |
| **Icon** | None (text-only FAB) | Cart icon with badge |
| **Label layout** | "Show Cart" + Total (bold) | Icon + text |
| **Localization** | `context.t.cart.showCart` | Hardcoded "Show Cart" |

### Behavior

1. **Appear Animation**: Slide up + fade in when first item added to cart
2. **Badge Update**: Count updates in real-time when items added/removed
3. **Total Update**: Subtotal label updates in real-time
4. **Disappear Animation**: Slide down + fade out when cart becomes empty
5. **Tap Action**: Navigate to Cart Screen
6. **Visibility**: Hidden on Cart Screen and Checkout screens

### States

| State | Description |
|-------|-------------|
| Hidden | Cart is empty, FAB not visible |
| Visible | Cart has items, FAB shown with icon + badge + total |
| Animating In | Sliding up when first item added |
| Animating Out | Sliding down when last item removed |

---

## Screen 2: Cart Screen

### Description
Displays all items in the cart with quantity controls, item removal, and total price. Entry point to checkout flow.

### App Bar

| Element | Type | Description |
|---------|------|-------------|
| Title | Text | `tr.cart.title` ("Cart") |
| Back Button | IconButton | Navigate back (if deep linked) |

### Visual Design

```
┌─────────────────────────────────────┐
│ <-  Cart                            │
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ┌─────┐                         │ │
│ │ │     │  Product Name           │ │
│ │ │ IMG │  Category               │ │
│ │ │     │  $99.00                 │ │
│ │ └─────┘                         │ │
│ │         [ - ]  2  [ + ]    X    │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ┌─────┐                         │ │
│ │ │     │  Another Product        │ │
│ │ │ IMG │  Category               │ │
│ │ │     │  $49.00                 │ │
│ │ └─────┘                         │ │
│ │         [ - ]  1  [ + ]    X    │ │
│ └─────────────────────────────────┘ │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  Subtotal                   $247.00 │
│                                     │
│  ┌─────────────────────────────────┐│
│  │        Proceed to Checkout      ││
│  └─────────────────────────────────┘│
│                                     │
│─────────────────────────────────────│
│  Home  Categories  Sell  Cart  Me   │
└─────────────────────────────────────┘
```

### Cart Item Card Elements

| Element | Type | Description |
|---------|------|-------------|
| Product Image | CachedNetworkImage | 80x80px, rounded corners |
| Product Name | Text | Max 2 lines, ellipsis |
| Category | Text | Product category name |
| Price | Text | Unit price (discounted if applicable) |
| Decrease Button | IconButton | `LucideIcons.minus`, decrease quantity |
| Quantity | Text | Current quantity count |
| Increase Button | IconButton | `LucideIcons.plus`, increase quantity |
| Delete Button | IconButton | `LucideIcons.trash2`, remove from cart |

### Bottom Section Elements

| Element | Type | Description |
|---------|------|-------------|
| Subtotal Label | Text | `tr.cart.subtotal` |
| Subtotal Amount | Text | Sum of (price x quantity) for all items |
| Checkout Button | FilledButton | `tr.cart.proceedToCheckout` |

### Behavior

1. **Increase Quantity**: Tap + button, quantity increases, totals update
2. **Decrease Quantity**: Tap - button; if qty > 1, decrease; if qty = 1, show delete confirmation
3. **Delete Item**: Tap trash icon, show confirmation dialog, remove on confirm
4. **Checkout**: Tap button, navigate to Order Summary screen
5. **Empty Cart**: Show empty state with CTA to browse products

### States

| State | Description |
|-------|-------------|
| Loading | Initial load from local storage |
| Loaded | Cart items displayed |
| Empty | No items in cart, show empty state |
| Updating | Quantity change in progress |

### Empty State

```
┌─────────────────────────────────────┐
│ <-  Cart                            │
├─────────────────────────────────────┤
│                                     │
│                                     │
│            [cart icon]              │
│                                     │
│      Your cart is empty             │
│                                     │
│   Browse products and add items     │
│   to your cart to get started       │
│                                     │
│     ┌─────────────────────────┐     │
│     │    Browse Products      │     │
│     └─────────────────────────┘     │
│                                     │
│─────────────────────────────────────│
│  Home  Categories  Sell  Cart  Me   │
└─────────────────────────────────────┘
```

---

## Screen 3: Order Summary Screen

### Description
Shows order summary with delivery address selection and place order action.

### App Bar

| Element | Type | Description |
|---------|------|-------------|
| Title | Text | `tr.cart.orderSummary` |
| Back Button | IconButton | Return to cart |

### Visual Design

```
┌─────────────────────────────────────┐
│ <-  Order Summary                   │
├─────────────────────────────────────┤
│                                     │
│ DELIVERY ADDRESS                    │
│ ┌─────────────────────────────────┐ │
│ │ o Home                          │ │
│ │   123 Main St, Apt 4B           │ │
│ │   City, Country 12345           │ │
│ │   +1 234 567 8900               │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ o Office                        │ │
│ │   456 Work Ave, Floor 10        │ │
│ │   City, Country 67890           │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │  + Add New Address              │ │
│ └─────────────────────────────────┘ │
│                                     │
│─────────────────────────────────────│
│ ORDER ITEMS                         │
│ ┌─────────────────────────────────┐ │
│ │ Product Name           x2  $198 │ │
│ │ Another Product        x1   $49 │ │
│ └─────────────────────────────────┘ │
│                                     │
│─────────────────────────────────────│
│ PRICE BREAKDOWN                     │
│                                     │
│   Subtotal                  $247.00 │
│   Delivery Fee                $5.00 │
│   ─────────────────────────────     │
│   Total                     $252.00 │
│                                     │
├─────────────────────────────────────┤
│  ┌─────────────────────────────────┐│
│  │          Place Order            ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

### Sections

#### Delivery Address Section

| Element | Type | Description |
|---------|------|-------------|
| Section Title | Text | `tr.cart.deliveryAddress` |
| Address Cards | RadioListTile | Selectable saved addresses |
| Address Label | Text | "Home", "Office", or custom label |
| Address Line 1 | Text | Street address |
| Address Line 2 | Text | City, Country, Postal |
| Phone | Text | Contact phone (optional) |
| Add Address Button | OutlinedButton | Opens Add Address bottom sheet |

#### Order Items Section

| Element | Type | Description |
|---------|------|-------------|
| Section Title | Text | `tr.cart.orderItems` |
| Item Row | ListTile | Product name, quantity, line total |

#### Price Breakdown Section

| Element | Type | Description |
|---------|------|-------------|
| Subtotal | Row | Label + amount |
| Delivery Fee | Row | Label + amount |
| Divider | Divider | Visual separator |
| Total | Row | Bold label + bold amount |

#### Bottom Action

| Element | Type | Description |
|---------|------|-------------|
| Place Order Button | FilledButton | `tr.cart.placeOrder`, full width |

### Behavior

1. **Select Address**: Tap address card to select it
2. **Add Address**: Opens bottom sheet with address form
3. **Place Order**: Validates address selected, shows loading, clears cart on success
4. **No Address**: Place Order button disabled if no address selected

### States

| State | Description |
|-------|-------------|
| Loading | Fetching saved addresses |
| Loaded | Addresses and order summary displayed |
| No Addresses | Only "Add Address" button visible |
| Placing Order | Loading indicator on Place Order button |
| Success | Order placed, navigate to confirmation |
| Error | Show error snackbar |

---

## Screen 4: Add Address Bottom Sheet

### Description
Form to add a new delivery address without leaving checkout flow.

### Visual Design

```
┌─────────────────────────────────────┐
│ ─────                               │  <- Drag handle
│                                     │
│  Add New Address                    │
│                                     │
│  Label (e.g., Home, Office)         │
│  ┌─────────────────────────────────┐│
│  │                                 ││
│  └─────────────────────────────────┘│
│                                     │
│  Street Address *                   │
│  ┌─────────────────────────────────┐│
│  │                                 ││
│  └─────────────────────────────────┘│
│                                     │
│  City *                             │
│  ┌─────────────────────────────────┐│
│  │ Select city             v      ││
│  └─────────────────────────────────┘│
│                                     │
│  Area / District                    │
│  ┌─────────────────────────────────┐│
│  │                                 ││
│  └─────────────────────────────────┘│
│                                     │
│  Phone Number                       │
│  ┌─────────────────────────────────┐│
│  │                                 ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │          Save Address           ││
│  └─────────────────────────────────┘│
│                                     │
└─────────────────────────────────────┘
```

### Form Fields

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| Label | TextField | No | Max 50 chars |
| Street Address | TextField | Yes | Non-empty |
| City | Dropdown | Yes | Select from list |
| Area/District | TextField | No | Max 100 chars |
| Phone | TextField | No | Valid phone format |

### Behavior

1. **City Dropdown**: Fetch cities from existing API (`/api/v1/locations/cities`)
2. **Save**: Validate required fields, save to local storage, close sheet
3. **Auto-select**: Newly added address is auto-selected in Order Summary

---

## Screen 5: Order Confirmation Screen

### Description
Success screen shown after order is placed.

### Visual Design

```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│                                     │
│              [checkmark]            │
│                                     │
│      Order Placed Successfully!     │
│                                     │
│      Order #ORD-2026-0001           │
│                                     │
│   Thank you for your purchase.      │
│   You will receive a confirmation   │
│   email shortly.                    │
│                                     │
│                                     │
│     ┌─────────────────────────┐     │
│     │    Continue Shopping    │     │
│     └─────────────────────────┘     │
│                                     │
│         View Order Details          │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

### Behavior

1. **Continue Shopping**: Navigate to Home screen, clear navigation stack
2. **View Order Details**: Navigate to order details (future feature)

---

## Shared Widget: CartItemCard

### Props

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| product | Product | Yes | Product model |
| quantity | int | Yes | Current quantity |
| onIncrease | VoidCallback | Yes | Increase quantity |
| onDecrease | VoidCallback | Yes | Decrease quantity |
| onDelete | VoidCallback | Yes | Remove from cart |

---

## Data Models

### CartItem

```dart
@JsonSerializable()
class CartItem extends Equatable {
  const CartItem({
    required this.product,
    required this.quantity,
    required this.addedAt,
  });

  final Product product;
  final int quantity;
  final DateTime addedAt;

  double get lineTotal => product.displayPrice * quantity;

  @override
  List<Object?> get props => [product, quantity, addedAt];
}
```

### DeliveryAddress

```dart
@JsonSerializable()
class DeliveryAddress extends Equatable {
  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.streetAddress,
    required this.city,
    this.area,
    this.phone,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String streetAddress;
  final City city;
  final String? area;
  final String? phone;
  final bool isDefault;

  @override
  List<Object?> get props => [id, label, streetAddress, city, area, phone, isDefault];
}
```

### Cart (Aggregate)

```dart
class Cart extends Equatable {
  const Cart({required this.items});

  final List<CartItem> items;

  int get itemCount => items.length;
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  @override
  List<Object?> get props => [items];
}
```

---

## Flow Diagram

```
                    ┌─────────────────┐
                    │  Product Detail │
                    │     Screen      │
                    └────────┬────────┘
                             │ Add to Cart
                             v
┌─────────────────┐    ┌─────────────────┐
│   Any Screen    │<───│  Floating FAB   │
│   with FAB      │    │    (Global)     │
└─────────────────┘    └────────┬────────┘
                             │ Tap FAB or Nav
                             v
                    ┌─────────────────┐
                    │   Cart Screen   │
                    └────────┬────────┘
                             │ Proceed to Checkout
                             v
                    ┌─────────────────┐
                    │ Order Summary   │<──────┐
                    │    Screen       │       │
                    └────────┬────────┘       │
                             │                │
              ┌──────────────┼──────────────┐ │
              │              │              │ │
              v              │              │ │
    ┌─────────────────┐      │              │ │
    │  Add Address    │──────┘              │ │
    │  Bottom Sheet   │ (auto-select)       │ │
    └─────────────────┘                     │ │
                                            │ │
                             │ Place Order  │ │
                             v              │ │
                    ┌─────────────────┐     │ │
                    │ Order Success   │     │ │
                    │    Screen       │     │ │
                    └────────┬────────┘     │ │
                             │              │ │
              ┌──────────────┴──────────────┘ │
              │                               │
              v                               │
    ┌─────────────────┐                       │
    │   Home Screen   │                       │
    └─────────────────┘                       │
```

---

## Functional Requirements

### FR-CART-001: Add to Cart
- Product can be added from Product Detail screen
- If product already in cart, increment quantity
- Show snackbar confirmation: "Added to cart"
- Requires user to be authenticated

### FR-CART-002: Floating Cart FAB
- **Extended FAB** text-only (no icon)
- **Centered** at bottom (`FloatingActionButtonLocation.centerFloat`)
- Label shows: "Show Cart" (localized) + formatted subtotal (bold)
- Appears with slide-up animation when first item added
- Visible on all screens except Cart/Checkout screens
- Tapping navigates to Cart screen
- Disappears with slide-down animation when cart emptied

### FR-CART-003: Cart Persistence
- Cart stored in local secure storage
- Persists across app restarts
- Cleared after successful order placement
- Maximum 99 items in cart

### FR-CART-004: Quantity Management
- Increase: +1 to quantity (max 99 per item)
- Decrease: -1 if qty > 1; show delete confirmation if qty = 1
- Delete: Remove item after confirmation

### FR-CART-005: Cart Totals
- Subtotal = sum of (unit price x quantity)
- Update in real-time as quantities change

### FR-CART-006: Address Management
- Addresses stored locally
- User can add multiple addresses
- One address selected for delivery
- City dropdown populated from API

### FR-CART-007: Order Placement
- Validate address selected
- Show loading state
- Clear cart on success
- Navigate to confirmation screen

---

## Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| Add same product twice | Increment quantity instead of duplicate |
| Product out of stock after adding | Show warning badge on cart item |
| Network error during city fetch | Show cached cities or retry option |
| Empty cart access checkout | Checkout button disabled |
| No address selected | Place Order button disabled with hint |
| Cart cleared mid-checkout | Redirect to empty cart state |
| App killed during order | Order not placed, cart preserved |

---

## Acceptance Criteria

### Navigation
- [ ] "Sold" tab replaced with "Cart" tab in bottom navigation
- [ ] Cart icon uses `LucideIcons.shoppingCart`
- [ ] Cart tab navigates to Cart Screen

### Floating FAB
- [ ] FAB uses `FloatingActionButton.extended` (text-only, no icon)
- [ ] FAB positioned at center (`FloatingActionButtonLocation.centerFloat`)
- [ ] FAB shows "Show Cart" text (localized)
- [ ] FAB shows formatted subtotal (e.g., "$247.00") in bold
- [ ] FAB appears with animation when item added to empty cart
- [ ] FAB visible on Home, Categories, Product screens
- [ ] FAB hidden on Cart and Checkout screens
- [ ] FAB disappears with animation when cart emptied
- [ ] Tapping FAB navigates to Cart Screen

### Cart Screen
- [ ] Displays all cart items with image, name, category, price
- [ ] Quantity can be increased with + button
- [ ] Quantity can be decreased with - button
- [ ] Delete confirmation shown when decreasing from qty 1
- [ ] Trash button removes item after confirmation
- [ ] Subtotal updates in real-time
- [ ] Empty state shown when cart is empty
- [ ] "Browse Products" button navigates to Home

### Order Summary
- [ ] Shows all saved addresses
- [ ] Address can be selected via radio button
- [ ] "Add New Address" opens bottom sheet
- [ ] New address auto-selected after save
- [ ] Order items list shows name, qty, line total
- [ ] Price breakdown shows subtotal, delivery fee, total
- [ ] Place Order disabled without address selection
- [ ] Place Order shows loading during submission

### Add Address
- [ ] Form validates required fields
- [ ] City dropdown populated from API
- [ ] Save button creates new address
- [ ] Sheet closes after successful save

### Order Confirmation
- [ ] Shows success checkmark
- [ ] Displays order number
- [ ] "Continue Shopping" navigates to Home
- [ ] Cart cleared after successful order

### General
- [ ] All strings use localization keys
- [ ] Material 3 components used throughout
- [ ] Uses XContainer, XScaffold, XCard wrappers
- [ ] Error logging via AppLogger
- [ ] Cart data persisted in secure local storage

---

## Localization Keys

Add to `strings_en.i18n.json` and `strings_ar.i18n.json`:

```json
{
  "nav": {
    "cart": "Cart"
  },
  "cart": {
    "title": "Cart",
    "empty": "Your cart is empty",
    "emptyHint": "Browse products and add items to your cart",
    "browseProducts": "Browse Products",
    "subtotal": "Subtotal",
    "proceedToCheckout": "Proceed to Checkout",
    "orderSummary": "Order Summary",
    "deliveryAddress": "Delivery Address",
    "addAddress": "Add New Address",
    "orderItems": "Order Items",
    "deliveryFee": "Delivery Fee",
    "total": "Total",
    "placeOrder": "Place Order",
    "orderPlaced": "Order Placed Successfully!",
    "orderNumber": "Order #{orderId}",
    "thankYou": "Thank you for your purchase. You will receive a confirmation email shortly.",
    "continueShopping": "Continue Shopping",
    "viewOrderDetails": "View Order Details",
    "addedToCart": "Added to cart",
    "removeItem": "Remove Item",
    "removeItemConfirm": "Remove this item from your cart?",
    "remove": "Remove",
    "cancel": "Cancel"
  },
  "address": {
    "addNew": "Add New Address",
    "label": "Label (e.g., Home, Office)",
    "streetAddress": "Street Address",
    "city": "City",
    "area": "Area / District",
    "phone": "Phone Number",
    "save": "Save Address",
    "required": "This field is required"
  }
}
```

---

## References

- [CLAUDE.md](../../../CLAUDE.md) - Project guidelines
- [Design System](../../design_system/) - Widget usage
- [Product Feature](../product/) - Product models and display

---

## Open Questions

| Question | Status |
|----------|--------|
| Delivery fee calculation logic? | TBD - Hardcode or per-product? |
| Order number format? | TBD - ORD-YYYY-XXXX suggested |
| Max items per cart limit? | Suggested: 99 |
| Should FAB have haptic feedback? | TBD |
