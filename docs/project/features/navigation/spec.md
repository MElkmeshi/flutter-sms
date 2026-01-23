# Technical Spec: Navigation Feature

> **Last Updated**: January 2026

---

## Overview

The navigation feature implements a shell pattern where a single scaffold contains the bottom navigation bar and switches between child screens.

---

## Architecture

### Shell Pattern

Instead of navigating between screens, we use a shell that contains all tab screens and switches visibility:

```
┌────────────────────────────────────────┐
│              AppShell                   │
├────────────────────────────────────────┤
│  IndexedStack                          │
│  ├── HomeScreen (index 0)              │
│  ├── CategoriesScreen (index 1)        │
│  ├── SellScreen (index 2)              │
│  ├── SoldItemsScreen (index 3)         │
│  └── AccountScreen (index 4)           │
├────────────────────────────────────────┤
│  NavigationBar                         │
└────────────────────────────────────────┘
```

### Why Shell Pattern?

- **State Preservation**: Screens stay alive, state preserved
- **Fast Switching**: No rebuild on tab switch
- **Simple Navigation**: No complex nested navigation
- **Memory Trade-off**: All screens in memory (acceptable for 5 tabs)

---

## File Structure

```
lib/feature/shell/
├── ui/
│   ├── app_shell.dart              # Main shell with NavigationBar
│   └── placeholder_screen.dart     # Temporary placeholder
├── logic/
│   └── navigation_controller.dart  # Selected tab state
└── deps/
    └── navigation_deps.dart        # Provider definitions

lib/feature/home/                   # Full implementation
lib/feature/categories/             # Placeholder for now
lib/feature/sell/                   # Placeholder for now
lib/feature/sold_items/             # Placeholder for now
lib/feature/account/                # Placeholder for now
```

---

## Navigation Controller

Simple state for selected tab index:

```dart
class NavigationController extends Notifier<int> {
  static final provider = NotifierProvider(NavigationController.new);

  @override
  int build() => 0; // Default to Home tab

  void selectTab(int index) {
    if (index != state && index >= 0 && index < 5) {
      state = index;
    }
  }

  void goToHome() => selectTab(0);
  void goToCategories() => selectTab(1);
  void goToSell() => selectTab(2);
  void goToSoldItems() => selectTab(3);
  void goToAccount() => selectTab(4);
}
```

---

## App Shell Implementation

```dart
@RoutePage()
class AppShellScreen extends HookConsumerWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(NavigationController.provider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomeScreen(),
          PlaceholderScreen(title: 'Categories'),
          PlaceholderScreen(title: 'Sell'),
          PlaceholderScreen(title: 'Sold Items'),
          PlaceholderScreen(title: 'Account'),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(NavigationController.provider.notifier).selectTab(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(LucideIcons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.layoutGrid),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.plusCircle),
            label: 'Sell',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.package),
            label: 'Sold Items',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.user),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
```

---

## Placeholder Screen

Temporary screen for unimplemented tabs:

```dart
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.construction,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              '$title',
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Routing

### Route Definition

```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Splash & Onboarding
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),
    
    // Auth
    AutoRoute(page: WelcomeRoute.page),
    AutoRoute(page: PhoneEntryRoute.page),
    AutoRoute(page: OtpVerifyRoute.page),
    
    // Main App Shell (contains bottom nav)
    AutoRoute(page: AppShellRoute.page),
    
    // Detail screens (no bottom nav)
    AutoRoute(page: ProductDetailRoute.page),
    AutoRoute(page: NotificationsRoute.page),
    // ... more detail screens
  ];
}
```

### Navigation Flow

```
Splash → Onboarding → Welcome → [Auth Flow] → AppShell
                                                  │
                                                  ├── Home
                                                  ├── Categories
                                                  ├── Sell
                                                  ├── Sold Items
                                                  └── Account
```

---

## Handling Navigation from Tabs

When navigating from a tab to a detail screen:

```dart
// In HomeScreen
onTap: () => context.router.push(ProductDetailRoute(id: product.id)),
```

The AppShell remains in the stack, so back navigation returns to the tab.

---

## Analytics Events

| Event | When | Properties |
|-------|------|------------|
| `tab_switched` | Tab selected | `tab_index`, `tab_name` |
| `tab_double_tapped` | Same tab tapped twice | `tab_name` |

---

## Checklist

- [ ] NavigationController with static provider
- [ ] AppShellScreen with IndexedStack
- [ ] NavigationBar with 5 destinations
- [ ] PlaceholderScreen for pending tabs
- [ ] HomeScreen integrated
- [ ] Route registered in AppRouter
- [ ] Post-auth navigation goes to AppShell
- [ ] Lucide icons for all tabs
- [ ] Localization keys for labels
- [ ] Analytics events

---

## References

- [Navigation PRD](./prd.md) — Product requirements
- [Home PRD](/docs/features/home/prd.md) — Home screen requirements
- [Agent Guidelines](/agent.md) — Architecture and coding standards
- [Material 3 NavigationBar](https://m3.material.io/components/navigation-bar)


