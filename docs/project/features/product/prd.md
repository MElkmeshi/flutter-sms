# PRD: Product Detail Screen

> **Status**: Draft  
> **Last Updated**: January 2026  
> **Owner**: TBD

---

## Goal

Provide a comprehensive product detail view that showcases product images, details, seller information, and related products to help users make informed purchase decisions.

---

## Non-goals

- Add to cart functionality (separate feature)
- Checkout flow (separate feature)
- Product reviews/ratings (future feature)
- Chat with seller (future feature)

---

## User Stories

- [ ] **US-PROD-001**: As a user, I want to see product images in a gallery so I can view the product from multiple angles.
- [ ] **US-PROD-002**: As a user, I want to see the product price clearly so I can evaluate the cost.
- [ ] **US-PROD-003**: As a user, I want to see product details (state, size, color, etc.) so I can ensure it meets my needs.
- [ ] **US-PROD-004**: As a user, I want to see seller information so I can evaluate the seller's credibility.
- [ ] **US-PROD-005**: As a user, I want to see suggested products so I can discover similar items.
- [ ] **US-PROD-006**: As a user, I want to share the product so I can show it to others.

---

## Screen Layout

### App Bar

| Element | Type | Description |
|---------|------|-------------|
| Back Button | `IconButton` | Returns to previous screen |
| Share Button | `IconButton` | Opens share sheet |
| Favorite Button | `IconButton` | Toggles wishlist status |

---

### Section 1: Image Gallery

Full-width image gallery with swipe navigation.

| Element | Type | Description |
|---------|------|-------------|
| Main Image | `PageView` | Full-width swipeable images |
| Page Indicator | `Dots` | Current image position |
| Thumbnail Strip | `ListView.horizontal` | Small clickable thumbnails |
| Zoom Button | `IconButton` | Opens full-screen gallery |

**Visual Design:**

```
┌─────────────────────────────────────────────┐
│  [←]                          [♡]    [↗]   │
├─────────────────────────────────────────────┤
│                                             │
│                                             │
│                                             │
│              [MAIN PRODUCT IMAGE]           │
│                                             │
│                                             │
│                                             │
│                  ● ○ ○ ○ ○                  │
├─────────────────────────────────────────────┤
│  [thumb1] [thumb2] [thumb3] [thumb4] [→]   │
└─────────────────────────────────────────────┘
```

**Behavior:**
- Swipe left/right to navigate images
- Tap thumbnail to jump to that image
- Tap main image to open full-screen gallery
- Pinch-to-zoom in full-screen mode

---

### Section 2: Price

| Element | Type | Description |
|---------|------|-------------|
| Current Price | `Text` | Large, prominent price |
| Original Price | `Text` | Struck-through if discounted |
| Discount Badge | `Chip` | Percentage off (if applicable) |

**Visual Design:**

```
┌─────────────────────────────────────────────┐
│                                             │
│  $79.99                                     │
│  ~~$120.00~~                    [-34%]      │
│                                             │
└─────────────────────────────────────────────┘
```

---

### Section 3: Product Details

| Element | Type | Description |
|---------|------|-------------|
| Section Title | `Text` | "Product Details" |
| Detail Rows | `ListTile` | Label-value pairs |

**Detail Fields:**
| Field | Description |
|-------|-------------|
| Condition/State | New, Like New, Good, Fair |
| Size | Product size (S, M, L, etc.) |
| Color | Product color |
| Designer/Brand | Brand or designer name |
| Style | Product style (Casual, Formal, etc.) |
| Country of Origin | Where the product is from |

**Visual Design:**

```
┌─────────────────────────────────────────────┐
│  Product Details                            │
├─────────────────────────────────────────────┤
│  Condition          Like New                │
│  ─────────────────────────────────────────  │
│  Size               Medium (M)              │
│  ─────────────────────────────────────────  │
│  Color              Navy Blue               │
│  ─────────────────────────────────────────  │
│  Designer           Zara                    │
│  ─────────────────────────────────────────  │
│  Style              Casual                  │
│  ─────────────────────────────────────────  │
│  Country of Origin  Italy                   │
└─────────────────────────────────────────────┘
```

---

### Section 4: About Seller

| Element | Type | Description |
|---------|------|-------------|
| Section Title | `Text` | "About Seller" |
| Seller Avatar | `CircleAvatar` | Seller profile image |
| Seller Name | `Text` | Seller display name |
| Products Listed | `Text` | Number of active listings |
| Join Date | `Text` | When seller joined platform |
| View Profile | `TextButton` | Opens seller profile |

**Visual Design:**

```
┌─────────────────────────────────────────────┐
│  About Seller                               │
├─────────────────────────────────────────────┤
│                                             │
│  ┌────┐  Sarah's Closet                     │
│  │ 👤 │  156 products listed                │
│  └────┘  Member since Jan 2024              │
│                                             │
│                      [View Profile →]       │
│                                             │
└─────────────────────────────────────────────┘
```

---

### Section 5: Suggested Products

Horizontal scrollable list of related products.

