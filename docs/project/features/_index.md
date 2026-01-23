# Features Index

> **For AI Agents**: Index of all feature documentation.

---

## Features

| Feature | Path | Status | Description |
|---------|------|--------|-------------|
| [onboarding](./onboarding/) | `docs/features/onboarding/` | ✅ Done | First-time user introduction flow |
| [auth](./auth/) | `docs/features/auth/` | ✅ Done | Phone-based OTP authentication with guest mode |
| [navigation](./navigation/) | `docs/features/navigation/` | Draft | Bottom navigation bar (5 tabs) |
| [home](./home/) | `docs/features/home/` | Draft | Home screen with product listing |

---

## Feature Structure

Each feature folder contains:

```
<feature_name>/
├── README.md    # Overview, flow diagram, quick reference
├── prd.md       # Product requirements, screens, acceptance criteria
└── spec.md      # API endpoints for this feature
```

---

## Adding a New Feature

1. Create folder: `docs/features/<feature_name>/`
2. Add required files: `README.md`, `prd.md`, `spec.md`
3. Update this index with the new feature
4. Follow templates in existing features

---

## Quick Links

| Feature | PRD | Spec |
|---------|-----|------|
| onboarding | [prd.md](./onboarding/prd.md) | [spec.md](./onboarding/spec.md) |
| auth | [prd.md](./auth/prd.md) | [spec.md](./auth/spec.md) |
| navigation | [prd.md](./navigation/prd.md) | [spec.md](./navigation/spec.md) |
| home | [prd.md](./home/prd.md) | [spec.md](./home/spec.md) |

---

*Add new features to this index as they're created.*

