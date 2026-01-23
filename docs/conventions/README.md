# Conventions

> **Cross-project, reusable conventions for Flutter development**

This directory contains architectural patterns, best practices, and conventions that apply to ANY Flutter project. These docs are intentionally **generic** and free of project-specific references.

## Purpose

- ✅ **Reusable** across multiple Flutter projects
- ✅ **Timeless** architectural principles
- ✅ **Technology-focused** (Flutter, Riverpod, Dio, etc.)
- ✅ **Best practices** for clean architecture

## What's Here

### `/architecture/`
Core architectural patterns and conventions:
- **authentication.md** - Secure token management patterns
- **state.md** - Riverpod state management patterns
- **models.md** - Data model conventions (Equatable, JsonSerializable)
- **http.md** - HTTP client setup with Dio
- **routing.md** - Navigation patterns with auto_route
- **controllers.md** - AsyncNotifier and Notifier patterns
- **localization.md** - i18n with slang
- **api_client.md** - API client architecture
- **conventions.md** - Project structure and naming conventions
- **assets.md** - Asset management with spider
- **observability.md** - Logging and error tracking patterns
- **testing.md** - Testing conventions
- **theming.md** - Material 3 theme setup and requirements
- **initializer.md** - App initialization and service bootstrap patterns

### `/design_system/`
Reusable design patterns and widget wrappers:
- **widgets/** - X* wrapper components (XContainer, XScaffold, XAppBar, etc.)
  - Enforce Material 3 theme compliance
  - Reduce boilerplate
  - Consistent styling across projects

### `/packages/`
Third-party package configurations and usage patterns:
- **dio.md** - HTTP client configuration
- **flavorizr.md** - Build flavors and environment management
- **linting.md** - Code quality and analysis rules
- **lucide_icons.md** - Icon system setup
- **flutter_launcher_icons.md** - App icon generation
- **shimmer.md** - Loading state patterns

### `/best_practices/`
(Future) Common patterns and anti-patterns

### `/workflows/`
(Future) Development workflows and checklists

## What's NOT Here

- ❌ Project-specific business logic
- ❌ Brand colors or design tokens
- ❌ Feature specifications
- ❌ API endpoints documentation
- ❌ Product requirements

**For project-specific docs, see** `/docs/project/`

## Usage

These conventions serve as:
1. **Reference documentation** for this project
2. **Starter template** for new Flutter projects
3. **Shared knowledge base** across your team

## Keeping it Generic

When updating these docs:
- Use `your_app` instead of specific app names
- Use `MyApp` for example widget names
- Avoid project-specific business rules
- Focus on "how" not "what"
- Keep examples technology-focused

---

## Hard Rules (PR Blockers)

These rules are **mandatory** and will block pull requests if violated:

| Rule | Correct | Wrong |
|------|---------|-------|
| **🔐 Authentication** | See `architecture/authentication.md` for 10 mandatory security rules | Storing tokens in SharedPreferences, blocking startup on SecureStorage |
| **Material 3** | `useMaterial3: true`, ColorScheme tokens | Hardcoded colors, M2 widgets |
| **Localization** | `context.t.key` | `Text('hardcoded')` |
| **Hooks** | `HookConsumerWidget` | `StatefulWidget`, `ConsumerStatefulWidget` |
| **Imports** | `package:your_app/...` | Relative imports `../` |
| **Providers** | `static final provider = ...` inside controller | Provider outside class |
| **Pagination** | `Paginated<T>` | `PaginatedProducts`, `PaginatedOrders` |
| **Icons** | `XIcon(LucideIcons.x)` | `Icon(LucideIcons.x)` |
| **Endpoints** | `Endpoints.products` | `'/api/v1/products'` |
| **Widgets** | `XContainer`, `XScaffold`, `XAppBar`, `XCard`, `XFab` | Raw `Container`, `Scaffold`, `AppBar`, `Card`, `FloatingActionButton` |
| **Logging** | `AppLogger.d()`, `AppLogger.e()` | Raw `debugPrint()` or `print()` |
| **Control flow** | Early return | Nested if/else |
| **Edge-to-edge** | `XAppBar` + `XScaffold` (transparent system bars) | Manual `SystemUiOverlayStyle` |

---

## Development Workflows

### After Every Change

```bash
flutter analyze                    # ZERO warnings allowed
dart fix --apply                   # Auto-fix issues
dart run build_runner build -d     # If models changed
dart run slang                     # If strings added
```

### Before Committing

- [ ] All strings use `context.t` (no hardcoded text)
- [ ] Material 3 ColorScheme tokens (no hardcoded colors)
- [ ] X* widget wrappers (not raw Container, Scaffold, etc.)
- [ ] AppLogger for logging (no debugPrint/print)
- [ ] `flutter analyze` passes with zero warnings

---

## Feature & Model Checklists

### New Feature Checklist

- [ ] Read feature requirements from project docs
- [ ] Check relevant architectural patterns in this folder
- [ ] Create structure: `ui/`, `logic/`, `deps/`, `data/`
- [ ] Add translations, run `dart run slang`
- [ ] Use `HookConsumerWidget` for screens
- [ ] Use `static final provider = ...` pattern in controllers
- [ ] Use X* widget wrappers for layout
- [ ] Run `flutter analyze` - zero warnings
- [ ] Register route in router

### New Model Checklist

- [ ] Create in `domain/model/`
- [ ] Extend `Equatable`
- [ ] Add `@JsonSerializable()`
- [ ] All fields `final`, constructor `const`
- [ ] Override `props` getter
- [ ] Add `copyWith` method
- [ ] Add null-safe `fromJson`
- [ ] Run `dart run build_runner build -d`

---

## Exporting for New Projects

This entire `/conventions/` folder can be copied to new Flutter projects with minimal changes:

```bash
# Start a new Flutter project with these conventions
cp -r existing_project/docs/conventions new_project/docs/conventions
```

Then update references to match your new project's package name.
