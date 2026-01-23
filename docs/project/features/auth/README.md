# Auth Feature

> **Agent-Readable Documentation**: This folder contains structured documentation for the auth feature that AI agents can reliably reference during development.

## Overview

Phone-based OTP authentication with guest mode support.

## Flow

```
┌─────────┐     ┌─────────────┐     ┌────────────┐
│ Welcome │ ──► │ Phone Entry │ ──► │ OTP Verify │ ──► Home
└─────────┘     └─────────────┘     └────────────┘
     │
     │ (guest)
     ▼
   Home (limited)
```

## Screens

| Screen | Purpose |
|--------|---------|
| **Welcome** | Entry point — Login/Register or Continue as Guest |
| **Phone Entry** | User enters phone number to receive OTP |
| **OTP Verify** | 5-digit code verification with retry countdown |

## Documentation

| Document | Purpose |
|----------|---------|
| [prd.md](./prd.md) | Product requirements, screens, acceptance criteria |
| [spec.md](./spec.md) | API endpoints and request/response specs |
| [🔐 Authentication Architecture](/docs/architecture/authentication.md) | **MANDATORY** token storage & performance rules (PR blocker) |

## Code Location

```
lib/feature/auth/
├── welcome/
│   ├── ui/
│   ├── logic/
│   └── deps/
├── phone_entry/
│   ├── ui/
│   ├── logic/
│   └── deps/
└── otp_verify/
    ├── ui/
    ├── logic/
    └── deps/
```

## Quick Reference

- **For requirements**: See [prd.md](./prd.md)
- **For API specs**: See [spec.md](./spec.md)
- **For security rules**: See [🔐 Authentication Architecture](/docs/architecture/authentication.md) ⚠️ **MANDATORY**
- **For architecture patterns**: See [/agent.md](/agent.md)

## Key Decisions

- **Phone + OTP** — No email/password authentication
- **Guest mode** — Limited app access without registration

---

*This documentation is designed for both human developers and AI agents.*
