import 'package:equatable/equatable.dart';
import 'package:sms/domain/model/category.dart';

class AppConfig extends Equatable {
  final ThemeConfig theme;
  final List<Category> categories;

  const AppConfig({
    required this.theme,
    required this.categories,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    final themeJson = json['theme'] as Map<String, dynamic>?;
    return AppConfig(
      theme: themeJson != null
          ? ThemeConfig.fromJson(themeJson)
          : const ThemeConfig(),
      categories: (json['categories'] as List)
          .map((c) => Category.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [theme, categories];
}

class ThemeConfig extends Equatable {
  final String primaryColor;
  final String? fontFamily;
  final String defaultLocale;
  final List<String> supportedLocales;

  const ThemeConfig({
    this.primaryColor = '#2196F3',
    this.fontFamily,
    this.defaultLocale = 'ar',
    this.supportedLocales = const ['en', 'ar'],
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      primaryColor: json['primary_color'] as String? ?? '#2196F3',
      fontFamily: json['font_family'] as String?,
      defaultLocale: json['default_locale'] as String? ?? 'ar',
      supportedLocales: json['supported_locales'] != null
          ? (json['supported_locales'] as List).cast<String>()
          : const ['en', 'ar'],
    );
  }

  @override
  List<Object?> get props => [primaryColor, fontFamily, defaultLocale, supportedLocales];
}
