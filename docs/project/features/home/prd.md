# PRD: Home Feature (Product Listing)

> **Status**: Draft  
> **Last Updated**: January 2026  
> **Owner**: TBD

---

## Goal

Provide an engaging home screen that showcases products, promotions, and brands to drive user engagement and purchases.

---

## Non-goals

- Product search functionality (separate feature)
- Product details page (separate feature)
- Shopping cart (separate feature)
- Filtering/sorting (handled in search/category screens)

---

## User Stories

- [ ] **US-HOME-001**: As a user, I want to see promotional ads so I can discover deals.
- [ ] **US-HOME-002**: As a user, I want to see popular products so I can find trending items.
- [ ] **US-HOME-003**: As a user, I want to see trending products so I can stay updated with fashion.
- [ ] **US-HOME-004**: As a user, I want to browse brands so I can shop by brand preference.
- [ ] **US-HOME-005**: As a user, I want to access notifications so I can see updates.
- [ ] **US-HOME-006**: As a user, I want to search products so I can find specific items.

---

## Screen Layout

### App Bar

| Element | Type | Description |
|---------|------|-------------|
| Search Icon/Bar | `IconButton` / `TextField` | Opens search screen or expands search |
| Notification Icon | `IconButton` with badge | Shows notification count, opens notifications |

---

### Section 1: Ads Carousel

Promotional banners with auto-scrolling.

| Element | Type | Description |
|---------|------|-------------|
| Banner Images | `PageView` / Carousel | Full-width promotional images |
| Page Indicator | `Dots` | Shows current position |
| Auto-scroll | Timer | Changes slide every 5 seconds |

**Behavior:**
- Auto-scroll every 5 seconds
- Manual swipe navigation
- Tapping banner opens linked content (URL or product)
- Loops infinitely

---

### Section 2: Most Viewed Products

Horizontal scrollable list of popular products.

| Element | Type | Description |
|---------|------|-------------|
| Section Title | `Text` | "Most Viewed" |
| See All | `TextButton` | Navigates to full list |
| Product Cards | `ListView.horizontal` | List of `ProductCard` widgets |

---

### Section 3: Trending Products

Horizontal scrollable list of trending products.

| Element | Type | Description |
|---------|------|-------------|
| Section Title | `Text` | "Trending" |
| See All | `TextButton` | Navigates to full list |
| Product Cards | `ListView.horizontal` | List of `ProductCard` widgets |

---

### Section 4: Brands

Horizontal scrollable list of brand logos.

| Element | Type | Description |
|---------|------|-------------|
| Section Title | `Text` | "Brands" |
| Brand Logos | `ListView.horizontal` | Circular/rounded brand images |

**Behavior:**
- Tapping brand opens brand products page

---

## Shared Widget: ProductCard

> ⚠️ **IMPORTANT**: This is a shared widget used across multiple features.

A reusable product card component located in `lib/ui/widget/product_card.dart`.

| Element | Type | Description |
|---------|------|-------------|
| Product Image | `Image` | Main product photo |
| Category | `Text` / `Chip` | Product category label |
| Price | `Text` | Original price |
| Discount Price | `Text` | Price after discount (if applicable) |

**Visual Design:**

```
┌─────────────────────────┐
│                         │
│         [IMAGE]         │
│                         │
├─────────────────────────┤
│  Category               │
│  ~~$120~~  $99          │
└─────────────────────────┘
```

**States:**
| State | Description |
|-------|-------------|
| Default | Shows image, category, price |
| Discounted | Shows original price struck through + discount price |
| Loading | Shimmer placeholder |
| Error | Placeholder image |

**Props:**
```dart
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final double price;
  final double? discountPrice;  // null = no discount
  final VoidCallback? onTap;
}
```

---

## Screen States

| State | Description |
|-------|-------------|
| Loading | Shimmer placeholders for all sections |
| Loaded | All sections populated with data |
| Error | Error message with retry button |
| Partial Error | Some sections loaded, failed sections show error |
| Empty | No products available (unlikely for home) |

---

## Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                           HOME SCREEN                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  [🔍 Search]                                    [🔔 Badge]  │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                              │                          │            │
│                              ▼                          ▼            │
│                        Search Screen           Notifications         │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                    ADS CAROUSEL                              │    │
│  │                      ● ○ ○ ○                                 │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                              │                                       │
│                              ▼                                       │
│                    Banner Deep Link / Product                        │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  Most Viewed                                    [See All →] │    │
│  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐                           │    │
│  │  │Card │ │Card │ │Card │ │Card │  →                        │    │
│  │  └─────┘ └─────┘ └─────┘ └─────┘                           │    │
│  └─────────────────────────────────────────────────────────────┘    │
│        │                                        │                    │
│        ▼                                        ▼                    │
│   Product Details                        Most Viewed List            │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  Trending                                       [See All →] │    │
│  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐                           │    │
│  │  │Card │ │Card │ │Card │ │Card │  →                        │    │
│  │  └─────┘ └─────┘ └─────┘ └─────┘                           │    │
│  └─────────────────────────────────────────────────────────────┘    │
│        │                                        │                    │
│        ▼                                        ▼                    │
│   Product Details                         Trending List              │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  Brands                                                     │    │
│  │  ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐                             │    │
│  │  │ 🏷 │ │ 🏷 │ │ 🏷 │ │ 🏷 │ │ 🏷 │  →                      │    │
│  │  └───┘ └───┘ └───┘ └───┘ └───┘                             │    │
│  └─────────────────────────────────────────────────────────────┘    │
│        │                                                             │
│        ▼                                                             │
│   Brand Products                                                     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Functional Requirements

### FR-001: Ads Carousel
- Display promotional banners from API
- Auto-scroll every 5 seconds
- Support manual swipe navigation
- Loop infinitely
- Handle banner tap (deep link)

### FR-002: Most Viewed Section
- Fetch most viewed products from API
- Display horizontal scrollable list
- Limit to 10 items in horizontal view
- "See All" navigates to full list

### FR-003: Trending Section
- Fetch trending products from API
- Display horizontal scrollable list
- Limit to 10 items in horizontal view
- "See All" navigates to full list

### FR-004: Brands Section
- Fetch brands from API
- Display horizontal scrollable list
- Brand tap navigates to brand products

### FR-005: Product Card
- Display product image, category, price
- Show discount price when available
- Original price struck through when discounted
- Tap navigates to product details

### FR-006: Pull to Refresh
- Swipe down to refresh all sections
- Show refresh indicator

---

## Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| No ads available | Hide ads section |
| No products in section | Hide section or show "No products" |
| Image load failure | Show placeholder image |
| Network offline | Show cached data if available, else error |
| Slow network | Show shimmer loading state |
| Product has no discount | Hide discount price, show only regular price |

---

## Acceptance Criteria

### App Bar
- [ ] Search icon/button visible
- [ ] Notification icon visible with badge (when notifications exist)
- [ ] Tapping search opens search screen
- [ ] Tapping notification opens notifications

### Ads Carousel
- [ ] Displays promotional banners
- [ ] Auto-scrolls every 5 seconds
- [ ] Manual swipe works
- [ ] Page indicator shows current position
- [ ] Tapping banner performs action

### Most Viewed Section
- [ ] Section title "Most Viewed" displayed
- [ ] "See All" button visible
- [ ] Horizontal scrollable product list
- [ ] Products use `ProductCard` widget
- [ ] Tapping product opens details

### Trending Section
- [ ] Section title "Trending" displayed
- [ ] "See All" button visible
- [ ] Horizontal scrollable product list
- [ ] Products use `ProductCard` widget
- [ ] Tapping product opens details

### Brands Section
- [ ] Section title "Brands" displayed
- [ ] Horizontal scrollable brand logos
- [ ] Tapping brand opens brand products

### ProductCard Widget
- [ ] Displays product image
- [ ] Displays category label
- [ ] Displays price
- [ ] Shows discount price (struck original) when applicable
- [ ] Loading state shows shimmer
- [ ] Image error shows placeholder

### General
- [ ] Pull to refresh works
- [ ] Loading state shows shimmers
- [ ] Error state shows retry option
- [ ] All UI follows Material 3 standards
- [ ] All strings use localization keys
- [ ] Analytics: `home_viewed`, `product_tapped`, `banner_tapped`, `brand_tapped`

---

## Open Questions

| Question | Status |
|----------|--------|
| Ads carousel auto-scroll interval | **5 seconds** (decided) |
| Number of products per section | **10** (decided) |
| Should brands section be visible to guests? | **Decision needed** |

---

## References

- [Agent Guidelines](/agent.md) — Architecture and coding standards
- [Design System](/docs/design_system.md) — Colors, typography, spacing
- [Navigation PRD](/docs/features/navigation/prd.md) — Bottom navigation


