import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sms/core/services/local_storage_service.dart';
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

  Future<List<Category>> fetchCategories() async {
    // 1. Try remote fetch
    try {
      final url = getConfigUrl();
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        await _localStorage.setString(_cachedConfigKey, response.body);
        return _parseCategories(response.body);
      }
    } catch (_) {}

    // 2. Try cached config
    final cached = _localStorage.getString(_cachedConfigKey);
    if (cached != null) {
      return _parseCategories(cached);
    }

    // 3. Fall back to local asset
    final jsonString = await rootBundle.loadString('assets/config.json');
    return _parseCategories(jsonString);
  }

  List<Category> _parseCategories(String jsonString) {
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final categoriesJson = jsonData['categories'] as List;
    return categoriesJson
        .map((json) => Category.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
