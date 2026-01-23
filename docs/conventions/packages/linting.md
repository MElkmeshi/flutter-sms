# Linting & Code Analysis

> **Package**: [`very_good_analysis`](https://pub.dev/packages/very_good_analysis) ^10.0.0
> 
> Strict, production-grade lint rules from Very Good Ventures.

---

## Overview

We use `very_good_analysis` as our base lint ruleset. It provides:

- **200+ lint rules** enabled by default
- **Production-grade strictness** without being annoying
- **Regular updates** aligned with Dart SDK releases
- **Industry standard** used by Very Good Ventures in enterprise Flutter apps

### Why very_good_analysis?

| Package | Rules Enabled | Strictness | Maintenance |
|---------|---------------|------------|-------------|
| `flutter_lints` (default) | ~30 | Low | Google |
| `lint` | ~100 | Medium-High | Community |
| `very_good_analysis` | ~200+ | High | Very Good Ventures |

We chose `very_good_analysis` for maximum code quality without false positives.

---

## Installation

Already configured in this project. For reference:

```yaml
# pubspec.yaml
dev_dependencies:
  very_good_analysis: ^10.0.0
```

```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml
```

---

## Configuration

Our `analysis_options.yaml` extends `very_good_analysis` with project-specific rules.

### Excluded Files

Generated files are excluded from analysis:

```yaml
analyzer:
  exclude:
    - "**/*.g.dart"           # json_serializable
    - "**/*.gr.dart"          # auto_route
    - "**/*.freezed.dart"     # freezed (if ever used)
    - "**/*.config.dart"      # injectable
    - "**/generated/**"       # other generated
    - "build/**"              # build outputs
```

### Strict Mode

We enable Dart's strict mode for maximum type safety:

```yaml
analyzer:
  language:
    strict-casts: true        # No implicit casts
    strict-inference: true    # No implicit dynamic
    strict-raw-types: true    # No raw generic types
```

### Key Rules

| Rule | Setting | Reason |
|------|---------|--------|
| `always_use_package_imports` | enabled | Consistent imports |
| `prefer_single_quotes` | enabled | Consistency |
| `prefer_const_constructors` | enabled | Performance |
| `prefer_final_locals` | enabled | Immutability |
| `require_trailing_commas` | enabled | Better git diffs |
| `sort_constructors_first` | enabled | Readability |
| `avoid_print` | enabled | Use proper logging |
| `public_member_api_docs` | **disabled** | Enable when API stabilizes |

---

## Running Analysis

### IDE Integration

Analysis runs automatically in VS Code and Android Studio with Dart/Flutter extensions.

### Command Line

```bash
# Run analyzer
flutter analyze

# Run with specific rules (all issues)
dart analyze --fatal-infos --fatal-warnings

# Auto-fix issues
dart fix --apply
```

### CI/CD

Add to your CI pipeline:

```yaml
# GitHub Actions example
- name: Analyze
  run: flutter analyze --fatal-infos
```

---

## Suppressing Lints

### Line Level

```dart
// ignore: avoid_print
print('Debug message');
```

### File Level

```dart
// ignore_for_file: public_member_api_docs

class InternalHelper {
  // No docs required
}
```

### Project Level

In `analysis_options.yaml`:

```yaml
linter:
  rules:
    some_rule: false
```

---

## Common Lint Fixes

### `require_trailing_commas`

```dart
// Before
Widget build(BuildContext context) {
  return Container(color: Colors.red, child: Text('Hello'));
}

// After
Widget build(BuildContext context) {
  return Container(
    color: Colors.red,
    child: Text('Hello'),  // Trailing comma
  );
}
```

### `prefer_const_constructors`

```dart
// Before
Container(color: Colors.red)

// After
const Container(color: Colors.red)
```

### `always_use_package_imports`

```dart
// Before
import '../../../domain/model/user.dart';

// After
import 'package:your_app/domain/model/user.dart';
```

### `prefer_final_locals`

```dart
// Before
var name = 'John';  // Never reassigned

// After
final name = 'John';
```

### `avoid_dynamic_calls`

```dart
// Before
dynamic data = getData();
data.someMethod();  // Unsafe

// After
final Map<String, dynamic> data = getData();
if (data['key'] is String) {
  final value = data['key'] as String;
}
```

---

## PR Blockers

These lint violations **block PRs**:

- [ ] Any `error` level issues
- [ ] `avoid_print` violations (use logging)
- [ ] `prefer_const_constructors` where applicable
- [ ] `always_use_package_imports` violations
- [ ] `avoid_dynamic_calls` without proper type handling
- [ ] Missing trailing commas in multi-line constructs

---

## Related Documentation

- [Very Good Analysis Changelog](https://pub.dev/packages/very_good_analysis/changelog)
- [Dart Linter Rules](https://dart.dev/tools/linter-rules)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

---

## Alternatives Considered

### `lint` package

[`lint`](https://pub.dev/packages/lint) by Pascal Welsch is another excellent option:

- **Pros**: Multiple strictness levels (strict, casual, package)
- **Cons**: Slightly fewer rules than very_good_analysis

Use `lint/strict.yaml` if you prefer:

```yaml
include: package:lint/strict.yaml
```

### Custom Ruleset

For maximum control, you can define all rules manually:

```yaml
# Not recommended - high maintenance burden
linter:
  rules:
    rule_one: true
    rule_two: true
    # ... 200+ rules
```

We recommend sticking with `very_good_analysis` for consistency and lower maintenance.
