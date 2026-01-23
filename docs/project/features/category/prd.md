# PRD: Category Screen

> **Status**: Draft  
> **Last Updated**: January 2026  
> **Owner**: TBD

---

## Goal

Provide a comprehensive category browsing experience that allows users to discover products through category navigation, search, filtering, and sorting capabilities.

---

## Non-goals

- Product details (separate feature)
- Shopping cart functionality (separate feature)
- Checkout flow (separate feature)

---

## User Stories

- [ ] **US-CAT-001**: As a user, I want to see all categories in a grid layout so I can browse by category.
- [ ] **US-CAT-002**: As a user, I want to search within categories so I can find specific items quickly.
- [ ] **US-CAT-003**: As a user, I want to filter products so I can narrow down my search.
- [ ] **US-CAT-004**: As a user, I want to sort products so I can view them in my preferred order.
- [ ] **US-CAT-005**: As a user, I want to navigate to subcategories so I can browse more specific items.
- [ ] **US-CAT-006**: As a user, I want to see products within a category so I can browse available items.

---

## Screen Layout

### App Bar

| Element | Type | Description |
|---------|------|-------------|
| Back Button | `IconButton` | Returns to previous screen |
| Title | `Text` | Category name or "Categories" |
| Search Icon | `IconButton` | Opens/expands search bar |

---

### Search Bar

| Element | Type | Description |
|---------|------|-------------|
| Search Input | `TextField` | Text input for search query |
| Clear Button | `IconButton` | Clears search input |
| Cancel | `TextButton` | Closes search and clears query |

**Behavior:**
- Tapping search icon expands search bar
- Search triggers on submit or after 500ms debounce
- Filters products within current category
- Shows recent searches when focused with empty query

---

### Category Grid View (Root Level)

When user first enters the category screen, show all top-level categories.

| Element | Type | Description |
|---------|------|-------------|
| Category Grid | `GridView` | 2-column grid of category cards |
| Category Card | `Card` | Image + category name |

**Visual Design:**

```
┌─────────────────────────────────────────────┐
│  [←]  Categories                     [🔍]   │
├─────────────────────────────────────────────┤
│                                             │
│  ┌──────────────┐  ┌──────────────┐        │
│  │              │  │              │        │
│  │    [IMG]     │  │    [IMG]     │        │
│  │              │  │              │        │
│  │   Women's    │  │    Men's     │        │
│  └──────────────┘  └──────────────┘        │
│                                             │
│  ┌──────────────┐  ┌──────────────┐        │
│  │              │  │              │        │
│  │    [IMG]     │  │    [IMG]     │        │
│  │              │  │              │        │
│  │    Kids      │  │ Accessories  │        │
│  └──────────────┘  └──────────────┘        │
│                                             │
│  ┌──────────────┐  ┌──────────────┐        │
│  │              │  │              │        │
│  │    [IMG]     │  │    [IMG]     │        │
│  │              │  │              │        │
│  │    Shoes     │  │    Bags      │        │
│  └──────────────┘  └──────────────┘        │
│                                             │
└─────────────────────────────────────────────┘
```

---

### Subcategory/Product View

When user selects a category, show subcategories (if any) or products.

| Element | Type | Description |
|---------|------|-------------|
| Breadcrumb | `Row` | Navigation path (e.g., "Women's > Dresses") |
| Subcategory Chips | `Wrap` | Horizontal chips for subcategories |
| Filter Button | `OutlinedButton` | Opens filter bottom sheet |
| Sort Button | `OutlinedButton` | Opens sort bottom sheet |
| Product Grid | `GridView` | 2-column grid of products |
| Product Count | `Text` | "X products found" |

**Visual Design:**

