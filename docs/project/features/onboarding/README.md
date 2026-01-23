# Onboarding Feature

> **Agent-Readable Documentation**: This folder contains structured documentation for the onboarding feature that AI agents can reliably reference during development.

## Overview

First-time user onboarding flow introducing the app's value propositions. Shown only once on first install, then navigates to the Welcome screen (auth flow).

## Flow

```
┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│   Screen 1     │ ──► │   Screen 2     │ ──► │   Screen 3     │ ──► Welcome
│   Welcome      │     │  Choose Dress  │     │  Sell Dresses  │     (Auth)
└────────────────┘     └────────────────┘     └────────────────┘
        ◄──────────────────────◄──────────────────────◄
                    (prev buttons)
```

## Screens

| Screen | Title | Purpose |
|--------|-------|---------|
| **Screen 1** | Welcome to Nazaka | Introduces the app, first impression |
| **Screen 2** | Choose Your Dress | Highlights browsing/buying functionality |
| **Screen 3** | Sell Your Dresses | Highlights selling functionality |

## Key Behavior

- **First install only** — Never shown again after completion
- **Skippable** — User can navigate forward/backward
- **Completion** — Clicking "Next" on final screen marks onboarding complete
- **Persistence** — Stores completion flag in local storage

## Documentation

| Document | Purpose |
|----------|---------|
| [prd.md](./prd.md) | Product requirements, screens, acceptance criteria |
| [spec.md](./spec.md) | Technical specification and state management |

## Code Location

```
lib/feature/onboarding/
├── ui/
│   ├── onboarding_screen.dart
│   └── onboarding_page.dart
├── logic/
│   └── onboarding_controller.dart
├── deps/
│   └── onboarding_deps.dart
└── data/
    └── onboarding_repository.dart
```

## Quick Reference

- **For requirements**: See [prd.md](./prd.md)
- **For technical details**: See [spec.md](./spec.md)
- **For architecture patterns**: See [/agent.md](/agent.md)

## Key Decisions

- **3 screens** — Concise introduction, not overwhelming
- **Local storage** — No API calls, completion persisted locally
- **PageView** — Swipe navigation with dots indicator

---

*This documentation is designed for both human developers and AI agents.*


