# Navigation Feature (Bottom Navigation Bar)

> **Agent-Readable Documentation**: This folder contains structured documentation for the app's bottom navigation.

## Overview

The bottom navigation bar provides access to the app's main sections. It's visible on all main screens after authentication.

## Layout

```
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│                      [SCREEN CONTENT]                        │
│                                                              │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│    🏠        📂        ➕        📦        👤               │
│   Home   Categories   Sell    Sold Items  Account            │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## Tabs

| Tab | Icon | Screen | Status |
|-----|------|--------|--------|
| **Home** | `home` | Product listing | 📋 PRD Ready |
| **Categories** | `grid` | Category browser | ⏸️ Pending |
| **Sell** | `plus-circle` | Create listing | ⏸️ Pending |
| **Sold Items** | `package` | Sold products | ⏸️ Pending |
| **Account** | `user` | Profile & settings | ⏸️ Pending |

## Documentation

| Document | Purpose |
|----------|---------|
| [prd.md](./prd.md) | Product requirements, tabs, behavior |
| [spec.md](./spec.md) | Technical implementation |

## Code Location

```
lib/feature/shell/
├── ui/
│   └── app_shell.dart          # Scaffold with NavigationBar
├── logic/
│   └── navigation_controller.dart
└── deps/
    └── navigation_deps.dart
```

## Quick Reference

- **For requirements**: See [prd.md](./prd.md)
- **For technical details**: See [spec.md](./spec.md)
- **For architecture patterns**: See [/agent.md](/agent.md)

---

*This documentation is designed for both human developers and AI agents.*


