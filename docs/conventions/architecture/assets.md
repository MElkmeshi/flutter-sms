# Assets

> spider configuration and typed asset generation.

---

## Configuration

```yaml
# spider.yaml
generate_tests: false
export: true
package: your_app

groups:
  - path: assets/images
    class_name: Images
    types: [.png, .jpg, .jpeg, .webp, .svg]

  - path: assets/icons
    class_name: Icons
    types: [.svg]

  - path: assets/animations
    class_name: Animations
    types: [.json]  # Lottie
```

---

## Usage

```dart
// ✅ Always use generated references
Image.asset(Images.logoLight)
SvgPicture.asset(Icons.arrowRight)
Lottie.asset(Animations.loading)

// ❌ Never use raw paths
Image.asset('assets/images/logo_light.png') // WRONG
```

---

## Code Generation

After adding or modifying assets:

```bash
dart run spider build
```

---

## PR Blockers

- [ ] No raw asset paths — use generated references only
