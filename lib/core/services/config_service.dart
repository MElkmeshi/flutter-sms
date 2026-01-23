import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sms/core/services/local_storage_service.dart';
import 'package:sms/domain/model/app_config.dart';
import 'package:sms/domain/model/category.dart';

class ConfigService {
  static const String defaultConfigUrl =
      'https://raw.githubusercontent.com/MElkmeshi/flutter-sms/refs/heads/main/assets/config.json';
  static const String _configUrlKey = 'config_url';
  static const String _cachedConfigKey = 'cached_config_json';

  final LocalStorageService _localStorage;

  ConfigService(this._localStorage);

  String getConfigUrl() {
    return _localStorage.getString(_configUrlKey) ?? defaultConfigUrl;
  }

  Future<void> setConfigUrl(String url) async {
    await _localStorage.setString(_configUrlKey, url);
  }

  Future<AppConfig> fetchAppConfig() async {
    // 1. Try remote fetch
    try {
      final url = getConfigUrl();
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        await _localStorage.setString(_cachedConfigKey, response.body);
        return _parseAppConfig(response.body);
      }
    } catch (_) {}

    // 2. Try cached config
    final cached = _localStorage.getString(_cachedConfigKey);
    if (cached != null) {
      return _parseAppConfig(cached);
    }

    // 3. Fall back to local asset
    final jsonString = await rootBundle.loadString('assets/config.json');
    return _parseAppConfig(jsonString);
  }

  Future<List<Category>> fetchCategories() async {
    final config = await fetchAppConfig();
    return config.categories;
  }

  /// Load theme config synchronously from cache (for instant startup theme).
  /// Returns null if no cache is available.
  ThemeConfig? getCachedThemeConfig() {
    final cached = _localStorage.getString(_cachedConfigKey);
    if (cached != null) {
      try {
        final jsonData = json.decode(cached) as Map<String, dynamic>;
        final themeJson = jsonData['theme'] as Map<String, dynamic>?;
        if (themeJson != null) {
          return ThemeConfig.fromJson(themeJson);
        }
      } catch (_) {}
    }
    return null;
  }

  AppConfig _parseAppConfig(String jsonString) {
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    return AppConfig.fromJson(jsonData);
  }
}
