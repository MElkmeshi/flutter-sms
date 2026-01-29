import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms/core/services/local_storage_service.dart';
import 'package:sms/core/services/config_service.dart';
import 'package:sms/domain/model/app_config.dart';

/// Provider for LocalStorageService
/// This will be overridden in main.dart with the initialized instance
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError(
    'LocalStorageService provider must be overridden in main.dart with initialized instance',
  );
});

/// Provider for ConfigService
final configServiceProvider = Provider<ConfigService>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return ConfigService(localStorage);
});

/// Provider for the full AppConfig (fetched async with caching/fallback)
final appConfigProvider = FutureProvider<AppConfig>((ref) async {
  final configService = ref.watch(configServiceProvider);
  return configService.fetchAppConfig();
});

/// Provider for the app locale (user can toggle between 'ar' and 'en')
final localeProvider = NotifierProvider<LocaleNotifier, String>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<String> {
  static const _key = 'app_locale';

  @override
  String build() {
    final localStorage = ref.watch(localStorageServiceProvider);
    return localStorage.getString(_key) ?? 'ar';
  }

  void toggle() {
    final newLocale = state == 'ar' ? 'en' : 'ar';
    state = newLocale;
    ref.read(localStorageServiceProvider).setString(_key, newLocale);
  }
}

/// Provider for the app theme mode (user can toggle between light and dark)
final themeModeProvider = NotifierProvider<ThemeModeNotifier, bool>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<bool> {
  static const _key = 'is_dark_mode';
  static const _settingsBox = 'settings';

  @override
  bool build() {
    final localStorage = ref.watch(localStorageServiceProvider);
    return localStorage.getData<bool>(_settingsBox, _key) ?? false;
  }

  void toggle() {
    state = !state;
    ref.read(localStorageServiceProvider).saveData(_settingsBox, _key, state);
  }
}
