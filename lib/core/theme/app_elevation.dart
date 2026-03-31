import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized elevation/shadow system — single source of truth.
///
/// All BoxShadow definitions MUST use these presets.
class AppElevation {
  AppElevation._();

  // ─── Blur Radius Constants ────────────────────────────────────────────────
  static const double glassBlur = 12.0;
  static const double blurLg    = 12.0;
  static const double blurXl    = 20.0;

  // ─── Standard Elevation Levels ────────────────────────────────────────────

  static const List<BoxShadow> none = [];

  static const List<BoxShadow> low = [
    BoxShadow(
      color: Color(0x0D000000), // black 5%
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> high = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> hero = [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 24,
      offset: const Offset(0, 6),
    ),
  ];

  // ─── Accent Glow Shadows ──────────────────────────────────────────────────

  /// Standard accent glow used for cards with colored accents
  static List<BoxShadow> accentGlow(Color color, {double opacity = 0.15, double blur = 18, Offset offset = const Offset(0, 6)}) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blur,
      offset: offset,
    ),
  ];

  /// Subtle glow for nav items, pills, badges
  static List<BoxShadow> subtleGlow(Color color, {double opacity = 0.2, double blur = 8}) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blur,
    ),
  ];

  /// Strong glow for active/selected elements
  static List<BoxShadow> strongGlow(Color color, {double opacity = 0.4, double blur = 16, Offset offset = const Offset(0, 4)}) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blur,
      offset: offset,
    ),
  ];

  /// Ring glow for avatars
  static List<BoxShadow> ringGlow(Color color, {double opacity = 0.45, double blur = 14, double spread = 1}) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blur,
      spreadRadius: spread,
    ),
  ];

  /// Bottom nav shadow
  static List<BoxShadow> navShadow = [
    BoxShadow(
      color: AppColors.neonGold.withOpacity(0.04),
      blurRadius: 20,
      offset: const Offset(0, -4),
    ),
  ];

  /// Banner shadow
  static List<BoxShadow> bannerShadow(Color color, {double opacity = 0.25}) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}
