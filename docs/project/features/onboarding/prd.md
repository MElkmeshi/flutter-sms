# PRD: Onboarding Feature

> **Status**: Draft  
> **Last Updated**: January 2026  
> **Owner**: TBD

---

## Goal

Introduce first-time users to the app's core value propositions (browsing and selling dresses) through a brief, engaging onboarding flow.

---

## Non-goals

- Account creation during onboarding
- Permission requests (camera, notifications)
- Deep feature tutorials
- Collecting user preferences

---

## User Stories

- [ ] **US-ONB-001**: As a first-time user, I want to see what the app offers so I understand its value before signing up.
- [ ] **US-ONB-002**: As a returning user, I want to skip onboarding so I can access the app immediately.

---

## Screens

### Screen 1: Welcome to Nazaka

First impression — introduces the app.

| Element | Type | Description |
|---------|------|-------------|
| Icon | `Icon` / `Image` | App logo or welcome illustration |
| Title | `Text` | "Welcome to Nazaka" |
| Supporting Text | `Text` | Brief tagline (lorem ipsum for now) |
| Next Button | `FilledButton` | Navigates to Screen 2 |
| Prev Button | `TextButton` | Disabled on first screen |
| Page Indicator | `Dots` | Shows current position (1 of 3) |

---

### Screen 2: Choose Your Dress

Highlights the browsing/shopping experience.

| Element | Type | Description |
|---------|------|-------------|
| Icon | `Icon` / `Image` | Dress browsing illustration |
| Title | `Text` | "Choose Your Dress" |
| Supporting Text | `Text` | Brief description (lorem ipsum for now) |
| Next Button | `FilledButton` | Navigates to Screen 3 |
| Prev Button | `TextButton` | Navigates back to Screen 1 |
| Page Indicator | `Dots` | Shows current position (2 of 3) |

---

### Screen 3: Sell Your Dresses (Final)

Highlights the selling functionality.

| Element | Type | Description |
|---------|------|-------------|
| Icon | `Icon` / `Image` | Selling illustration |
| Title | `Text` | "Sell Your Dresses" |
| Supporting Text | `Text` | Brief description (lorem ipsum for now) |
| Next Button | `FilledButton` | "Get Started" — completes onboarding |
| Prev Button | `TextButton` | Navigates back to Screen 2 |
| Page Indicator | `Dots` | Shows current position (3 of 3) |

---

## Screen States

| State | Description |
|-------|-------------|
| Default | Current page displayed, navigation enabled |
| First Page | Prev button disabled |
| Last Page | Next button shows "Get Started" |
| Animating | Page transition in progress |

---

## Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         FIRST APP LAUNCH                             │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          Screen 1                                    │
│                     "Welcome to Nazaka"                              │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────┐                                            │
│  │       [Icon]        │                                            │
│  │                     │                                            │
│  │  Welcome to Nazaka  │                                            │
│  │  Lorem ipsum...     │                                            │
│  │                     │                                            │
│  │     [Next →]        │ ─────────────────────────────┐             │
│  │  ● ○ ○              │                              │             │
│  │     [← Prev]        │ (disabled)                   │             │
│  └─────────────────────┘                              │             │
└─────────────────────────────────────────────────────────────────────┘
                                                        │
                                                        ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          Screen 2                                    │
│                    "Choose Your Dress"                               │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────┐                                            │
│  │       [Icon]        │                                            │
│  │                     │                                            │
│  │  Choose Your Dress  │                                            │
│  │  Lorem ipsum...     │                                            │
│  │                     │                                            │
│  │     [Next →]        │ ─────────────────────────────┐             │
│  │  ○ ● ○              │                              │             │
│  │     [← Prev]        │ ◄─────────────────────────────────────┐    │
│  └─────────────────────┘                              │        │    │
└─────────────────────────────────────────────────────────────────────┘
                                                        │        │
                                                        ▼        │
