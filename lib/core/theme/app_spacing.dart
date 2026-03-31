import 'package:flutter/material.dart';
import 'app_breakpoints.dart';

/// Centralized spacing system — single source of truth for all padding,
/// margins, gaps, and spacing values.
///
/// All spacing MUST be referenced through this class. No magic numbers.
class AppSpacing {
  AppSpacing._();

  // ─── Base Spacing Tokens ──────────────────────────────────────────────────
  static const double xxs = 2.0;
  static const double xs  = 3.0;
  static const double sm  = 5.0;
  static const double micro = 7.0;
  static const double md  = 8.0;
  static const double caption = 9.0;
  static const double lg  = 10.0;
  static const double xl  = 12.0;
  static const double bodyLarge = 13.0;
  static const double xxl = 14.0;
  static const double body2 = 11.0;
  static const double xxxl = 16.0;
  static const double huge = 18.0;
  static const double massive = 20.0;
  static const double giant = 24.0;

  // ─── Semantic Spacing ─────────────────────────────────────────────────────
  static const double sectionGap       = 16.0;
  static const double cardInnerPadding = 14.0;
  static const double cardOuterGap     = 10.0;
  static const double screenPadding    = 16.0;
  static const double headerPaddingH   = 20.0;
  static const double headerPaddingV   = 14.0;
  static const double statusBarPaddingH = 24.0;
  static const double statusBarPaddingV = 8.0;
  static const double dividerGap       = 14.0;
  static const double chipSpacing      = 8.0;
  static const double iconGap          = 6.0;
  static const double pillPaddingH     = 8.0;
  static const double pillPaddingV     = 3.0;
  static const double buttonPaddingV   = 14.0;

  // ─── Dynamic Spacing (scales with screen size) ────────────────────────────

  static double scaled(BuildContext context, double baseValue) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1300) return baseValue * 1.25;
    if (width >= 650) return baseValue * 1.1;
    return baseValue;
  }

  // ─── EdgeInsets Convenience Methods ───────────────────────────────────────

  /// Standard screen padding (horizontal: 16)
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: screenPadding);

  /// Standard screen padding all sides
  static const EdgeInsets screenAll = EdgeInsets.all(screenPadding);

  /// Card inner padding
  static const EdgeInsets cardPadding = EdgeInsets.all(cardInnerPadding);

  /// Header padding
  static const EdgeInsets headerPadding = EdgeInsets.symmetric(
    horizontal: headerPaddingH,
    vertical: headerPaddingV,
  );

  /// Status bar padding
  static const EdgeInsets statusBarPadding = EdgeInsets.symmetric(
    horizontal: statusBarPaddingH,
    vertical: statusBarPaddingV,
  );

  /// Pill/badge padding
  static const EdgeInsets pillPadding = EdgeInsets.symmetric(
    horizontal: pillPaddingH,
    vertical: pillPaddingV,
  );

  /// Bottom nav padding
  static const EdgeInsets navPadding = EdgeInsets.symmetric(vertical: lg);

  /// Huge card padding
  static const EdgeInsets hugePadding = EdgeInsets.all(huge);

  /// Filter chip padding
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(horizontal: xxxl, vertical: md);

  // ─── SizedBox Convenience ─────────────────────────────────────────────────

  static const SizedBox gapXxs  = SizedBox(height: xxs);
  static const SizedBox gapXs   = SizedBox(height: xs);
  static const SizedBox gapSm   = SizedBox(height: sm);
  static const SizedBox gapMd   = SizedBox(height: md);
  static const SizedBox gapLg   = SizedBox(height: lg);
  static const SizedBox gapXl   = SizedBox(height: xl);
  static const SizedBox gapXxl  = SizedBox(height: xxl);
  static const SizedBox gapXxxl = SizedBox(height: xxxl);

  static const SizedBox hGapXs   = SizedBox(width: xs);
  static const SizedBox hGapSm   = SizedBox(width: sm);
  static const SizedBox hGapMd   = SizedBox(width: md);
  static const SizedBox hGapLg   = SizedBox(width: lg);
  static const SizedBox hGapXl   = SizedBox(width: xl);
  static const SizedBox hGapXxl  = SizedBox(width: xxl);
  static const SizedBox hGapXxxl = SizedBox(width: xxxl);
}
