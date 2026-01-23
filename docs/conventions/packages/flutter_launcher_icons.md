# Flutter Launcher Icons

> **Package**: `flutter_launcher_icons` ^0.14.3
> **Docs**: [pub.dev/packages/flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

---

## Overview

We use `flutter_launcher_icons` to generate app launcher icons for all platforms from a single source image. This package handles:

- Adaptive icons for Android 8.0+ (API 26+)
- Legacy icons for older Android versions
- iOS icons for all device sizes
- Automatic resizing and optimization

---

## File Structure

```
project/
├── assets/
│   └── launcher_icon/
│       ├── icon.png                      # 1024x1024 — Main icon
│       ├── icon_adaptive_foreground.png  # 1024x1024 — Android foreground
│       └── icon_adaptive_background.png  # 1024x1024 — Android background
└── flutter_launcher_icons.yaml           # Configuration file
```

---

## Configuration

See `flutter_launcher_icons.yaml` in project root.

```yaml
flutter_launcher_icons:
  # Android
  android: true
  image_path: "assets/launcher_icon/icon.png"
  adaptive_icon_foreground: "assets/launcher_icon/icon_adaptive_foreground.png"
  adaptive_icon_background: "assets/launcher_icon/icon_adaptive_background.png"

  # iOS
  ios: true
  image_path_ios: "assets/launcher_icon/icon.png"
  remove_alpha_ios: true
```

---

## Commands

### Generate Icons

```bash
# Generate all icons
dart run flutter_launcher_icons

# Generate with specific config file (for flavors)
dart run flutter_launcher_icons -f flutter_launcher_icons-dev.yaml
```

---

## Creating Source Assets

### Requirements

| Asset | Size | Transparency | Purpose |
|-------|------|--------------|---------|
| `icon.png` | 1024x1024 | No alpha | iOS + legacy Android |
| `icon_adaptive_foreground.png` | 1024x1024 | Transparent bg | Android foreground layer |
| `icon_adaptive_background.png` | 1024x1024 | No alpha | Android background layer |

### Adaptive Icon Safe Zone

Android launchers apply different masks (circle, squircle, rounded square). Keep your logo within the **safe zone**:

```
┌────────────────────────────────────┐
│           176px padding            │
│  ┌────────────────────────────┐   │
│  │                            │   │
│  │      SAFE ZONE             │   │
│  │      672 x 672px           │   │
│  │                            │   │
│  │    (place logo here)       │   │
│  │                            │   │
│  └────────────────────────────┘   │
│           176px padding            │
└────────────────────────────────────┘
        Total: 1024 x 1024px
```

- **Full canvas**: 1024x1024px
- **Safe zone**: Center 672x672px (66%)
- **Padding**: 176px from each edge

### Design Tips

1. **Foreground**: Export logo with transparent background, centered in safe zone
2. **Background**: Can be solid color (hex in config) or image with gradient/pattern
3. **icon.png**: Composite of foreground + background (for legacy Android & iOS)
4. **iOS requirement**: No transparency — use solid background

---

## Generated Files

### Android

```
android/app/src/main/res/
├── mipmap-anydpi-v26/
│   ├── ic_launcher.xml          # Adaptive icon definition
│   └── ic_launcher_round.xml    # Round adaptive icon
├── mipmap-{hdpi,mdpi,xhdpi,xxhdpi,xxxhdpi}/
│   ├── ic_launcher.png          # Legacy icon
│   ├── ic_launcher_foreground.png
│   └── ic_launcher_round.png
└── values/
    └── ic_launcher_background.xml  # If using background color
```

### iOS

```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
├── Contents.json
├── Icon-App-20x20@1x.png through @3x.png
├── Icon-App-29x29@1x.png through @3x.png
├── Icon-App-40x40@1x.png through @3x.png
├── Icon-App-60x60@2x.png and @3x.png
├── Icon-App-76x76@1x.png and @2x.png
├── Icon-App-83.5x83.5@2x.png
└── Icon-App-1024x1024@1x.png
```

---

## Usage Patterns

### Single Icon Set (Current)

```yaml
# flutter_launcher_icons.yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/launcher_icon/icon.png"
  adaptive_icon_foreground: "assets/launcher_icon/icon_adaptive_foreground.png"
  adaptive_icon_background: "#FFFFFF"
  remove_alpha_ios: true
```

### Per-Flavor Icons

Create separate config files for each flavor:

```
flutter_launcher_icons-dev.yaml
flutter_launcher_icons-prod.yaml
```

**flutter_launcher_icons-dev.yaml:**
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/launcher_icon/icon_dev.png"
  adaptive_icon_foreground: "assets/launcher_icon/icon_adaptive_foreground_dev.png"
  adaptive_icon_background: "#FF9800"  # Orange tint for dev
  remove_alpha_ios: true
```

Run each flavor:
```bash
dart run flutter_launcher_icons -f flutter_launcher_icons-dev.yaml
dart run flutter_launcher_icons -f flutter_launcher_icons-prod.yaml
```

---

## Common Gotchas

### 1. iOS Alpha Channel Error

iOS App Store rejects icons with transparency:

```yaml
# ✅ CORRECT — Remove alpha
remove_alpha_ios: true

# ❌ WRONG — Alpha causes App Store rejection
remove_alpha_ios: false
```

### 2. Adaptive Icon Cropping

Foreground may be cropped by different launcher masks:

```
# ❌ WRONG — Logo at edges
Logo fills 100% of 1024x1024 canvas

# ✅ CORRECT — Logo in safe zone
Logo within center 672x672px (66%)
```

### 3. Background Color Format

```yaml
# ✅ CORRECT — Hex with hash
adaptive_icon_background: "#FFFFFF"

# ❌ WRONG — Missing hash
adaptive_icon_background: "FFFFFF"
```

### 4. Running After Asset Changes

Always regenerate after changing source images:

```bash
dart run flutter_launcher_icons
```

### 5. Missing Source Files

Ensure all referenced files exist before running:

```bash
ls assets/launcher_icon/
# Expected: icon.png, icon_adaptive_foreground.png, icon_adaptive_background.png
```

---

## PR Blockers

- [ ] Source icon is not 1024x1024px
- [ ] Adaptive foreground logo extends beyond safe zone (66%)
- [ ] iOS icon has transparency (`remove_alpha_ios: false`)
- [ ] Generated icons not committed after source changes
- [ ] `flutter_launcher_icons.yaml` missing from project root

---

## References

- [flutter_launcher_icons on pub.dev](https://pub.dev/packages/flutter_launcher_icons)
- [Android Adaptive Icons Guide](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive)
- [iOS App Icon Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons)
