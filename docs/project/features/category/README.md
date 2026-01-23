# Category Feature

Browse and discover products through category navigation with search, filter, and sort capabilities.

## Documentation

| Document | Description |
|----------|-------------|
| [PRD](./prd.md) | Product requirements and user stories |
| [Spec](./spec.md) | Technical implementation specification |

## Overview

The Category feature provides:
- Grid view of all product categories
- Search within categories
- Advanced filtering (price, size, color, condition, brand)
- Multiple sort options
- Subcategory navigation with breadcrumbs
- Product listing in 2-column grid

## Key Screens

1. **Category Grid** - Top-level category browsing
2. **Subcategory View** - Nested category navigation
3. **Product List** - Filtered/sorted product grid
4. **Filter Sheet** - Bottom sheet for filtering options
5. **Sort Sheet** - Bottom sheet for sort options

## Dependencies

- Shared `ProductCard` widget from Home feature
- Navigation system
- API client for category/product data
