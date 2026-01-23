# Technical Spec: Account Feature

> **Last Updated**: January 2026

---

## Overview

The account screen provides user preferences and session management. It uses local storage for persistence and bottom sheets for selection UI.

---

## Dependencies

### New Dependencies Required

```yaml
webview_flutter: ^4.10.0    # For legal document viewing
```

### Existing Dependencies Used

- `flutter_riverpod` - State management
- `shared_preferences` - Persistence
- `auto_route` - Navigation
- `lucide_icons_flutter` - Icons

---

## Data Persistence

### SharedPreferences Keys

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `theme_mode` | `String` | `"system"` | One of: "system", "light", "dark" |
| `locale` | `String` | `"en"` | Language code: "en" or "ar" |

---

## Data Models

### ThemeModeOption

```dart
enum ThemeModeOption {
  system('system'),
  light('light'),
  dark('dark');

  const ThemeModeOption(this.value);
  final String value;

  ThemeMode toThemeMode() {
    return switch (this) {
      ThemeModeOption.system => ThemeMode.system,
      ThemeModeOption.light => ThemeMode.light,
      ThemeModeOption.dark => ThemeMode.dark,
    };
  }

  static ThemeModeOption fromString(String value) {
    return ThemeModeOption.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ThemeModeOption.system,
    );
  }
}
```

### LocaleOption

```dart
enum LocaleOption {
  english('en', 'English'),
  arabic('ar', 'العربية');

  const LocaleOption(this.code, this.nativeName);
  final String code;
  final String nativeName;

  Locale toLocale() => Locale(code);

  static LocaleOption fromCode(String code) {
    return LocaleOption.values.firstWhere(
      (e) => e.code == code,
      orElse: () => LocaleOption.english,
    );
  }
}
```

---

## Repository

### AccountRepository

```dart
class AccountRepository {
  AccountRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = 'theme_mode';
  static const _localeKey = 'locale';

  // Theme
  ThemeModeOption getThemeMode() {
    final value = _prefs.getString(_themeModeKey);
    return value != null
        ? ThemeModeOption.fromString(value)
        : ThemeModeOption.system;
  }

  Future<void> setThemeMode(ThemeModeOption mode) async {
    await _prefs.setString(_themeModeKey, mode.value);
  }

  // Locale
  LocaleOption getLocale() {
    final value = _prefs.getString(_localeKey);
    return value != null
        ? LocaleOption.fromCode(value)
        : LocaleOption.english;
  }

  Future<void> setLocale(LocaleOption locale) async {
    await _prefs.setString(_localeKey, locale.code);
  }
}
```

---

## Controllers

### ThemeController

```dart
class ThemeController extends Notifier<ThemeModeOption> {
  static final provider = NotifierProvider<ThemeController, ThemeModeOption>(
    ThemeController.new,
  );

  late final AccountRepository _repository;

  @override
  ThemeModeOption build() {
    _repository = ref.watch(accountRepositoryProvider);
    return _repository.getThemeMode();
  }

  Future<void> setTheme(ThemeModeOption mode) async {
    await _repository.setThemeMode(mode);
    state = mode;
  }
}
```

### LocaleController

```dart
class LocaleController extends Notifier<LocaleOption> {
  static final provider = NotifierProvider<LocaleController, LocaleOption>(
    LocaleController.new,
  );

  late final AccountRepository _repository;

  @override
  LocaleOption build() {
    _repository = ref.watch(accountRepositoryProvider);
    return _repository.getLocale();
  }

  Future<void> setLocale(LocaleOption locale) async {
    await _repository.setLocale(locale);
    state = locale;
  }
}
```

---

## Providers

### account_deps.dart

```dart
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AccountRepository(prefs);
});
```

---

## Shared Widget: SelectionBottomSheet

Located in `lib/ui/widget/selection_bottom_sheet.dart`:

```dart
class SelectionBottomSheet<T> extends StatelessWidget {
  const SelectionBottomSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelect,
    required this.labelBuilder,
    this.iconBuilder,
    super.key,
  });

  final String title;
  final List<T> options;
  final T selectedValue;
  final ValueChanged<T> onSelect;
  final String Function(T) labelBuilder;
  final IconData Function(T)? iconBuilder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final spacing = context.spacing;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.sm),
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const AppIcon(LucideIcons.x),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          // Options
          ...options.map((option) {
            final isSelected = option == selectedValue;
            return ListTile(
              leading: iconBuilder != null
                  ? AppIcon(iconBuilder!(option))
                  : null,
              title: Text(labelBuilder(option)),
              trailing: isSelected
                  ? AppIcon(
                      LucideIcons.check,
                      color: colorScheme.primary,
                    )
                  : null,
              onTap: () {
                onSelect(option);
                Navigator.pop(context);
              },
            );
          }),
          SizedBox(height: spacing.md),
        ],
      ),
    );
  }
}
```