┌─────────────────────────────────────────────────────────────────────┐
│                          Screen 3                                    │
│                    "Sell Your Dresses"                               │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────┐                                            │
│  │       [Icon]        │                                            │
│  │                     │                                            │
│  │  Sell Your Dresses  │                                            │
│  │  Lorem ipsum...     │                                            │
│  │                     │                                            │
│  │   [Get Started]     │ ─────────────────────────────┐             │
│  │  ○ ○ ●              │                              │             │
│  │     [← Prev]        │ ─────────────────────────────┼─────────────┘
│  └─────────────────────┘                              │
└─────────────────────────────────────────────────────────────────────┘
                                                        │
                                                        ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       WELCOME SCREEN                                 │
│                    (Auth Flow Begins)                                │
│                                                                      │
│                   [Login / Register]                                 │
│                   [Continue as Guest]                                │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Functional Requirements

### FR-001: First Launch Detection
- Check local storage for onboarding completion flag
- If not completed → Show onboarding
- If completed → Skip to Welcome screen

### FR-002: Navigation
- Support swipe gestures between pages
- Next button advances to next page
- Prev button returns to previous page
- Prev disabled on first page

### FR-003: Completion
- "Get Started" on final screen marks onboarding complete
- Store completion flag in local storage
- Navigate to Welcome screen (auth flow)

### FR-004: Persistence
- Onboarding completion persists across app restarts
- Clearing app data resets onboarding flag

---

## UI Requirements

### Layout
- Icon/illustration: Top 40% of screen
- Title: Centered, prominent
- Supporting text: Below title, secondary style
- Navigation buttons: Bottom of screen
- Page indicator: Between content and buttons

### Animation
- Page transitions: Horizontal slide
- Dot indicator: Animate between positions
- Button state changes: Smooth transitions

### Accessibility
- All images have semantic descriptions
- Buttons have proper labels
- Swipe gestures have button alternatives

---

## Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| App killed mid-onboarding | Resume from Screen 1 on next launch |
| Back button on Screen 1 | Exit app / do nothing |
| Very fast swiping | Debounce, prevent double navigation |
| Screen rotation | Maintain current page position |

---

## Acceptance Criteria

### Screen 1: Welcome
- [ ] Icon/illustration displayed
- [ ] "Welcome to Nazaka" title shown
- [ ] Supporting text displayed
- [ ] Next button enabled
- [ ] Prev button disabled (visually indicated)
- [ ] Page indicator shows position 1 of 3

### Screen 2: Choose Your Dress
- [ ] Icon/illustration displayed
- [ ] "Choose Your Dress" title shown
- [ ] Supporting text displayed
- [ ] Next button enabled
- [ ] Prev button enabled and functional
- [ ] Page indicator shows position 2 of 3

### Screen 3: Sell Your Dresses
- [ ] Icon/illustration displayed
- [ ] "Sell Your Dresses" title shown
- [ ] Supporting text displayed
- [ ] Next button shows "Get Started"
- [ ] Prev button enabled and functional
- [ ] Page indicator shows position 3 of 3
- [ ] Tapping "Get Started" navigates to Welcome screen

### General
- [ ] Swipe navigation works between all pages
- [ ] Onboarding only shows on first launch
- [ ] Completion flag persists across restarts
- [ ] All UI follows Material 3 standards
- [ ] All strings use localization keys
- [ ] Analytics event: `onboarding_completed`

---

## Content (Placeholder)

| Screen | Title | Supporting Text |
|--------|-------|-----------------|
| 1 | Welcome to Nazaka | Discover and shop beautiful dresses from local sellers |
| 2 | Choose Your Dress | Browse our collection and find the perfect outfit for any occasion |
| 3 | Sell Your Dresses | Turn your closet into cash — list your dresses in minutes |

> **Note**: Final copy to be provided by content team.

---

## Open Questions

| Question | Status |
|----------|--------|
| Final illustrations/icons | Pending design |
| Final copy for supporting text | Pending content |
| Should onboarding be skippable via "Skip" button? | **Decision needed** |

---

## References

- [Agent Guidelines](/agent.md) — Architecture and coding standards
- [Design System](/docs/design_system.md) — Colors, typography, spacing
- [Auth Feature](/docs/features/auth/README.md) — Welcome screen destination


