/// Design tokens for consistent spacing, sizing, and styling throughout the app.
///
/// These tokens provide a centralized system for UI constants, ensuring
/// visual consistency and making future design updates easier to implement.
library;

/// Spacing scale based on 4px increments.
///
/// Use these constants for padding, margins, and gaps throughout the app.
class AppSpacing {
  AppSpacing._(); // Private constructor to prevent instantiation

  /// Extra small spacing (4px) - Tiny gaps, minimal padding
  static const double xs = 4.0;

  /// Small spacing (8px) - Small gaps, icon padding
  static const double sm = 8.0;

  /// Medium spacing (12px) - Standard gap between elements
  static const double md = 12.0;

  /// Large spacing (16px) - Section padding, card margins
  static const double lg = 16.0;

  /// Extra large spacing (20px) - Large section spacing
  static const double xl = 20.0;

  /// 2X large spacing (24px) - Major section breaks
  static const double xxl = 24.0;

  /// 3X large spacing (32px) - Screen-level spacing
  static const double xxxl = 32.0;
}

/// Border radius scale for consistent rounded corners.
///
/// Standard is 12px (md) for most cards and buttons.
class AppRadius {
  AppRadius._(); // Private constructor to prevent instantiation

  /// Small radius (8px) - Small containers, badges
  static const double sm = 8.0;

  /// Medium radius (12px) - Cards, buttons, inputs (STANDARD)
  static const double md = 12.0;

  /// Large radius (16px) - Large cards, prominent buttons
  static const double lg = 16.0;

  /// Extra large radius (20px) - Bottom sheets, dialogs
  static const double xl = 20.0;
}

/// Font size scale for typography hierarchy.
///
/// Use in combination with Theme.of(context).textTheme for styled text.
class AppFontSize {
  AppFontSize._(); // Private constructor to prevent instantiation

  /// Extra small (10px) - Tiny labels, badges
  static const double xs = 10.0;

  /// Small (12px) - Secondary text, captions
  static const double sm = 12.0;

  /// Medium (14px) - Body text, descriptions
  static const double md = 14.0;

  /// Large (15px) - List item titles
  static const double lg = 15.0;

  /// Extra large (16px) - Prominent text, form labels
  static const double xl = 16.0;

  /// 2X large (18px) - Section headers
  static const double xxl = 18.0;

  /// 3X large (20px) - Screen titles
  static const double xxxl = 20.0;
}

/// Icon size scale for consistent icon dimensions.
///
/// Use with XIcon or Icon widgets.
class AppIconSize {
  AppIconSize._(); // Private constructor to prevent instantiation

  /// Extra small (12px) - Tiny inline icons
  static const double xs = 12.0;

  /// Small (16px) - Small inline icons, arrows
  static const double sm = 16.0;

  /// Medium (18px) - Standard action icons
  static const double md = 18.0;

  /// Large (20px) - Prominent action icons
  static const double lg = 20.0;

  /// Extra large (24px) - Default icon size
  static const double xl = 24.0;

  /// 2X large (48px) - Large decorative icons
  static const double xxl = 48.0;
}
