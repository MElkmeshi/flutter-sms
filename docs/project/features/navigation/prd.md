# PRD: Navigation Feature (Bottom Navigation Bar)

> **Status**: Draft  
> **Last Updated**: January 2026  
> **Owner**: TBD

---

## Goal

Provide intuitive bottom navigation for accessing the app's main sections, following Material 3 design guidelines.

---

## Non-goals

- Tab-specific functionality (handled by individual features)
- Deep linking (separate concern)
- Navigation history management (handled by router)

---

## User Stories

- [ ] **US-NAV-001**: As a user, I want to switch between main sections easily.
- [ ] **US-NAV-002**: As a user, I want to see which section I'm currently in.
- [ ] **US-NAV-003**: As a user, I want to quickly access the sell feature.

---

## Navigation Tabs

### Tab 1: Home

| Property | Value |
|----------|-------|
| Label | "Home" |
| Icon (unselected) | `home` outline |
| Icon (selected) | `home` filled |
| Screen | HomeScreen (Product Listing) |
| Status | 📋 PRD Ready |

---

### Tab 2: Categories

| Property | Value |
|----------|-------|
| Label | "Categories" |
| Icon (unselected) | `grid-2x2` outline |
| Icon (selected) | `grid-2x2` filled |
| Screen | CategoriesScreen |
| Status | ⏸️ **Pending** — Leave blank for now |

**Placeholder:**
```dart
Scaffold(
  body: Center(
    child: Text('Categories - Coming Soon'),
  ),
)
```

---

### Tab 3: Sell

| Property | Value |
|----------|-------|
| Label | "Sell" |
| Icon (unselected) | `plus-circle` outline |
| Icon (selected) | `plus-circle` filled |
| Screen | SellScreen (Create Listing) |
| Status | ⏸️ **Pending** — Leave blank for now |

**Note:** This is a primary action. Consider making it visually prominent (larger icon, different color, or FAB-style).

**Placeholder:**
```dart
Scaffold(
  body: Center(
    child: Text('Sell - Coming Soon'),
  ),
)
```

---

### Tab 4: Sold Items

| Property | Value |
|----------|-------|
| Label | "Sold Items" |
| Icon (unselected) | `package` outline |
| Icon (selected) | `package` filled |
| Screen | SoldItemsScreen |
| Status | ⏸️ **Pending** — Leave blank for now |

**Placeholder:**
```dart
Scaffold(
  body: Center(
    child: Text('Sold Items - Coming Soon'),
  ),
)
```

---

### Tab 5: Account

| Property | Value |
|----------|-------|
| Label | "Account" |
| Icon (unselected) | `user` outline |
| Icon (selected) | `user` filled |
| Screen | AccountScreen |
| Status | ⏸️ **Pending** — Leave blank for now |

**Placeholder:**
```dart
Scaffold(
  body: Center(
    child: Text('Account - Coming Soon'),
  ),
)
```

---

## Visual Design

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│                                                                      │
│                         SCREEN CONTENT                               │
│                                                                      │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐         │
│  │  🏠    │  │  📂    │  │  ➕    │  │  📦    │  │  👤    │         │
│  │ Home   │  │Categor.│  │  Sell  │  │  Sold  │  │Account │         │
│  │        │  │        │  │        │  │        │  │        │         │
│  └────────┘  └────────┘  └────────┘  └────────┘  └────────┘         │
│                                                                      │
│  [●]          [ ]          [ ]          [ ]          [ ]            │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### Material 3 NavigationBar

Use Flutter's `NavigationBar` widget (M3), NOT `BottomNavigationBar` (M2).

```dart
NavigationBar(
  selectedIndex: currentIndex,
  onDestinationSelected: (index) => /* handle */,
  destinations: [
    NavigationDestination(
      icon: Icon(LucideIcons.home),
      selectedIcon: Icon(LucideIcons.home, /* filled style */),
      label: 'Home',
    ),
    // ... other destinations
  ],
)
```

---

## States

| State | Description |
|-------|-------------|
| Home Selected | Home icon highlighted, Home screen visible |
| Categories Selected | Categories icon highlighted, Categories screen visible |
| Sell Selected | Sell icon highlighted, Sell screen visible |
| Sold Items Selected | Sold Items icon highlighted, Sold Items screen visible |
| Account Selected | Account icon highlighted, Account screen visible |

---

## Behavior

### Tab Switching
- Tapping a tab switches to that screen immediately
- No transition animation between tabs (instant swap)
- State is preserved when switching tabs

### State Preservation
- Each tab maintains its own navigation stack
- Scrolling position preserved when returning to tab
- Form data preserved when switching tabs

### Visibility
- Navigation bar visible on all main screens
- Hidden on detail screens, modals, full-screen flows
- Hidden during onboarding and auth flows

### Authentication
- All tabs require authentication (no guest access to nav)
- Guest users stay in welcome/limited flow

---

## Functional Requirements

### FR-001: Tab Navigation
- Display 5 navigation destinations
- Highlight currently selected tab
- Switch screens on tab tap

### FR-002: State Preservation
- Preserve tab state when switching
- Preserve scroll position
- Preserve form input (if any)

### FR-003: Deep Linking (Future)
- Support deep links to specific tabs
- Support deep links within tabs

---

## Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| Double-tap current tab | Scroll to top / reset to root |
| Back button on root of tab | Exit app (or switch to Home) |
| Notification opens while in app | Navigate to relevant tab/screen |
| Session expired | Redirect to login, preserve intended destination |

---

## Acceptance Criteria

### Navigation Bar
- [ ] Uses Material 3 `NavigationBar` (NOT `BottomNavigationBar`)
- [ ] Displays 5 tabs with icons and labels
- [ ] Currently selected tab is visually highlighted
- [ ] Tab switching is instant (no animation)

### Tabs
- [ ] Home tab shows HomeScreen
- [ ] Categories tab shows placeholder
- [ ] Sell tab shows placeholder
- [ ] Sold Items tab shows placeholder
- [ ] Account tab shows placeholder

### State
- [ ] Tab state preserved when switching
- [ ] Scroll position preserved
- [ ] Double-tap scrolls to top

### General
- [ ] Navigation bar follows Material 3 design
- [ ] Icons use Lucide icons consistently
- [ ] Labels use localization keys
- [ ] Analytics: `tab_switched` event with `tab_name`

---

## Implementation Priority

1. **Phase 1** (Now)
   - [ ] Navigation bar with 5 tabs
   - [ ] Home screen (full implementation)
   - [ ] Placeholder screens for other tabs

2. **Phase 2** (Later)
   - [ ] Categories screen
   - [ ] Account screen

3. **Phase 3** (Later)
   - [ ] Sell screen
   - [ ] Sold Items screen

---

## Open Questions

| Question | Status |
|----------|--------|
| Should Sell button be visually different (FAB-style)? | **Decision needed** |
| Should guests see navigation bar? | **No** (decided) |
| Tab order correct? | **Confirmed** |

---

## References

- [Agent Guidelines](/agent.md) — Architecture and coding standards
- [Design System](/docs/design_system.md) — Colors, typography, spacing
- [Material 3 NavigationBar](https://m3.material.io/components/navigation-bar)
- [Home PRD](/docs/features/home/prd.md) — Home screen requirements