**Helper function:**

```dart
Future<void> showSelectionBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required T selectedValue,
  required ValueChanged<T> onSelect,
  required String Function(T) labelBuilder,
  IconData Function(T)? iconBuilder,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (_) => SelectionBottomSheet<T>(
      title: title,
      options: options,
      selectedValue: selectedValue,
      onSelect: onSelect,
      labelBuilder: labelBuilder,
      iconBuilder: iconBuilder,
    ),
  );
}
```

---

## Widget: AccountListTile

Located in `lib/feature/account/ui/account_list_tile.dart`:

```dart
class AccountListTile extends StatelessWidget {
  const AccountListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final spacing = context.spacing;

    return ListTile(
      leading: AppIcon(
        icon,
        color: colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: textTheme.titleMedium,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: AppIcon(
        LucideIcons.chevronRight,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
```

---

## Screen: AccountScreen

Located in `lib/feature/account/ui/account_screen.dart`:

```dart
@RoutePage()
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(ThemeController.provider);
    final locale = ref.watch(LocaleController.provider);
    final colorScheme = Theme.of(context).colorScheme;
    final spacing = context.spacing;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        children: [
          // Theme
          AccountListTile(
            icon: _getThemeIcon(themeMode),
            title: 'Theme',
            subtitle: _getThemeLabel(themeMode),
            onTap: () => _showThemeBottomSheet(context, ref, themeMode),
          ),
          // Language
          AccountListTile(
            icon: LucideIcons.globe,
            title: 'Language',
            subtitle: locale.nativeName,
            onTap: () => _showLanguageBottomSheet(context, ref, locale),
          ),
          // Divider
          Divider(
            height: spacing.lg,
            indent: spacing.md,
            endIndent: spacing.md,
          ),
          // Privacy Policy
          AccountListTile(
            icon: LucideIcons.shield,
            title: 'Privacy Policy',
            onTap: () => context.pushRoute(
              WebViewRoute(
                title: 'Privacy Policy',
                url: Env.privacyPolicyUrl,
              ),
            ),
          ),
          // Terms of Service
          AccountListTile(
            icon: LucideIcons.fileText,
            title: 'Terms of Service',
            onTap: () => context.pushRoute(
              WebViewRoute(
                title: 'Terms of Service',
                url: Env.termsOfServiceUrl,
              ),
            ),
          ),
          // Sign Out Button
          Padding(
            padding: EdgeInsets.all(spacing.md).copyWith(top: spacing.xl),
            child: OutlinedButton(
              onPressed: () => _showSignOutDialog(context, ref),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.error,
                side: BorderSide(color: colorScheme.error),
              ),
              child: const Text('Sign Out'),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getThemeIcon(ThemeModeOption mode) {
    return switch (mode) {
      ThemeModeOption.system => LucideIcons.monitor,
      ThemeModeOption.light => LucideIcons.sun,
      ThemeModeOption.dark => LucideIcons.moon,
    };
  }

  String _getThemeLabel(ThemeModeOption mode) {
    return switch (mode) {
      ThemeModeOption.system => 'System',
      ThemeModeOption.light => 'Light',
      ThemeModeOption.dark => 'Dark',
    };
  }

  void _showThemeBottomSheet(
    BuildContext context,
    WidgetRef ref,
    ThemeModeOption current,
  ) {
    showSelectionBottomSheet<ThemeModeOption>(
      context: context,
      title: 'Select Theme',
      options: ThemeModeOption.values,
      selectedValue: current,
      onSelect: (mode) => ref.read(ThemeController.provider.notifier).setTheme(mode),
      labelBuilder: _getThemeLabel,
      iconBuilder: _getThemeIcon,
    );
  }

  void _showLanguageBottomSheet(
    BuildContext context,
    WidgetRef ref,
    LocaleOption current,
  ) {
    showSelectionBottomSheet<LocaleOption>(
      context: context,
      title: 'Select Language',
      options: LocaleOption.values,
      selectedValue: current,
      onSelect: (locale) => ref.read(LocaleController.provider.notifier).setLocale(locale),
      labelBuilder: (option) => option.nativeName,
    );
  }

  Future<void> _showSignOutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Clear auth session
      await ref.read(authControllerProvider.notifier).signOut();
      // Navigate to welcome
      if (context.mounted) {
        context.router.replaceAll([const WelcomeRoute()]);
      }
    }
  }
}
```

---

## Screen: WebViewScreen

Located in `lib/feature/account/ui/webview_screen.dart`:

```dart
@RoutePage()
class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    @PathParam('title') required this.title,
    @QueryParam('url') required this.url,
    super.key,
  });

  final String title;
  final String url;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (error) {
            // Handle error
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            LinearProgressIndicator(
              color: colorScheme.primary,
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
        ],
      ),
    );
  }
}
```

---

## App Integration

### Theme Integration in NazakaApp

Update `lib/main.dart` or app widget:

```dart
class NazakaApp extends ConsumerWidget {
  const NazakaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(ThemeController.provider);
    final locale = ref.watch(LocaleController.provider);

    return MaterialApp.router(
      title: 'Nazaka',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode.toThemeMode(),
      locale: locale.toLocale(),
      localizationsDelegates: const [
        // ... localization delegates
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      routerConfig: _appRouter.config(),
    );
  }
}
```

---

## Routing Updates

Add to `lib/ui/app_router/app_router.dart`:

```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // ... existing routes ...
    AutoRoute(page: WebViewRoute.page),
  ];
}
```

---

## Environment Variables

Add to `lib/core/env/env.dart`:

```dart
abstract class Env {
  // ... existing variables ...

  static const privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
    defaultValue: 'https://example.com/privacy',
  );

  static const termsOfServiceUrl = String.fromEnvironment(
    'TERMS_OF_SERVICE_URL',
    defaultValue: 'https://example.com/terms',
  );
}
```

---

## File Structure

```
lib/
|-- core/
|   +-- env/
|       +-- env.dart                 # Add privacy/terms URLs
|
|-- feature/account/
|   |-- data/
|   |   +-- account_repository.dart
|   |-- deps/
|   |   +-- account_deps.dart
|   |-- logic/
|   |   |-- theme_controller.dart
|   |   +-- locale_controller.dart
|   +-- ui/
|       |-- account_screen.dart
|       |-- account_list_tile.dart
|       +-- webview_screen.dart
|
+-- ui/widget/
    +-- selection_bottom_sheet.dart  # Shared widget
```

---

## Icons Reference (Lucide)

| Usage | Icon Name | Constant |
|-------|-----------|----------|
| Theme (System) | monitor | `LucideIcons.monitor` |
| Theme (Light) | sun | `LucideIcons.sun` |
| Theme (Dark) | moon | `LucideIcons.moon` |
| Language | globe | `LucideIcons.globe` |
| Privacy Policy | shield | `LucideIcons.shield` |
| Terms of Service | file-text | `LucideIcons.fileText` |
| Chevron | chevron-right | `LucideIcons.chevronRight` |
| Close | x | `LucideIcons.x` |
| Selected | check | `LucideIcons.check` |

---

## Analytics Events

| Event | When | Properties |
|-------|------|------------|
| `account_viewed` | Screen opened | - |
| `theme_changed` | Theme selection changed | `theme`: "system"\|"light"\|"dark" |
| `language_changed` | Language selection changed | `language`: "en"\|"ar" |
| `privacy_viewed` | Privacy policy opened | - |
| `terms_viewed` | Terms opened | - |
| `sign_out_initiated` | Sign out button tapped | - |
| `sign_out_confirmed` | Sign out confirmed | - |
| `sign_out_cancelled` | Sign out cancelled | - |

---

## Localization Keys

```yaml
account:
  title: "Account"
  theme:
    title: "Theme"
    select: "Select Theme"
    system: "System"
    light: "Light"
    dark: "Dark"
  language:
    title: "Language"
    select: "Select Language"
  privacy_policy: "Privacy Policy"
  terms_of_service: "Terms of Service"
  sign_out:
    button: "Sign Out"
    dialog_title: "Sign Out"
    dialog_message: "Are you sure you want to sign out?"
    cancel: "Cancel"
    confirm: "Sign Out"
```

---

## Checklist

- [ ] AccountRepository created with persistence
- [ ] ThemeController with static provider
- [ ] LocaleController with static provider
- [ ] SelectionBottomSheet shared widget
- [ ] AccountListTile widget
- [ ] AccountScreen with all list items
- [ ] WebViewScreen for legal pages
- [ ] Theme integration in app widget
- [ ] Locale integration in app widget
- [ ] WebView dependency added
- [ ] Environment URLs configured
- [ ] Routes registered
- [ ] Sign out flow with dialog
- [ ] Analytics events
- [ ] Localization keys

---

## References

- [Account PRD](./prd.md) - Product requirements
- [Auth Spec](/docs/features/auth/spec.md) - Authentication flow
- [Navigation Spec](/docs/features/navigation/spec.md) - Bottom navigation
- [Agent Guidelines](/agent.md) - Architecture and coding standards