| Element | Type | Description |
|---------|------|-------------|
| Section Title | `Text` | "You Might Also Like" |
| Product Cards | `ListView.horizontal` | List of `ProductCard` widgets |

**Visual Design:**

```
┌─────────────────────────────────────────────┐
│  You Might Also Like                        │
├─────────────────────────────────────────────┤
│                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐     │
│  │         │  │         │  │         │     │
│  │  [IMG]  │  │  [IMG]  │  │  [IMG]  │  →  │
│  │         │  │         │  │         │     │
│  │ Category│  │ Category│  │ Category│     │
│  │ $XX.XX  │  │ $XX.XX  │  │ $XX.XX  │     │
│  └─────────┘  └─────────┘  └─────────┘     │
│                                             │
└─────────────────────────────────────────────┘
```

---

### Add to Cart FAB

Primary action FAB for adding product to cart.

| Element | Type | Description |
|---------|------|-------------|
| Add to Cart | `FloatingActionButton.extended` | Adds product to cart |

**Visual Design:**

```
┌─────────────────────────────────────────────┐
│                                             │
│            [Add to Cart]                    │  <- Extended FAB (centered)
│                                             │
└─────────────────────────────────────────────┘
```

**Hard Rules:**
- Use `XScaffold.floatingActionButton` (not a container/positioned widget)
- `FloatingActionButton.extended` (same style as cart FAB)
- `FloatingActionButtonLocation.centerFloat`
- Uses `primaryContainer` / `onPrimaryContainer` colors
- `elevation: 0`
- Hidden when product is unavailable (sold out)

---

## Full Screen Layout

```
┌─────────────────────────────────────────────┐
│  [←]                          [♡]    [↗]   │
├─────────────────────────────────────────────┤
│                                             │
│                                             │
│              [MAIN PRODUCT IMAGE]           │
│                                             │
│                  ● ○ ○ ○ ○                  │
├─────────────────────────────────────────────┤
│  [thumb1] [thumb2] [thumb3] [thumb4]        │
├─────────────────────────────────────────────┤
│                                             │
│  $79.99                                     │
│  ~~$120.00~~                    [-34%]      │
│                                             │
├─────────────────────────────────────────────┤
│  Product Details                            │
│  ─────────────────────────────────────────  │
│  Condition          Like New                │
│  Size               Medium (M)              │
│  Color              Navy Blue               │
│  Designer           Zara                    │
│  Style              Casual                  │
│  Country of Origin  Italy                   │
├─────────────────────────────────────────────┤
│  About Seller                               │
│  ─────────────────────────────────────────  │
│  ┌────┐  Sarah's Closet                     │
│  │ 👤 │  156 products listed                │
│  └────┘  Member since Jan 2024              │
│                      [View Profile →]       │
├─────────────────────────────────────────────┤
│  You Might Also Like                        │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐           │
│  │Card │ │Card │ │Card │ │Card │  →        │
│  └─────┘ └─────┘ └─────┘ └─────┘           │
├─────────────────────────────────────────────┤
│             [Add to Cart]                   │
└─────────────────────────────────────────────┘
```

---

## Screen States

| State | Description |
|-------|-------------|
| Loading | Shimmer placeholders for all sections |
| Loaded | All product data displayed |
| Error | Error message with retry button |
| Out of Stock | "Sold Out" badge, disabled buttons |
| Own Product | Different actions for seller's own product |

---

## Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PRODUCT DETAIL SCREEN                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  [←]                                        [♡]      [↗]    │    │
│  └─────────────────────────────────────────────────────────────┘    │
│        │                                        │        │           │
│        ▼                                        ▼        ▼           │
│   Previous Screen                         Toggle     Share Sheet     │
│                                           Wishlist                   │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                    IMAGE GALLERY                             │    │
│  │                      ● ○ ○ ○                                 │    │
│  │    [thumb1] [thumb2] [thumb3] [thumb4]                      │    │
│  └─────────────────────────────────────────────────────────────┘    │
│        │                                                             │
│        ▼                                                             │
│   Full Screen Gallery (Pinch-to-zoom)                               │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  $79.99  ~~$120.00~~  [-34%]                                │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  Product Details                                             │    │
│  │  Condition: Like New | Size: M | Color: Navy Blue           │    │
│  │  Designer: Zara | Style: Casual | Origin: Italy             │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  About Seller                               [View Profile]  │    │
│  │  Sarah's Closet | 156 products | Since Jan 2024            │    │
│  └─────────────────────────────────────────────────────────────┘    │
│        │                                                             │
│        ▼                                                             │
│   Seller Profile Screen                                              │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  Suggested Products                                          │    │
│  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐                           │    │
│  │  │Card │ │Card │ │Card │ │Card │  →                        │    │
│  │  └─────┘ └─────┘ └─────┘ └─────┘                           │    │
│  └─────────────────────────────────────────────────────────────┘    │
│        │                                                             │
│        ▼                                                             │
│   Product Detail (Recursive)                                         │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                    [Add to Cart]                            │    │
│  └─────────────────────────────────────────────────────────────┘    │
│        │                                                             │
│        ▼                                                             │
│   Shows FAB → Cart Screen → Checkout Flow                            │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Functional Requirements

