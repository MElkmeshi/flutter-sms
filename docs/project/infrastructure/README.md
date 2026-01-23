# Nazaka - Infrastructure Configuration

> **Nazaka-specific infrastructure values**

This folder contains **ONLY configuration values** for Nazaka's infrastructure setup. For implementation patterns and guidelines, see `/docs/conventions/`.

---

## What's Here

| File | Contains |
|------|----------|
| **flavors.md** | Build flavor names, bundle IDs, environment variable values |

---

## Philosophy

These files answer **"WHAT"** (values), not **"HOW"** (implementation).

### ✅ What Belongs Here
- Flavor names (`Nazaka Dev`, `Nazaka`)
- Bundle IDs (`ly.ethaq.nazaka.dev`)
- API endpoints (`https://api.nazaka.ly`)
- Environment variable values
- Firebase project IDs

### ❌ What Doesn't Belong Here
- How to setup flavors (that's in conventions)
- How to use environment variables
- Implementation code examples
- Theme setup patterns

---

## Example Split

### `/project/infrastructure/flavors.md` (This Folder)
```markdown
| Flavor | App Name | Bundle ID |
|--------|----------|-----------|
| dev | Nazaka Dev | ly.ethaq.nazaka.dev |
```

### `/conventions/packages/flavorizr.md` (Patterns)
```dart
// How to use environment variables
final apiUrl = Env.apiBaseUrl;
```

---

## Related Documentation

- Flavor setup patterns: `/docs/conventions/packages/flavorizr.md`
- App initialization: `/docs/conventions/architecture/initializer.md`
- Material 3 theming: `/docs/conventions/architecture/theming.md`
