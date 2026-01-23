# XAppBar

> Consistent app bar wrapper with Material 3 styling.

---

## Purpose

`XAppBar` wraps Flutter's `AppBar` to:

- Ensure consistent Material 3 styling
- Automatically use `XIcon` for back button
- Set `surfaceTintColor` to transparent by default
- Provide theme-compliant colors
- **Enable edge-to-edge with transparent system bars** (design system rule)

---

## Source File

`lib/ui/widget/x_app_bar.dart`

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `title` | `Widget?` | `null` | Primary widget in app bar |
| `leading` | `Widget?` | `null` | Widget before title (auto back button if null) |
| `actions` | `List<Widget>?` | `null` | Widgets after title |
| `automaticallyImplyLeading` | `bool` | `true` | Show back button when navigable |
| `centerTitle` | `bool?` | `null` | Center the title |
| `backgroundColor` | `Color?` | `colorScheme.surface` | Background color |
| `foregroundColor` | `Color?` | `colorScheme.onSurface` | Title/icon color |
| `elevation` | `double?` | `0` | Shadow elevation |
| `scrolledUnderElevation` | `double?` | `0` | Elevation when scrolled |
| `bottom` | `PreferredSizeWidget?` | `null` | Widget below app bar (tabs) |
| `titleSpacing` | `double?` | `null` | Spacing around title |
| `toolbarHeight` | `double?` | `kToolbarHeight` | Height of toolbar |
| `leadingWidth` | `double?` | `null` | Width of leading widget |

---

## Usage Examples

### Basic Title Only

```dart
XScaffold(
  appBar: XAppBar(title: Text(context.t.home.title)),
  body: content,
)
```

### With Actions

```dart
XScaffold(
  appBar: XAppBar(
    title: Text(context.t.profile.title),
    actions: [
      IconButton(
        icon: const XIcon(LucideIcons.settings),
        onPressed: () => context.pushRoute(const SettingsRoute()),
      ),
      IconButton(
        icon: const XIcon(LucideIcons.bell),
        onPressed: () => context.pushRoute(const NotificationsRoute()),
      ),
    ],
  ),
  body: content,
)
```

### With Custom Leading

```dart
XScaffold(
  appBar: XAppBar(
    leading: IconButton(
      icon: const XIcon(LucideIcons.x),
      onPressed: () => Navigator.pop(context),
    ),
    title: Text(context.t.modal.title),
  ),
  body: content,
)
```

### Without Back Button (Root Screen)

```dart
XScaffold(
  appBar: XAppBar(
    automaticallyImplyLeading: false,
    title: Text(context.t.home.title),
  ),
  body: content,
)
```

### With Bottom Tabs

```dart
XScaffold(
  appBar: XAppBar(
    title: Text(context.t.orders.title),
    bottom: TabBar(
      tabs: [
        Tab(text: context.t.orders.pending),
        Tab(text: context.t.orders.completed),
      ],
    ),
  ),
  body: TabBarView(...),
)
```

### Empty App Bar (Detail Screen)

```dart
XScaffold(
  appBar: const XAppBar(),
  body: content,
)
```

---

## Do/Don't

```dart
// ✅ DO — Use XAppBar
XScaffold(
  appBar: XAppBar(title: Text(context.t.home.title)),
  body: content,
)

// ✅ DO — Use XAppBar with actions
XScaffold(
  appBar: XAppBar(
    title: Text(context.t.settings.title),
    actions: [
      IconButton(
        icon: const XIcon(LucideIcons.search),
        onPressed: onSearch,
      ),
    ],
  ),
  body: content,
)

// ❌ DON'T — Use raw AppBar
XScaffold(
  appBar: AppBar(
    title: Text('Settings'),  // Also wrong - hardcoded string
    backgroundColor: Colors.white,  // Wrong - hardcoded color
  ),
  body: content,
)

// ❌ DON'T — Use Icon instead of XIcon for leading
XScaffold(
  appBar: XAppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back),  // Wrong - use XIcon
      onPressed: () => Navigator.pop(context),
    ),
  ),
  body: content,
)
```

---

## Automatic Back Button

`XAppBar` automatically shows a back button using `XIcon(LucideIcons.arrowLeft)` when:

1. `leading` is `null`
2. `automaticallyImplyLeading` is `true` (default)
3. There's a previous route to go back to

This ensures consistent back button styling across the app without manual setup.

---

## Edge-to-Edge (Design System Rule)

`XAppBar` automatically enables edge-to-edge display on Android. This is a **design system rule** that follows modern Android UI guidelines.

### How It Works

1. **Automatic**: No configuration needed - just use `XAppBar`
2. **Transparent System Bars**: Both status bar and navigation bar are transparent
3. **Content Behind Bars**: App content extends behind system bars
4. **Icon Brightness**: Automatically computed based on background luminance
   - Light background → dark icons
   - Dark background → light icons

### Why Edge-to-Edge

- Required by default on Android 15+
- Creates immersive, modern UI experience
- App content uses full screen real estate
- Follows official Android design guidelines

### Handling Insets

For screens where content shouldn't go behind the navigation bar:

```dart
// Use SafeArea via XScaffold
XScaffold(
  appBar: XAppBar(title: Text(context.t.title)),
  useSafeArea: true,  // Adds SafeArea to body
  body: content,
)
```

Scrollable content (ListView, GridView) automatically handles bottom insets.

### Platform Notes

- **Android**: Full edge-to-edge with transparent system bars
- **iOS**: Status bar is transparent; home indicator area handled by SafeArea

---

## Implementation

See `lib/ui/widget/x_app_bar.dart` for the full implementation.

Key features:
- Uses `colorScheme.surface` as default background
- Computes `SystemUiOverlayStyle` with matching navigation bar color
- Determines icon brightness based on background luminance
