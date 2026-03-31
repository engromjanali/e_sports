import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Centralized breakpoint system — single source of truth for responsive behavior.
///
/// Provides consistent breakpoints and adaptive utilities across Web, Android, iOS.
class AppBreakpoints {
  AppBreakpoints._();

  // ─── Breakpoint Values ────────────────────────────────────────────────────
  static const double mobileSmall  = 360;
  static const double mobileLarge  = 480;
  static const double tablet       = 650;
  static const double desktop      = 1024;
  static const double largeDesktop = 1300;

  /// Max content width for web desktop layouts
  static const double webMaxWidth = 1200;

  // ─── Size Queries ─────────────────────────────────────────────────────────

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double pixelRatio(BuildContext context) =>
      MediaQuery.of(context).devicePixelRatio;

  // ─── Breakpoint Checks ────────────────────────────────────────────────────

  static bool isMobileSmall(BuildContext context) =>
      screenWidth(context) < mobileLarge;

  static bool isMobile(BuildContext context) =>
      screenWidth(context) < tablet;

  static bool isMobileLarge(BuildContext context) =>
      screenWidth(context) >= mobileLarge && screenWidth(context) < tablet;

  static bool isTablet(BuildContext context) =>
      screenWidth(context) >= tablet && screenWidth(context) < desktop;

  static bool isDesktop(BuildContext context) =>
      screenWidth(context) >= desktop;

  static bool isLargeDesktop(BuildContext context) =>
      screenWidth(context) >= largeDesktop;

  /// Returns true on native platforms (not web)
  static bool isApp() => !kIsWeb;

  /// Returns true if running on web
  static bool isWeb() => kIsWeb;

  // ─── Responsive Value Helper ──────────────────────────────────────────────

  /// Returns the appropriate value based on current screen size.
  /// Falls back to smaller sizes if larger not specified.
  ///
  /// Example:
  /// ```dart
  /// final columns = AppBreakpoints.responsive<int>(
  ///   context,
  ///   mobile: 1,
  ///   tablet: 2,
  ///   desktop: 3,
  /// );
  /// ```
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  // ─── Scale Factor ─────────────────────────────────────────────────────────

  /// Returns a dimension scale factor based on screen width.
  /// Useful for dynamically scaling UI elements.
  static double scaleFactor(BuildContext context) {
    final width = screenWidth(context);
    if (width >= largeDesktop) return 1.2;
    if (width >= desktop) return 1.1;
    if (width >= tablet) return 1.05;
    if (width >= mobileLarge) return 1.0;
    return 0.9; // small phones
  }
}
