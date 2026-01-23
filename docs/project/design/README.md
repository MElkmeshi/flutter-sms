# Nazaka - Design Tokens

> **Nazaka's brand identity - color values, font choices, and spacing scale**

This folder contains **ONLY the actual values** for Nazaka's design tokens. For implementation patterns and usage guidelines, see `/docs/conventions/design_system/`.

---

## What's Here

### Pure Value Tables

Each file contains a simple table of values:

| File | Contains |
|------|----------|
| **colors.md** | Brand color palette (hex codes, light/dark theme values) |
| **typography.md** | Font family choices and typography scale (sizes, weights) |
| **spacing.md** | Spacing token values, border radii, elevation levels |

---

## Philosophy

These files answer **"WHAT"** (values), not **"HOW"** (implementation).

### ✅ What Belongs Here
- Brand color hex codes (`#924DBF`)
- Font family names (`Roboto`, `Almarai`)
- Spacing scale values (`4dp`, `8dp`, `16dp`)
- Typography sizes and weights
- Border radius values

### ❌ What Doesn't Belong Here
- Implementation code
- Usage examples
- How to access colors in widgets
- Theme setup instructions

---

## Example Split

### `/project/design/colors.md` (This Folder)
```markdown
| Role | Hex | Description |
|------|-----|-------------|
| Primary | #924DBF | Main brand color |
| Surface | #FFFFFF | Card backgrounds |
```

### `/conventions/design_system/colors.md` (Patterns)
```dart
// How to use these colors
Container(
  color: Theme.of(context).colorScheme.primary,  // Uses #924DBF
)
```

---

## For AI Agents

When implementing features:
1. **Read this folder** → Get the actual color/font/spacing values
2. **Read conventions** → Learn how to use those values in code
3. **Combine both** → Implement with correct values + correct patterns

---

## Updating Values

When updating design tokens:
- ✅ Update the value tables in this folder
- ✅ Values automatically apply via theme system
- ❌ Don't update implementation patterns (those are in conventions)

---

## Related Documentation

- Implementation patterns: `/docs/conventions/design_system/`
- Widget wrappers: `/docs/conventions/design_system/widgets/`
