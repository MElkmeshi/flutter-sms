import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/core/services/local_storage_service.dart';
import 'package:sms/core/routing/app_router.dart';
import 'package:sms/core/initializer/app_providers.dart';
import 'package:sms/core/utils/icon_mapper.dart';
import 'package:sms/domain/model/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // In debug mode, disable Google Fonts network fetching (use local assets only)
  if (kDebugMode) {
    GoogleFonts.config.allowRuntimeFetching = false;
  }

  // Initialize local storage
  final localStorage = LocalStorageService();
  await localStorage.initialize();

  runApp(
    ProviderScope(
      overrides: [
        // Override with initialized storage instance
        localStorageServiceProvider.overrideWithValue(localStorage),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = AppRouter();

    // Watch appConfig for dynamic theme
    final appConfigAsync = ref.watch(appConfigProvider);
    final themeConfig = appConfigAsync.whenOrNull(data: (config) => config.theme)
        ?? ref.read(configServiceProvider).getCachedThemeConfig()
        ?? const ThemeConfig();

    final primaryColor = IconMapper.colorFromHex(
      themeConfig.primaryColor,
      fallback: const Color(0xFF2196F3),
    );

    final locales = themeConfig.supportedLocales
        .map((code) => Locale(code))
        .toList();

    final currentLocale = Locale(ref.watch(localeProvider));

    return MaterialApp.router(
      title: 'SMS Commands',
      routerConfig: appRouter.config(),

      // Localization
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: locales,
      locale: currentLocale,

      // Theme
      theme: _buildTheme(context, primaryColor),
    );
  }

  ThemeData _buildTheme(BuildContext context, Color primaryColor) {
    const fontFamily = 'IBMPlexSansArabic';

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),

      fontFamily: fontFamily,

      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        titleTextStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 3,
        shadowColor: Colors.black.withAlpha(26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 3,
          shadowColor: Colors.black.withAlpha(51),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 2.5),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        labelStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentTextStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
