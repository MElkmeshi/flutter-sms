# Package Specs

> **Purpose**: Document third-party package configurations, usage patterns, and project-specific conventions.

## Structure

Create a markdown file for each significant package that needs project-specific documentation:

```
docs/packages/
├── README.md          # This file
├── dio.md             # HTTP client specs
├── flavorizr.md       # Flavors & environment configuration
├── riverpod.md        # State management patterns
├── auto_route.md      # Routing conventions
└── ...
```

## When to Document a Package

Create specs for packages that have:
- Project-specific configuration
- Custom usage patterns
- Interceptors or middleware
- Gotchas or common mistakes
- Team conventions beyond default usage

## Template

Use this template for new package specs:

```markdown
# [Package Name] Specs

> **Package**: `package_name`
> **Version**: x.y.z
> **Docs**: [Link to official docs]

## Overview

Brief description of what this package does and why we use it.

## Configuration

How we configure this package in our project.

## Usage Patterns

Project-specific patterns and conventions.

## Common Gotchas

Known issues or mistakes to avoid.

## Examples

Code examples specific to our project.
```

---

*This documentation is designed for both human developers and AI agents.*

