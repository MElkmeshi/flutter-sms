# PRD: Account Feature

> **Status**: Draft
> **Last Updated**: January 2026
> **Owner**: TBD

---

## Goal

Provide a centralized settings screen where users can manage app preferences, access legal documents, and control their authentication session.

---

## Non-goals

- User profile editing (separate feature)
- Notification preferences (future enhancement)
- Account deletion (future enhancement)
- Help & Support section (future enhancement)

---

## User Stories

- [ ] **US-ACCOUNT-001**: As a user, I want to switch between dark and light themes so I can customize the app appearance.
- [ ] **US-ACCOUNT-002**: As a user, I want to change the app language so I can use the app in my preferred language.
- [ ] **US-ACCOUNT-003**: As a user, I want to access the Privacy Policy so I can understand how my data is handled.
- [ ] **US-ACCOUNT-004**: As a user, I want to access the Terms of Service so I can understand the usage terms.
- [ ] **US-ACCOUNT-005**: As a user, I want to sign out so I can switch accounts or secure my session.

---

## Screen Layout

### App Bar

| Element | Type | Description |
|---------|------|-------------|
| Title | `Text` | "Account" |

---

### Section 1: Preferences

Settings that open bottom sheets for selection.

| Element | Type | Description |
|---------|------|-------------|
| Theme | `AccountListTile` | Opens ThemeBottomSheet |
| Language | `AccountListTile` | Opens LanguageBottomSheet |

---

### Section 2: Legal (after divider)

Settings that navigate to WebView screens.

| Element | Type | Description |
|---------|------|-------------|
| Privacy Policy | `AccountListTile` | Opens WebView with privacy policy URL |
| Terms of Service | `AccountListTile` | Opens WebView with terms URL |

---

### Section 3: Sign Out

Action button positioned below the list.

| Element | Type | Description |
|---------|------|-------------|
| Sign Out Button | `OutlinedButton` | Full-width button with error color |

---

## Shared Widget: AccountListTile

A reusable list tile component for account settings.

| Element | Type | Description |
|---------|------|-------------|
| Leading Icon | `AppIcon` | Setting icon (Lucide) |
| Title | `Text` | Setting name |
| Subtitle | `Text` (optional) | Current value (e.g., "Light", "English") |
| Trailing | `AppIcon` | Chevron right icon |

**Visual Design:**

```
+----------------------------------------------------------+
| [icon]  Title                              Subtitle    > |
+----------------------------------------------------------+
```

**Props:**
```dart
class AccountListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
}
```

---

## Shared Widget: SelectionBottomSheet

> **IMPORTANT**: This is a shared widget used across theme and language selection.

A generic bottom sheet for single-selection lists located in `lib/ui/widget/selection_bottom_sheet.dart`.

| Element | Type | Description |
|---------|------|-------------|
| Handle | `Container` | Visual drag indicator (gray bar) |
| Title | `Text` | Bottom sheet title |
| Close Button | `IconButton` | X icon to dismiss |
| Options List | `ListView` | Selectable options with radio-style indicators |

**Visual Design:**

```
+----------------------------------------------------------+
|                    [===]                                  |  <- Handle
+----------------------------------------------------------+
|  Select Theme                                       [X]  |  <- Header
+----------------------------------------------------------+
|  [o]  System                                             |
|  [*]  Light                                    [check]   |  <- Selected
|  [o]  Dark                                               |
+----------------------------------------------------------+
```

**Behavior:**
- Rounded top corners (16px radius)
- Dismisses on option selection
- Dismisses on close button tap
- Dismisses on tap outside

**Props:**
```dart
class SelectionBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T selectedValue;
  final ValueChanged<T> onSelect;
  final String Function(T) labelBuilder;
  final IconData Function(T)? iconBuilder;
}
```

---

## Theme Selection

**Options:**

| Option | Value | Icon | Description |
|--------|-------|------|-------------|
| System | `ThemeMode.system` | `monitor` | Follows device setting |
| Light | `ThemeMode.light` | `sun` | Light appearance |
| Dark | `ThemeMode.dark` | `moon` | Dark appearance |

**Behavior:**
- Selection immediately applies theme to entire app
- Selection persists to SharedPreferences
- Bottom sheet dismisses on selection
- Default: System

---

## Language Selection

**Options:**

| Option | Value | Native Name | Description |
|--------|-------|-------------|-------------|
| English | `en` | English | English language |
| Arabic | `ar` | العربية | Arabic language (RTL) |

**Behavior:**
- Selection immediately changes app locale
- Selection persists to SharedPreferences
- App UI updates without restart
- Bottom sheet dismisses on selection
- Default: English

---

## Legal Pages (WebView)

Both Privacy Policy and Terms of Service open in an in-app WebView.

**WebView Screen:**

| Element | Type | Description |
|---------|------|-------------|
| App Bar Title | `Text` | "Privacy Policy" or "Terms of Service" |
| Back Button | `IconButton` | Returns to account screen |
| WebView | `WebViewWidget` | Displays the legal document |
| Loading Indicator | `LinearProgressIndicator` | Shows while page loads |

