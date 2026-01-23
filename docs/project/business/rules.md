# Nazaka - Business Rules

## Pricing & Currency

- All prices in **Libyan Dinar (LYD)**
- Prices displayed without decimal places (e.g., "500 دينار" not "500.00")
- Tax included in price display (if applicable)

## Shipping

- Free shipping threshold: **500 LYD** (configurable)
- Standard shipping: 3-5 business days
- Express shipping: 1-2 business days (premium fee)
- Cairo metro area: Faster delivery options

## Cart & Checkout

- Cart persists across sessions (synced to backend when authenticated)
- Guest checkout: Allowed (creates account post-order)
- Minimum order value: **50 LYD** (configurable)
- Maximum items per cart: **99 per product**

## Payments

- Cash on Delivery (COD) - Primary
- Card payments (future)
- Mobile wallets (future)

## Returns & Refunds

- Return window: 14 days from delivery
- Refund processing: 7-10 business days
- Return shipping: Customer pays (unless defective)

## User Accounts

- Phone number authentication (OTP)
- Multiple delivery addresses per user
- Order history retained indefinitely
- Guest orders: Can be claimed by phone number

## Product Availability

- Real-time stock checks at checkout
- Out of stock: Show "Notify me" option
- Pre-orders: Not supported in v1

## Localization

- Default language: **Arabic**
- Fallback language: English
- Date format: DD-MM-YYYY (Libyan standard)
- Time format: 12-hour with AM/PM (Arabic: ص/م)
- Number format: Arabic-Indic numerals in Arabic locale

## Promotions & Discounts

- Promo codes: Single use per user
- Discounts apply before shipping
- Stacking: Not allowed (one promo per order)
