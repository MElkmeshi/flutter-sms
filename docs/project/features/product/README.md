# Product Feature

Detailed product view with image gallery, product information, seller details, and related products.

## Documentation

| Document | Description |
|----------|-------------|
| [PRD](./prd.md) | Product requirements and user stories |
| [Spec](./spec.md) | Technical implementation specification |

## Overview

The Product Detail feature provides:
- Full-screen image gallery with zoom
- Price display with discount indicators
- Comprehensive product details
- Seller information and profile link
- Suggested/related products
- Share and wishlist functionality
- Add to cart and buy now actions

## Key Sections

1. **Image Gallery** - Swipeable product images with thumbnails
2. **Price Section** - Current price, original price, discount badge
3. **Product Details** - Condition, size, color, designer, style, origin
4. **About Seller** - Name, product count, join date
5. **Suggested Products** - Horizontal scroll of related items
6. **Bottom Actions** - Add to cart, buy now buttons

## Dependencies

- Shared `ProductCard` widget from Home feature
- Cart feature (for add to cart)
- Checkout feature (for buy now)
- Wishlist feature (for favorites)
- Seller profile feature
