# Nazaka Project Documentation

> **Project-specific context, business rules, and specifications**

This directory contains all documentation specific to the Nazaka e-commerce application. Unlike the generic conventions in `/docs/conventions/`, everything here is unique to this product.

## Purpose

- ✅ **Business context** - What Nazaka is and who it serves
- ✅ **Product specifications** - Feature requirements and specs
- ✅ **Design system** - Nazaka's brand colors, typography, widgets
- ✅ **API documentation** - Backend endpoints
- ✅ **Infrastructure** - Deployment, flavors, app initialization

## What's Here

### `/business/`
Product and business context:
- **overview.md** - What Nazaka is, target users, vision
- **rules.md** - Business logic rules (pricing, shipping, returns, etc.)

### `/design/`
Nazaka-specific design tokens and brand identity:
- **colors.md** - Brand color palette (purple/orange theme)
- **typography.md** - Font choices and text styles
- **spacing.md** - Spacing system

> **Note**: Widget wrappers (X* components) are in `/docs/conventions/design_system/widgets/` as they're reusable patterns, not Nazaka-specific.

### `/features/`
Feature specifications and API docs:
- Each feature has: README, prd.md, spec.md, api.md
- Examples: auth, cart, product, category, etc.

### `/infrastructure/`
Nazaka-specific infrastructure values:
- **flavors.md** - Build flavor names, bundle IDs, API endpoints, environment variable values

> **Note**: Implementation patterns for app initialization and theming are in `/docs/conventions/architecture/` as they're reusable.

### Root Files
- **api.md** - Complete backend API documentation (source of truth)

## Relationship to Conventions

```
/docs/
├── conventions/        ← Generic Flutter patterns (reusable)
└── project/           ← Nazaka-specific (this folder)
```

**Example:**
- `/conventions/architecture/authentication.md` → How to implement auth (generic)
- `/project/features/auth/prd.md` → Nazaka's auth requirements (OTP via phone)
- `/project/features/auth/api.md` → Nazaka's auth endpoints

## For AI Agents

When implementing features:

1. **Start here** (`/docs/project/`) to understand requirements
2. **Check conventions** (`/docs/conventions/`) for how to implement
3. **Follow both** - project requirements + architectural patterns

### Workflow Example

**Task: Implement cart feature**

1. Read `/docs/project/features/cart/prd.md` - Requirements
2. Read `/docs/project/features/cart/api.md` - API endpoints
3. Read `/docs/conventions/architecture/state.md` - How to structure controllers
4. Read `/docs/project/design/widgets/` - Use X* wrappers
5. Implement following both project specs and architectural conventions

## Maintenance

This folder evolves with the product:
- Add new features to `/features/`
- Update business rules as requirements change
- Keep API docs in sync with backend
- Maintain design system as brand evolves

**For architectural patterns, update** `/docs/conventions/` instead.
