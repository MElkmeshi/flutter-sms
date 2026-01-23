# Nazaka - Flavors & Environment Variables

> Nazaka's build flavors and environment configuration values.

---

## Build Flavors

| Flavor | App Name | Bundle ID | Target |
|--------|----------|-----------|--------|
| `dev` | **Nazaka Dev** | `ly.ethaq.nazaka.dev` | Development/Testing |
| `prod` | **Nazaka** | `ly.ethaq.nazaka` | Production/App Stores |

---

## Environment Variables

### Development (`env/dev.env`)

| Variable | Value | Description |
|----------|-------|-------------|
| `FLAVOR` | `dev` | Development flavor |
| `API_BASE_URL` | `https://nazaka-dev.ethaq.ly` | Dev API endpoint |
| `SENTRY_DSN` | (empty) | Disabled in dev |
| `SENTRY_ENVIRONMENT` | `development` | Sentry environment name |
| `ANALYTICS_ENABLED` | `false` | Analytics disabled in dev |

### Production (`env/prod.env`)

| Variable | Value | Description |
|----------|-------|-------------|
| `FLAVOR` | `prod` | Production flavor |
| `API_BASE_URL` | `https://api.nazaka.ly` | Production API endpoint |
| `SENTRY_DSN` | `https://xxx@sentry.io/xxx` | Production Sentry DSN (from CI secrets) |
| `SENTRY_ENVIRONMENT` | `production` | Sentry environment name |
| `ANALYTICS_ENABLED` | `true` | Analytics enabled in prod |

---

## Firebase Projects (Future)

When Firebase is integrated:

| Flavor | Project ID | Usage |
|--------|-----------|--------|
| `dev` | `nazaka-dev` | Development/Testing |
| `prod` | `nazaka-prod` | Production |

---

## Implementation Reference

See `/docs/conventions/packages/flavorizr.md` for:
- How to setup flavors with flutter_flavorizr
- How to use environment variables via `Env` class
- Run/build commands
- Best practices and patterns
