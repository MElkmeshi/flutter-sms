# Account Feature

> **Agent-Readable Documentation**: This folder contains structured documentation for the account/settings feature.

## Overview

The account screen serves as a settings hub, providing users with quick access to app preferences (theme, language), legal information (privacy policy, terms), and authentication controls (sign out).

## Flow

```
+----------------------------------------------------------+
|                     ACCOUNT SCREEN                        |
+----------------------------------------------------------+
|  Account                                                  |
+----------------------------------------------------------+
|  +----------------------------------------------------+  |
|  | [sun]  Theme                            Light    > |  |
|  +----------------------------------------------------+  |
|         |                                                 |
|         v                                                 |
|  +------------------+                                     |
|  | ThemeBottomSheet |                                     |
|  |  o System        |                                     |
|  |  * Light         |                                     |
|  |  o Dark          |                                     |
|  +------------------+                                     |
|                                                           |
|  +----------------------------------------------------+  |
|  | [globe]  Language                       English  > |  |
|  +----------------------------------------------------+  |
|         |                                                 |
|         v                                                 |
|  +---------------------+                                  |
|  | LanguageBottomSheet |                                  |
|  |  * English          |                                  |
|  |  o Arabic           |                                  |
|  +---------------------+                                  |
|                                                           |
|  --------------------------------------------------      |
|                                                           |
|  +----------------------------------------------------+  |
|  | [shield]  Privacy Policy                         > |  |
|  +----------------------------------------------------+  |
|         |                                                 |
|         v                                                 |
|  +------------------+                                     |
|  | WebView Screen   |                                     |
|  +------------------+                                     |
|                                                           |
|  +----------------------------------------------------+  |
|  | [file-text]  Terms of Service                    > |  |
|  +----------------------------------------------------+  |
|         |                                                 |
|         v                                                 |
|  +------------------+                                     |
|  | WebView Screen   |                                     |
|  +------------------+                                     |
|                                                           |
|                                                           |
|            +------------------------+                     |
|            |       Sign Out         |  <- Outlined        |
|            +------------------------+                     |
|                      |                                    |
|                      v                                    |
|            +-------------------+                          |
|            | Confirm Dialog    |                          |
|            | Cancel | Sign Out |                          |
|            +-------------------+                          |
|                      |                                    |
|                      v                                    |
|              Welcome Screen                               |
+----------------------------------------------------------+
```

## Sections

| Section | Purpose |
|---------|---------|
| **Theme** | Switch between system, light, and dark mode |
| **Language** | Change app language (English/Arabic) |
| **Privacy Policy** | View privacy policy in WebView |
| **Terms of Service** | View terms in WebView |
| **Sign Out** | Log out and return to welcome screen |

## Shared Components

| Component | Location | Purpose |
|-----------|----------|---------|
| SelectionBottomSheet | `lib/ui/widget/` | Generic bottom sheet for single selection |
| AccountListTile | `lib/feature/account/ui/` | Consistent list item for settings |

## Documentation

| Document | Purpose |
|----------|---------|
| [prd.md](./prd.md) | Product requirements, screens, acceptance criteria |
| [spec.md](./spec.md) | API endpoints, controllers, and technical specification |

## Code Location

```
lib/feature/account/
|-- ui/
|   |-- account_screen.dart
|   |-- account_list_tile.dart
|   +-- webview_screen.dart
|-- logic/
|   |-- theme_controller.dart
|   +-- locale_controller.dart
|-- data/
|   +-- account_repository.dart
+-- deps/
    +-- account_deps.dart

lib/ui/widget/
+-- selection_bottom_sheet.dart   # Shared selection bottom sheet
```

## Quick Reference

- **For requirements**: See [prd.md](./prd.md)
- **For technical specs**: See [spec.md](./spec.md)
- **For architecture patterns**: See [/agent.md](/agent.md)

## Related Features

- [Navigation](/docs/features/navigation/README.md) - Bottom navigation bar
- [Auth](/docs/features/auth/README.md) - Authentication flow

---

*This documentation is designed for both human developers and AI agents.*
