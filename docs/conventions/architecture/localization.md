# Localization

> slang configuration and translation patterns.

---

## Why Localization is Mandatory

> ⚠️ **CRITICAL** — **ALL user-facing strings MUST be localized using slang. NO EXCEPTIONS.**

- **Multi-language support** — Arabic and English from day one
- **Compile-time safety** — Missing translations are caught at build time
- **Consistency** — All strings in one place for easy review
- **Future-proof** — Adding new languages requires no code changes

---

## File Location

Translation files are in `lib/i18n/`:
- `strings_en.i18n.json` — English (base locale)
- `strings_ar.i18n.json` — Arabic
- `strings.g.dart` — Generated (never edit)

---

## String File Structure

```json
// lib/i18n/strings_en.i18n.json
{
  "common": {
    "loading": "Loading...",
    "error": "Something went wrong",
    "retry": "Retry",
    "cancel": "Cancel",
    "confirm": "Confirm"
  },
  "nav": {
    "home": "Home",
    "categories": "Categories",
    "account": "Account"
  },
  "auth": {
    "phoneEntry": {
      "title": "Enter Phone Number",
      "heading": "What's your phone number?",
      "description": "We'll send you a verification code.",
      "label": "Phone Number",
      "hint": "0910000000"
    }
  },
  "products": {
    "title": "Products",
    "productsFound": "${count} products found",
    "addToCart": "Add to Cart"
  }
}
```

---

## Usage

```dart
// Import the generated file
import 'package:your_app/i18n/strings.g.dart';

// In widget — use context.t extension
Text(context.t.auth.phoneEntry.title)
Text(context.t.products.soldOut)

// With parameters (define in JSON with ${param})
Text(context.t.products.productsFound(count: 42))

// Store reference for cleaner code
final tr = context.t;
Text(tr.common.loading)
Text(tr.nav.home)
```

---

## Non-Negotiable Rules

```dart
// ✅ ALWAYS — Use translations for ALL user-facing text
Text(context.t.common.loading)
AppBar(title: Text(context.t.products.title))
FilledButton(child: Text(context.t.common.confirm))
TextField(decoration: InputDecoration(labelText: context.t.auth.phoneEntry.label))
SnackBar(content: Text(context.t.common.error))

// ❌ NEVER — Hardcoded strings (AUTOMATIC PR REJECTION)
Text('Loading...')  // WRONG
AppBar(title: Text('Products'))  // WRONG
FilledButton(child: Text('Confirm'))  // WRONG
```

---

## What MUST Be Localized

| Category | Examples |
|----------|----------|
| **AppBar titles** | All screen titles |
| **Button labels** | Submit, Cancel, Retry, Continue, etc. |
| **Form labels** | Input labels, hints, placeholders |
| **Error messages** | Network errors, validation errors |
| **Empty states** | "No items", "No results found" |
| **Loading states** | "Loading...", "Please wait" |
| **Dialog content** | Titles, messages, actions |
| **Navigation labels** | Bottom nav, drawer items |
| **Snackbar messages** | Success, error, info messages |

---

## What Can Be Hardcoded (Exceptions)

| Category | Reason |
|----------|--------|
| **Brand names** | "YourBrand" — proper nouns don't translate |
| **Technical identifiers** | Debug logs, error codes |
| **Format strings** | Currency symbols used with values |
| **Asset paths** | File paths, URLs |

---

## Adding New Translations

1. Add keys to `lib/i18n/strings_en.i18n.json`
2. Add Arabic translations to `lib/i18n/strings_ar.i18n.json`
3. Run code generation: `dart run slang`
4. Use in code: `context.t.your.new.key`

---

## Key Naming Rules

- Hierarchy matches feature structure: `feature.subfeature.element`
- camelCase for keys
- No abbreviations: `submitButton` not `submitBtn`
- Use meaningful names: `productsFound` not `text1`
- Avoid Dart reserved words: use `continueBtn` not `continue`

---

## Parameterized Strings

```json
{
  "products": {
    "productsFound": "${count} products found",
    "itemsInCart": "You have ${count} items in your cart",
    "greeting": "Hello, ${name}!"
  }
}
```

```dart
// Usage
Text(context.t.products.productsFound(count: 42))
Text(context.t.products.greeting(name: user.name))
```

---

## PR Blockers

- [ ] Any hardcoded user-facing string (`Text('...')`)
- [ ] Missing Arabic translation for new keys
- [ ] Button labels, titles, or error messages not using `context.t`
- [ ] Form field labels or hints not localized
