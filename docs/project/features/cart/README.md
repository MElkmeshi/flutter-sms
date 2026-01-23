# Cart & Checkout Feature

Shopping cart functionality with full checkout flow.

## Overview

Enables users to:
- Add products to a local shopping cart
- Manage cart items (quantity, removal)
- Select delivery address
- Place orders

## Key Decisions

| Decision | Choice |
|----------|--------|
| Storage | Local device storage (no server sync) |
| Guest cart | Not supported (login required) |
| Checkout | Full flow with address selection |

## Documents

| Document | Description |
|----------|-------------|
| [prd.md](prd.md) | Product Requirements Document |
| spec.md | Technical specification (TBD) |

## Navigation Change

Replaces **"Sold"** tab with **"Cart"** tab in bottom navigation.

## Screens

1. **Cart Screen** - View/manage cart items
2. **Order Summary** - Address selection + order review
3. **Add Address Sheet** - In-flow address creation
4. **Order Confirmation** - Success screen

## Global Component

**Floating Cart FAB** - Appears on all screens when cart has items