### FR-PROD-001: Image Gallery
- Display product images in swipeable gallery
- Show page indicator for current position
- Display thumbnails for quick navigation
- Support pinch-to-zoom in full-screen mode
- Handle missing images with placeholder

### FR-PROD-002: Price Display
- Show current price prominently
- Display original price struck-through if discounted
- Show discount percentage badge when applicable
- Format prices according to locale/currency

### FR-PROD-003: Product Details
- Display all product attributes
- Handle missing/null attributes gracefully
- Show condition with visual indicator (badge/color)
- Support expandable description if too long

### FR-PROD-004: About Seller
- Display seller profile image
- Show seller name
- Display number of products listed
- Show member since date
- "View Profile" navigates to seller profile

### FR-PROD-005: Suggested Products
- Fetch related/similar products
- Display in horizontal scrollable list
- Use shared `ProductCard` widget
- Limit to 10 items
- Tap navigates to that product detail

### FR-PROD-006: Share
- Generate shareable product link
- Open native share sheet
- Include product image and title in share preview

### FR-PROD-007: Wishlist
- Toggle product in user's wishlist
- Show filled/outline heart based on status
- Require authentication to save
- Optimistic UI update with rollback on failure

### FR-PROD-008: Bottom Actions
- Single "Add to Cart" extended FAB (centered)
- Uses `FloatingActionButton.extended` with `elevation: 0`
- Uses `primaryContainer` / `onPrimaryContainer` colors
- Adds product to cart, shows snackbar confirmation
- Requires authentication
- Hidden if product out of stock (show "Sold Out" instead)

---

## Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| Product has only 1 image | Hide thumbnails, hide page indicator |
| Product has no images | Show placeholder image |
| Product is out of stock | Show "Sold Out" badge, disable action buttons |
| User views own product | Show "Edit" instead of cart buttons |
| Seller account deleted | Show "Seller unavailable" |
| Price is 0 | Show "Free" instead of $0.00 |
| Very long product description | Truncate with "Read More" |
| No suggested products | Hide suggestions section |
| Image load failure | Show placeholder for failed image |
| Network offline | Show cached data if available, else error |

---

## Acceptance Criteria

### Image Gallery
- [ ] Images display in swipeable gallery
- [ ] Page indicator shows current position
- [ ] Thumbnails are clickable and navigate to image
- [ ] Tap image opens full-screen gallery
- [ ] Pinch-to-zoom works in full-screen
- [ ] Placeholder shown for missing images

### Price
- [ ] Current price displayed prominently
- [ ] Original price shown struck-through when discounted
- [ ] Discount badge shows percentage off
- [ ] Prices formatted correctly for locale

### Product Details
- [ ] All detail fields displayed (Condition, Size, Color, Designer, Style, Country)
- [ ] Missing fields handled gracefully
- [ ] Section is scrollable if content is long

### About Seller
- [ ] Seller avatar displayed
- [ ] Seller name displayed
- [ ] Product count displayed
- [ ] Join date displayed
- [ ] "View Profile" button navigates to seller profile

### Suggested Products
- [ ] Horizontal scrollable list of products
- [ ] Uses shared `ProductCard` widget
- [ ] Tapping product navigates to its detail
- [ ] Hidden if no suggestions available

### Actions
- [ ] Share button opens share sheet
- [ ] Favorite button toggles wishlist
- [ ] "Add to Cart" uses `FloatingActionButton.extended` (centered)
- [ ] "Add to Cart" uses primaryContainer colors, elevation 0
- [ ] "Sold Out" shown when product unavailable

### General
- [ ] Loading state shows shimmers
- [ ] Error state shows retry option
- [ ] All UI follows Material 3 standards
- [ ] All strings use localization keys
- [ ] Analytics: `product_viewed`, `product_shared`, `wishlist_toggled`, `add_to_cart`, `buy_now`

---

## Data Models

### Product

```dart
class Product {
  final String id;
  final String title;
  final String? description;
  final List<String> imageUrls;
  final double price;
  final double? originalPrice;
  final String condition;  // new, like_new, good, fair
  final String? size;
  final String? color;
  final String? designer;
  final String? style;
  final String? countryOfOrigin;
  final String categoryId;
  final String sellerId;
  final bool isAvailable;
  final DateTime createdAt;
}
```

### Seller (Summary)

```dart
class SellerSummary {
  final String id;
  final String name;
  final String? avatarUrl;
  final int productCount;
  final DateTime joinedAt;
}
```

---

## Open Questions

| Question | Status |
|----------|--------|
| Max number of product images? | **10** (suggested) |
| Should we show seller rating? | **Future feature** (decided) |
| Allow zooming on main image without full-screen? | **No** (decided) |
| Number of suggested products to show? | **10** (decided) |

---

## References

- [Agent Guidelines](/agent.md) - Architecture and coding standards
- [Design System](/docs/design_system.md) - Colors, typography, spacing
- [Home PRD](/docs/features/home/prd.md) - ProductCard widget reference
- [Category PRD](/docs/features/category/prd.md) - Category navigation
