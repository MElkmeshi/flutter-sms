# XScaffold

> Consistent page structure wrapper with edge-to-edge support.

---

## Purpose

`XScaffold` wraps Flutter's `Scaffold` to:

- Ensure consistent background color from theme
- Handle safe area padding consistently
- Provide common page structure patterns
- **Enable edge-to-edge with proper system navigation bar handling** (design system rule)

---

## Source File

`lib/ui/widget/x_scaffold.dart`

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `body` | `Widget` | required | Page content |
| `appBar` | `PreferredSizeWidget?` | `null` | App bar widget (use XAppBar) |
| `bottomNavigationBar` | `Widget?` | `null` | Bottom navigation |
| `floatingActionButton` | `Widget?` | `null` | FAB (use XFab) |
| `floatingActionButtonLocation` | `FloatingActionButtonLocation?` | `null` | FAB position |
| `backgroundColor` | `Color?` | `colorScheme.surface` | Override background (prefer theme) |
| `useSafeArea` | `bool` | `false` | Apply SafeArea to body |
| `padding` | `EdgeInsetsGeometry?` | `null` | Body padding |
| `drawer` | `Widget?` | `null` | Left drawer widget |
| `endDrawer` | `Widget?` | `null` | Right drawer widget |
| `resizeToAvoidBottomInset` | `bool` | `true` | Resize body when keyboard appears |
| `extendBody` | `bool` | `false` | Body extends behind bottom navigation |
| `extendBodyBehindAppBar` | `bool` | `false` | Body extends behind app bar |

---

## Usage Examples

### Basic Usage

```dart
XScaffold(
  appBar: XAppBar(title: Text(context.t.screen.title)),
  body: Column(
    children: [
      // content
    ],
  ),
)
```

### With Safe Area and Padding

```dart
XScaffold(
  useSafeArea: true,
  padding: EdgeInsets.all(context.spacing.md),
  body: content,
)
```

### With Bottom Navigation

```dart
XScaffold(
  body: pages[currentIndex],
  bottomNavigationBar: NavigationBar(
    selectedIndex: currentIndex,
    onDestinationSelected: onChanged,
    destinations: destinations,
  ),
)
```

### With FAB

```dart
XScaffold(
  appBar: XAppBar(title: Text(context.t.addresses.title)),
  floatingActionButton: XFab(
    onPressed: () => navigateToAdd(),
    tooltip: context.t.addresses.add,
    child: XIcon(LucideIcons.plus),
  ),
  body: content,
)
```

### With Centered FAB

```dart
XScaffold(
  appBar: XAppBar(title: Text(context.t.products.title)),
  floatingActionButton: XFab.extended(
    onPressed: () => addToCart(),
    label: Text(context.t.cart.showCart),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  body: content,
)
```

### With Drawer

```dart
XScaffold(
  appBar: XAppBar(
    leading: IconButton(
      icon: const XIcon(LucideIcons.menu),
      onPressed: () => Scaffold.of(context).openDrawer(),
    ),
    title: Text(context.t.home.title),
  ),
  drawer: Drawer(
    child: drawerContent,
  ),
  body: content,
)
```

---

## Edge-to-Edge (Design System Rule)

`XScaffold` automatically handles system navigation bar styling for edge-to-edge display. This works together with `XAppBar` to provide a complete edge-to-edge experience.

### How It Works

1. **Automatic**: No configuration needed - just use `XScaffold`
2. **Smart Nav Bar Color**: Matches scaffold background or bottom navigation bar
3. **Icon Brightness**: Automatically computed based on background luminance
   - Light background -> dark icons
   - Dark background -> light icons

### Navigation Bar Color Logic

- **With bottom navigation**: Uses `NavigationBarTheme.backgroundColor`
- **Without bottom navigation**: Uses scaffold `backgroundColor`

This ensures the system navigation bar seamlessly blends with your UI.

### Platform Notes

- **Android**: System navigation bar color and icon brightness are set
- **iOS**: Home indicator area handled by SafeArea when needed

---

## Do/Don't

```dart
// DO - Use XScaffold with XAppBar
XScaffold(
  appBar: XAppBar(title: Text(context.t.home.title)),
  body: content,
)

// DO - Use XFab for floating action buttons
XScaffold(
  floatingActionButton: XFab(
    onPressed: onAdd,
    child: XIcon(LucideIcons.plus),
  ),
  body: content,
)

// DON'T - Use raw Scaffold with hardcoded background
Scaffold(
  backgroundColor: Colors.white,  // WRONG - use theme
  body: content,
)

// DON'T - Use raw AppBar
XScaffold(
  appBar: AppBar(title: Text('Title')),  // WRONG - use XAppBar
  body: content,
)

// DON'T - Use raw FloatingActionButton
XScaffold(
  floatingActionButton: FloatingActionButton(  // WRONG - use XFab
    onPressed: onAdd,
    child: Icon(Icons.add),
  ),
  body: content,
)
```

---

## Implementation

See `lib/ui/widget/x_scaffold.dart` for the full implementation.

Key features:
- Uses `colorScheme.surface` as default background
- Wraps content with `SafeArea` when `useSafeArea` is true
- Applies `AnnotatedRegion<SystemUiOverlayStyle>` for system navigation bar
- Computes icon brightness based on background luminance