**URLs:**
- Privacy Policy: Configured via environment variable
- Terms of Service: Configured via environment variable

**Behavior:**
- Shows loading indicator while page loads
- Handles network errors gracefully
- Back button returns to account screen

---

## Sign Out Flow

**Visual Design:**

```
+----------------------------------------------------------+
|                                                           |
|            +------------------------+                     |
|            |       Sign Out         |  <- Outlined button |
|            +------------------------+                     |
|                                                           |
+----------------------------------------------------------+
```

**Confirmation Dialog:**

```
+----------------------------------+
|           Sign Out               |
+----------------------------------+
|  Are you sure you want to        |
|  sign out?                       |
+----------------------------------+
|     [Cancel]     [Sign Out]      |
+----------------------------------+
```

**Behavior:**
1. User taps "Sign Out" button
2. Confirmation dialog appears
3. On "Cancel": Dialog dismisses
4. On "Sign Out":
   - Clear auth tokens from secure storage
   - Clear user session data
   - Invalidate relevant providers
   - Navigate to WelcomeScreen
   - Clear navigation stack (replace all)

---

## Screen States

| State | Description |
|-------|-------------|
| Default | All options visible with current selections |
| Bottom Sheet Open | Modal sheet displayed over screen |
| Dialog Open | Confirmation dialog displayed |
| Loading | WebView showing loading indicator |

---

## Functional Requirements

### FR-001: Theme Selection
- Display current theme selection in list tile subtitle
- Open bottom sheet with three theme options
- Apply theme immediately on selection
- Persist selection to local storage

### FR-002: Language Selection
- Display current language in list tile subtitle
- Open bottom sheet with language options
- Apply locale immediately on selection
- Persist selection to local storage
- Support RTL for Arabic

### FR-003: Privacy Policy
- Navigate to WebView screen on tap
- Load privacy policy URL
- Show loading indicator
- Handle errors gracefully

### FR-004: Terms of Service
- Navigate to WebView screen on tap
- Load terms URL
- Show loading indicator
- Handle errors gracefully

### FR-005: Sign Out
- Show confirmation dialog on button tap
- Clear session on confirmation
- Navigate to welcome screen
- Clear navigation stack

### FR-006: Shared Bottom Sheet
- Generic component for any selection list
- Support custom label rendering
- Support optional icons for options
- Visual indicator for selected item

---

## Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| No network (WebView) | Show error state with retry option |
| WebView load timeout | Show error message |
| Theme change while in bottom sheet | Apply immediately, sheet visible |
| Language change to RTL | UI flips direction immediately |
| Sign out fails | Show error toast, keep user logged in |

---

## Acceptance Criteria

### Account Screen
- [ ] Displays list of account options
- [ ] Theme item shows icon, title, and current theme as subtitle
- [ ] Language item shows icon, title, and current language as subtitle
- [ ] Legal items show icon and title (no subtitle)
- [ ] Divider separates preferences from legal section
- [ ] Sign out button is styled as outlined with error color
- [ ] Sign out button is full-width below the list
- [ ] All items have proper tap feedback (ripple)

### Theme Selection
- [ ] Bottom sheet opens on theme item tap
- [ ] Shows System, Light, Dark options
- [ ] Current selection has visual indicator (check icon)
- [ ] Selection immediately applies theme
- [ ] Bottom sheet dismisses on selection
- [ ] Theme persists across app restarts

### Language Selection
- [ ] Bottom sheet opens on language item tap
- [ ] Shows English and Arabic with native names
- [ ] Current selection has visual indicator
- [ ] Selection immediately changes app locale
- [ ] Bottom sheet dismisses on selection
- [ ] Language persists across app restarts
- [ ] RTL layout works for Arabic

### Legal Pages
- [ ] Privacy Policy opens in WebView
- [ ] Terms of Service opens in WebView
- [ ] WebView shows loading indicator
- [ ] WebView handles errors gracefully
- [ ] Back navigation works correctly

### Sign Out
- [ ] Confirmation dialog appears on tap
- [ ] Cancel dismisses dialog
- [ ] Confirm clears session and navigates to welcome
- [ ] User cannot navigate back after sign out

### SelectionBottomSheet
- [ ] Reusable across theme and language
- [ ] Consistent styling with existing bottom sheets
- [ ] Proper handle indicator at top
- [ ] Close button in header
- [ ] Scrollable for long lists

### General
- [ ] All UI follows Material 3 standards
- [ ] All strings use localization keys
- [ ] Proper accessibility support
- [ ] Analytics: `theme_changed`, `language_changed`, `privacy_viewed`, `terms_viewed`, `sign_out`

---

## Open Questions

| Question | Status |
|----------|--------|
| Should we add "Help & Support" section? | Deferred to future |
| Should we show app version? | Deferred to future |
| Additional languages to support? | Start with English and Arabic |

---

## References

- [Agent Guidelines](/agent.md) - Architecture and coding standards
- [Design System](/docs/design_system.md) - Colors, typography, spacing
- [Navigation PRD](/docs/features/navigation/prd.md) - Bottom navigation
- [Auth PRD](/docs/features/auth/prd.md) - Authentication flow
