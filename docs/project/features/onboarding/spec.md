# Technical Spec: Onboarding Feature

> **Last Updated**: January 2026

---

## Overview

The onboarding feature is a purely client-side flow with no API calls. State is managed locally with persistence via `SharedPreferences`.

---

## Architecture

### No API Calls

This feature has **no backend integration**. All data is:
- Hardcoded content (titles, descriptions)
- Local storage (completion flag)

### State Management

| State Type | Location | Reason |
|------------|----------|--------|
| Current page index | Hooks (`useState`) | Ephemeral, screen-local |
| Page controller | Hooks (`usePageController`) | Ephemeral, screen-local |
| Completion flag | Provider + SharedPreferences | Persistent, app-wide |

---

## Data Model

### OnboardingPage

```dart
@immutable
class OnboardingPage {
  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
```

### Pages Data (Hardcoded)

```dart
const onboardingPages = [
  OnboardingPage(
    icon: LucideIcons.sparkles,
    title: 'Welcome to Nazaka',
    description: 'Discover and shop beautiful dresses from local sellers',
  ),
  OnboardingPage(
    icon: LucideIcons.shirt,
    title: 'Choose Your Dress',
    description: 'Browse our collection and find the perfect outfit for any occasion',
  ),
  OnboardingPage(
    icon: LucideIcons.dollarSign,
    title: 'Sell Your Dresses',
    description: 'Turn your closet into cash — list your dresses in minutes',
  ),
];
```

---

## Controller

### OnboardingController

Manages only the completion state (persistent).

```dart
class OnboardingController extends AsyncNotifier<bool> {
  static final provider = AsyncNotifierProvider(OnboardingController.new);

  @override
  Future<bool> build() async {
    return _repository.hasCompletedOnboarding();
  }

  Future<void> completeOnboarding() async {
    await _repository.setOnboardingCompleted();
    state = const AsyncData(true);
  }
}
```

### What's NOT in the Controller

- Current page index → `useState` hook
- Page controller → `usePageController` hook
- Page animations → Flutter's PageView handles this

---

## Repository

### OnboardingRepository

```dart
class OnboardingRepository {
  const OnboardingRepository(this._prefs);
  final SharedPreferences _prefs;

  static const _key = 'onboarding_completed';

  Future<bool> hasCompletedOnboarding() async {
    return _prefs.getBool(_key) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_key, true);
  }

  // For testing/debug only
  Future<void> resetOnboarding() async {
    await _prefs.remove(_key);
  }
}
```

---

## Screen Implementation

### OnboardingScreen

```dart
@RoutePage()
class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Local UI state (hooks)
    final pageController = usePageController();
    final currentPage = useState(0);

    // Navigation helpers
    void nextPage() {
      if (currentPage.value < onboardingPages.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // Last page - complete onboarding
        ref.read(OnboardingController.provider.notifier).completeOnboarding();
        context.router.replace(const WelcomeRoute());
      }
    }

    void prevPage() {
      if (currentPage.value > 0) {
        pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) => currentPage.value = index,
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) => OnboardingPageWidget(
                  page: onboardingPages[index],
                ),
              ),
            ),
            // Page indicator dots
            PageIndicator(
              currentPage: currentPage.value,
              pageCount: onboardingPages.length,
            ),
            // Navigation buttons
            OnboardingNavigation(
              currentPage: currentPage.value,
              pageCount: onboardingPages.length,
              onNext: nextPage,
              onPrev: prevPage,
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

### Initial Route Logic

```dart
// In AppRouter or splash screen logic
Future<void> determineInitialRoute(WidgetRef ref) async {
  final hasCompletedOnboarding = await ref.read(
    OnboardingController.provider.future,
  );

  if (!hasCompletedOnboarding) {
    context.router.replace(const OnboardingRoute());
  } else {
    context.router.replace(const WelcomeRoute());
  }
}
```

### Route Definition

```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: OnboardingRoute.page),  // Add onboarding
    AutoRoute(page: WelcomeRoute.page),
    AutoRoute(page: PhoneEntryRoute.page),
    AutoRoute(page: OtpVerifyRoute.page),
    // ... other routes
  ];
}
```

---

## File Structure

```
lib/feature/onboarding/
├── data/
│   ├── onboarding_page.dart         # OnboardingPage model
│   └── onboarding_repository.dart   # SharedPreferences persistence
├── deps/
│   └── onboarding_deps.dart         # Provider definitions
├── logic/
│   └── onboarding_controller.dart   # Completion state controller
└── ui/
    ├── onboarding_screen.dart       # Main screen with PageView
    ├── onboarding_page_widget.dart  # Individual page content
    ├── page_indicator.dart          # Dot indicators
    └── onboarding_navigation.dart   # Prev/Next buttons
```

---

## Dependencies

### Required Packages

| Package | Purpose |
|---------|---------|
| `shared_preferences` | Persist onboarding completion flag |

### Add to pubspec.yaml

```yaml
dependencies:
  shared_preferences: ^2.2.0
```

---

## Analytics Events

| Event | When | Properties |
|-------|------|------------|
| `onboarding_started` | Screen 1 viewed | — |
| `onboarding_page_viewed` | Each page viewed | `page_index`, `page_title` |
| `onboarding_completed` | "Get Started" tapped | `total_time_seconds` |
| `onboarding_skipped` | Skip button (if added) | `last_page_viewed` |

---

## Testing

### Unit Tests

```dart
void main() {
  group('OnboardingRepository', () {
    test('returns false when not completed', () async {
      final prefs = MockSharedPreferences();
      when(() => prefs.getBool(any())).thenReturn(null);
      
      final repo = OnboardingRepository(prefs);
      expect(await repo.hasCompletedOnboarding(), false);
    });

    test('returns true when completed', () async {
      final prefs = MockSharedPreferences();
      when(() => prefs.getBool(any())).thenReturn(true);
      
      final repo = OnboardingRepository(prefs);
      expect(await repo.hasCompletedOnboarding(), true);
    });
  });
}
```

### Widget Tests

- [ ] Page navigation (next/prev)
- [ ] Page indicator updates
- [ ] Prev button disabled on first page
- [ ] "Get Started" on last page
- [ ] Completion triggers navigation

---

## Checklist

- [ ] `shared_preferences` added to pubspec.yaml
- [ ] OnboardingPage model created
- [ ] OnboardingRepository implemented
- [ ] OnboardingController with static provider
- [ ] OnboardingScreen with hooks for local state
- [ ] Page indicator widget
- [ ] Navigation buttons widget
- [ ] Route registered in AppRouter
- [ ] Initial route logic implemented
- [ ] Analytics events added
- [ ] Localization keys for all strings
- [ ] Material 3 compliance verified

---

## References

- [Onboarding PRD](./prd.md) — Product requirements
- [Agent Guidelines](/agent.md) — Architecture and coding standards
- [Flutter Hooks](/agent.md#flutter-hooks) — Local state management
- [Controller Architecture](/docs/architecture/controllers.md) — Provider patterns