```
┌─────────────────────────────────────────────┐
│  [←]  Women's Fashion                [🔍]   │
├─────────────────────────────────────────────┤
│  Women's > Dresses                          │
├─────────────────────────────────────────────┤
│  [All] [Casual] [Formal] [Party] [→]        │
├─────────────────────────────────────────────┤
│  [🔽 Filter]              [↕️ Sort]          │
│  125 products found                         │
├─────────────────────────────────────────────┤
│                                             │
│  ┌──────────────┐  ┌──────────────┐        │
│  │              │  │              │        │
│  │    [IMG]     │  │    [IMG]     │        │
│  │              │  │              │        │
│  │  Category    │  │  Category    │        │
│  │  ~~$99~~ $79 │  │  $120        │        │
│  └──────────────┘  └──────────────┘        │
│                                             │
│  ┌──────────────┐  ┌──────────────┐        │
│  │              │  │              │        │
│  │    [IMG]     │  │    [IMG]     │        │
│  │              │  │              │        │
│  │  Category    │  │  Category    │        │
│  │  $85         │  │  ~~$150~~ $99│        │
│  └──────────────┘  └──────────────┘        │
│                                             │
└─────────────────────────────────────────────┘
```

---

### Filter Bottom Sheet

| Element | Type | Description |
|---------|------|-------------|
| Header | `Text` | "Filter" with close button |
| Price Range | `RangeSlider` | Min/Max price filter |
| Size | `Wrap<Chip>` | Multi-select size options |
| Color | `Wrap<ColorChip>` | Multi-select color options |
| Condition | `Wrap<Chip>` | New, Like New, Good, Fair |
| Brand | `Wrap<Chip>` | Multi-select brand options |
| Apply Button | `ElevatedButton` | Applies filters |
| Clear All | `TextButton` | Clears all filters |

**Visual Design:**

```
┌─────────────────────────────────────────────┐
│  Filter                              [✕]    │
├─────────────────────────────────────────────┤
│                                             │
│  Price Range                                │
│  $0 ──────●────────●────── $500            │
│           $50      $200                     │
│                                             │
│  Size                                       │
│  [XS] [S] [M] [L] [XL] [XXL]               │
│                                             │
│  Color                                      │
│  [⚫] [⚪] [🔴] [🔵] [🟢] [🟡]               │
│                                             │
│  Condition                                  │
│  [New] [Like New] [Good] [Fair]            │
│                                             │
│  Brand                                      │
│  [Nike] [Adidas] [Zara] [H&M] [+More]      │
│                                             │
├─────────────────────────────────────────────┤
│  [Clear All]            [Apply Filters]     │
└─────────────────────────────────────────────┘
```

---

### Sort Bottom Sheet

| Element | Type | Description |
|---------|------|-------------|
| Header | `Text` | "Sort by" |
| Sort Options | `RadioListTile` | List of sort options |

**Sort Options:**
- Newest First (default)
- Price: Low to High
- Price: High to Low
- Most Popular
- Best Match (when searching)

**Visual Design:**

```
┌─────────────────────────────────────────────┐
│  Sort by                             [✕]    │
├─────────────────────────────────────────────┤
│  ◉ Newest First                             │
│  ○ Price: Low to High                       │
│  ○ Price: High to Low                       │
│  ○ Most Popular                             │
│  ○ Best Match                               │
└─────────────────────────────────────────────┘
```

---

## Shared Widget: CategoryCard

A reusable category card component.

| Element | Type | Description |
|---------|------|-------------|
| Category Image | `Image` | Category representative image |
| Category Name | `Text` | Category label |
| Product Count | `Text` | Number of items (optional) |

**Props:**
```dart
class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int? productCount;
  final VoidCallback? onTap;
}
```

---

## Screen States

| State | Description |
|-------|-------------|
| Loading | Shimmer placeholders for grid |
| Loaded | Categories/products displayed |
| Empty | No products match filters/search |
| Error | Error message with retry button |
| Searching | Loading state during search |
| Filtered | Active filters indicator shown |

---

## Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                        CATEGORY SCREEN                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  [←] Categories                                      [🔍]   │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                              │                                       │
│                              ▼                                       │
│                        Search Screen                                 │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                    CATEGORY GRID                             │    │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐        │    │
│  │  │Women's  │  │ Men's   │  │  Kids   │  │  Shoes  │        │    │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘        │    │
│  └─────────────────────────────────────────────────────────────┘    │
│        │                                                             │
│        ▼                                                             │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │               SUBCATEGORY / PRODUCT VIEW                     │    │
│  │  Breadcrumb: Women's > Dresses                              │    │
│  │  [All] [Casual] [Formal] [Party]                            │    │
│  │  [Filter] [Sort]                                            │    │
│  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐                           │    │
│  │  │Card │ │Card │ │Card │ │Card │                           │    │
│  │  └─────┘ └─────┘ └─────┘ └─────┘                           │    │
│  └─────────────────────────────────────────────────────────────┘    │
│        │              │              │                               │
│        ▼              ▼              ▼                               │
│   Product Detail  Filter Sheet   Sort Sheet                          │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Functional Requirements

### FR-CAT-001: Category Grid
- Display all top-level categories in 2-column grid
- Show category image and name
- Tap navigates to subcategory or product list
- Support infinite scroll if many categories

### FR-CAT-002: Search
- Search within current category scope
- Debounce search input (500ms)
- Show search results in grid
- Display "No results" for empty results
- Save recent searches (up to 10)

### FR-CAT-003: Subcategory Navigation
- Display subcategories as horizontal chips
- "All" chip shows all products in category
- Support nested subcategories
- Breadcrumb shows navigation path

### FR-CAT-004: Filter
- Price range slider (category-specific min/max)
- Size multi-select
- Color multi-select
- Condition multi-select (New, Like New, Good, Fair)
- Brand multi-select
- Show active filter count on button
- Persist filters during session

### FR-CAT-005: Sort
- Support multiple sort options
- Remember user's sort preference
- Default to "Newest First"
- "Best Match" only when search is active

### FR-CAT-006: Product Grid
- Display products in 2-column grid
- Use shared `ProductCard` widget
- Infinite scroll pagination
- Show product count
- Tap opens product details

### FR-CAT-007: Pull to Refresh
- Swipe down to refresh products
- Maintain current filters/sort

---

## Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| Category has no products | Show "No products in this category" |
| Search returns no results | Show "No products match your search" |
| Filters return no results | Show "No products match your filters" with clear option |
| Image load failure | Show placeholder image |
| Network offline | Show cached data if available, else error |
| Deep category nesting | Breadcrumb truncates with "..." |
| Very long category name | Text truncates with ellipsis |

---

## Acceptance Criteria

### Category Grid
- [ ] 2-column grid displays categories
- [ ] Category cards show image and name
- [ ] Tapping category navigates correctly
- [ ] Loading shows shimmer placeholders

### Search
- [ ] Search icon opens search bar
- [ ] Search input has debounce
- [ ] Results update based on query
- [ ] Clear button clears input
- [ ] Empty results shows appropriate message

### Filter
- [ ] Filter button opens bottom sheet
- [ ] Price range slider works
- [ ] Size selection works
- [ ] Color selection works
- [ ] Condition selection works
- [ ] Brand selection works
- [ ] Apply button applies filters
- [ ] Clear all resets filters
- [ ] Active filter count shown on button

### Sort
- [ ] Sort button opens bottom sheet
- [ ] All sort options selectable
- [ ] Selected sort option persists
- [ ] Products re-order on selection

### Product Grid
- [ ] 2-column product grid displays
- [ ] Uses shared `ProductCard` widget
- [ ] Infinite scroll loads more
- [ ] Product count is accurate
- [ ] Tapping product opens details

### General
- [ ] Pull to refresh works
- [ ] Loading states show properly
- [ ] Error states show retry option
- [ ] All UI follows Material 3 standards
- [ ] All strings use localization keys
- [ ] Analytics: `category_viewed`, `search_performed`, `filter_applied`, `sort_changed`

---

## Open Questions

| Question | Status |
|----------|--------|
| Max filter options before "Show More"? | **Decision needed** |
| Should filters persist across categories? | **No** (decided) |
| Number of recent searches to save? | **10** (decided) |
| Default products per page for pagination? | **20** (suggested) |

---

## References

- [Agent Guidelines](/agent.md) - Architecture and coding standards
- [Design System](/docs/design_system.md) - Colors, typography, spacing
- [Home PRD](/docs/features/home/prd.md) - ProductCard widget reference
- [Navigation PRD](/docs/features/navigation/prd.md) - Bottom navigation
