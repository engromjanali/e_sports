import 'package:flutter/material.dart';
import 'app_breakpoints.dart';

/// Centralized component sizing system — single source of truth for
/// icon sizes, avatar sizes, indicator sizes, and other component dimensions.
///
/// Supports dynamic scaling based on screen dimensions and pixel density.
class AppSizing {
  AppSizing._();

  // ─── Icon Sizes ───────────────────────────────────────────────────────────
  static const double iconXs   = 10.0;
  static const double iconSm   = 14.0;
  static const double iconMd   = 16.0;
  static const double iconLg   = 18.0;
  static const double iconXl   = 22.0;
  static const double iconXxl  = 28.0;
  static const double iconEmoji = 52.0;
  static const double iconEmojiSm = 24.0;
  static const double iconBtnSm = 28.0;
  static const double iconBtnMd = 38.0;
  static const double iconBtnLg = 52.0;

  // ─── Avatar Sizes ─────────────────────────────────────────────────────────
  static const double avatarXs    = 32.0;
  static const double avatarSm    = 34.0;
  static const double avatarMd    = 40.0;
  static const double avatarMdLg  = 44.0;
  static const double avatarLg    = 60.0;
  static const double avatarXl    = 64.0;
  static const double avatarXxl   = 68.0;
  static const double avatarHero  = 70.0;
  static const double avatarPodium = 80.0;
  static const double avatarGiant = 90.0;

  // ─── Header Icon Button ───────────────────────────────────────────────────
  static const double headerIconSize = 34.0;

  // ─── Badge/Indicator Sizes ────────────────────────────────────────────────
  static const double badgeSm     = 15.0;
  static const double badgeMd     = 16.0;
  static const double dotSm       = 5.0;
  static const double dotMd       = 6.0;
  static const double dotLg       = 7.0;
  static const double onlineIndicatorFactor = 0.28;

  // ─── Progress Bar Heights ─────────────────────────────────────────────────
  static const double progressHeightSm = 3.0;
  static const double progressHeightLg = 8.0;
  static const double progressBarSm = 3.0;
  static const double progressBarMd = 5.0;
  static const double progressBarDefault = 6.0;
  static const double progressBarLg = 8.0;

  // ─── Shimmer / Divider Heights ────────────────────────────────────────────
  static const double shimmerHeight   = 2.0;
  static const double shimmerThick    = 2.5;
  static const double dividerHeight   = 1.0;

  // ─── Nav Indicator ────────────────────────────────────────────────────────
  static const double navIndicatorWidth  = 18.0;
  static const double navIndicatorHeight = 2.5;

  // ─── Card Heights / Widths ────────────────────────────────────────────────
  static const double newsbannerHeight = 145.0;
  static const double rankBoxHeight    = 120.0;
  static const double heroCardHeight   = 240.0;
  static const double miniCardWidth    = 160.0;
  static const double scorerCardWidth  = 160.0;
  static const double resultBoxSize    = 32.0;
  static const double resultChipSize   = 32.0;
  static const double achievementChipWidth = 85.0;

  // ─── Border Widths ────────────────────────────────────────────────────────
  static const double borderThin     = 1.0;
  static const double borderMedium   = 1.5;
  static const double borderThick    = 2.0;
  static const double borderAvatar   = 2.5;

  // ─── Quick Nav Icon Container ─────────────────────────────────────────────
  static const double quickNavIconSize = 40.0;

  // ─── Battery Indicator ────────────────────────────────────────────────────
  static const double batteryWidth  = 18.0;
  static const double batteryHeight = 10.0;

  // ─── Dynamic Scaling ──────────────────────────────────────────────────────

  /// Scale a value based on screen width, using the breakpoint system.
  static double scale(BuildContext context, double baseValue) {
    return baseValue * AppBreakpoints.scaleFactor(context);
  }

  /// Scale icon size based on screen
  static double scaledIcon(BuildContext context, double baseSize) =>
      scale(context, baseSize);

  /// Scale avatar size based on screen
  static double scaledAvatar(BuildContext context, double baseSize) =>
      scale(context, baseSize);
}
