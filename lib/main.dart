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
import 'package:sms/ui/theme/design_tokens.dart';

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
    final isDarkMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'SMS Commands',
      debugShowCheckedModeBanner: false,
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
      theme: _buildTheme(context, primaryColor, Brightness.light),
      darkTheme: _buildTheme(context, primaryColor, Brightness.dark),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }

  ThemeData _buildTheme(BuildContext context, Color primaryColor, Brightness brightness) {
    const fontFamily = 'IBMPlexSansArabic';

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      fontFamily: fontFamily,

      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: AppFontSize.xxxl,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 3,
        shadowColor: Colors.black.withAlpha(26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 3,
          shadowColor: Colors.black.withAlpha(51),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
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
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: primaryColor, width: 2.5),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: AppFontSize.md,
          fontWeight: FontWeight.w500,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: AppFontSize.md,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
