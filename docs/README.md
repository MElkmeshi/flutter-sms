# Documentation

Welcome to the documentation system. This project uses a **two-perspective documentation system** to separate reusable patterns from project-specific context.

## Quick Navigation

### 📦 `/conventions/` — Reusable Patterns
**Cross-project Flutter conventions and architectural patterns**

Perfect for:
- ✅ Starting new Flutter projects
- ✅ Learning architectural best practices
- ✅ Understanding "how to build" patterns

[**→ Go to Conventions**](./conventions/)

---

### 🎯 `/project/` — Project Context
**Everything specific to this project**

Contains:
- Business rules and context
- Feature requirements and specs
- Design system values (colors, typography, spacing)
- API documentation
- Infrastructure configuration

[**→ Go to Project Docs**](./project/)

---

## For AI Agents & Developers

### When implementing a feature:

1. **Start with project docs** → `docs/project/features/{feature}/`
   - Read requirements, API endpoints, business rules

2. **Check conventions** → `docs/conventions/architecture/`
   - Follow architectural patterns and best practices

3. **Use both together** → Project requirements + Architectural patterns

### Example: Implementing Cart Feature

```bash
# Step 1: Understand requirements
docs/project/features/cart/prd.md        # What to build
docs/project/features/cart/api.md        # Backend endpoints
docs/project/business/rules.md           # Business constraints

# Step 2: Follow patterns
docs/conventions/architecture/state.md   # How to structure state
docs/conventions/architecture/http.md    # How to make API calls
docs/conventions/design_system/widgets/  # Which UI patterns to use
```

---

## Structure Overview

```
docs/
├── conventions/           # 📦 Cross-project (reusable)
│   ├── architecture/      # Architectural patterns
│   ├── design_system/     # Design implementation patterns
│   ├── packages/          # Third-party package configurations
│   ├── best_practices/    # (Future) Common patterns
│   └── workflows/         # (Future) Dev workflows
│
└── project/              # 🎯 Project-specific
    ├── business/         # Business context and rules
    ├── design/           # Brand design tokens (colors, typography, spacing)
    ├── features/         # Feature specs and requirements
    ├── infrastructure/   # Build flavors, environment variable values
    └── api.md           # Complete backend API documentation
```

---

## Quick Links

| I need to... | Go to |
|--------------|-------|
| **See hard rules & workflows** | [`/conventions/README.md`](./conventions/README.md#hard-rules-pr-blockers) |
| **Understand business context** | [`/project/business/`](./project/business/) |
| **See business rules** | [`/project/business/rules.md`](./project/business/rules.md) |
| **Check brand colors** | [`/project/design/colors.md`](./project/design/colors.md) |
| **Implement a feature** | [`/project/features/{name}/`](./project/features/) |
| **Learn auth patterns** | [`/conventions/architecture/authentication.md`](./conventions/architecture/authentication.md) |
| **State management** | [`/conventions/architecture/state.md`](./conventions/architecture/state.md) |
| **Design system patterns** | [`/conventions/design_system/`](./conventions/design_system/) |
| **All backend endpoints** | [`/project/api.md`](./project/api.md) |

---

## Maintaining This Structure

### When to update `/conventions/`
- Adding new architectural patterns
- Documenting reusable best practices
- Creating starter templates
- **Keep it generic** - no project-specific references

### When to update `/project/`
- New feature requirements
- Business rule changes
- Design system updates
- API changes from backend
- Infrastructure modifications

---

## Exporting Conventions

The `/conventions/` folder can be copied to new Flutter projects:

```bash
# Start a new project with these patterns
cp -r current_project/docs/conventions new_project/docs/conventions
```

Then create a new `/project/` folder for your new app's specific context.

---

## Code Structure Patterns

### Feature Module Structure

Every feature follows this structure:

```
feature/{domain}/
├── ui/           # Screens and widgets
├── logic/        # Controllers (AsyncNotifier/Notifier)
├── deps/         # Provider definitions
└── data/         # API client and repository
```

### Screen Naming Conventions

| Type | Naming Pattern |
|------|----------------|
| **Listing screen** | `{feature}_listing_screen.dart` |
| **Details screen** | `{feature}_details_screen.dart` |

### UI Folder Structure

#### Simple feature (no custom widgets)
```
feature/{name}/ui/
├── {name}_listing_screen.dart
└── {name}_details_screen.dart
```

#### Feature with shared widgets
```
feature/{name}/ui/
├── widget/                      # Shared widgets for this feature
│   └── {name}_card.dart
├── {name}_listing_screen.dart
└── {name}_details_screen.dart
```

#### Complex screens with own widgets
```
feature/{name}/ui/
├── {name}_details/              # Screen folder with its own structure
│   ├── section/                 # Logical content sections
│   │   └── price_section.dart
│   ├── widget/                  # Screen-specific widgets
│   │   └── image_gallery.dart
│   └── {name}_details_screen.dart
├── {name}_listing/
│   ├── widget/
│   │   └── filter_sheet.dart
│   └── {name}_listing_screen.dart
└── widget/                      # Shared across screens
    └── shared_widget.dart
```

#### When to use sub-features (nested folders)

Use nested sub-features when a flow has distinct screens with separate logic:

```
feature/auth/
├── data/              # Shared API
├── deps/              # Shared providers
├── welcome/           # Step 1
│   └── ui/
├── phone_entry/       # Step 2
│   ├── logic/
│   └── ui/
└── otp_verify/        # Step 3
    ├── logic/
    └── ui/
```

---

**For more details, see:**
- [Conventions README](./conventions/README.md)
- [Project README](./project/README.md)
