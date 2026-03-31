import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_sports/core/theme/app_colors.dart';
import 'package:e_sports/core/theme/app_breakpoints.dart';

/// Centralized typography system — single source of truth for all text styles.
class AppTypography {
  AppTypography._();

  // ─── Font Family ──────────────────────────────────────────────────────────
  static String get fontFamily => GoogleFonts.hindSiliguri().fontFamily!;

  // ─── Font Weights ─────────────────────────────────────────────────────────
  static const FontWeight regular   = FontWeight.w400;
  static const FontWeight medium    = FontWeight.w500;
  static const FontWeight semiBold  = FontWeight.w600;
  static const FontWeight bold      = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black     = FontWeight.w900;

  // ─── Base Font Sizes (before scaling) ─────────────────────────────────────
  static const double _sizeOverSmall   = 6.5;
  static const double _sizeMicro       = 7.0;
  static const double _sizeTiny        = 8.0;
  static const double _sizeCaption     = 9.0;
  static const double _sizeSmall       = 10.0;
  static const double _sizeBody2       = 11.0;
  static const double _sizeBody        = 12.0;
  static const double _sizeBodyLarge   = 13.0;
  static const double _sizeSubtitle    = 14.0;
  static const double _sizeTitle       = 15.0;
  static const double _sizeTitleLarge  = 16.0;
  static const double _sizeHeading     = 18.0;
  static const double _sizeHeadingLg   = 20.0;
  static const double _sizeDisplay     = 26.0;
  static const double _sizeHero        = 46.0;
  static const double _sizeWatermark   = 75.0;
  static const double _sizeGhostXl     = 90.0;
  static const double _sizeGhostXxl    = 110.0;

  // ─── Scaled Font Size Getters ─────────────────────────────────────────────
  static double scaled(BuildContext context, double baseSize) {
    final scaleFactor = AppBreakpoints.isDesktop(context) ? 1.15 : 1.0;
    return baseSize * scaleFactor;
  }

  static double overSmall(BuildContext context)  => scaled(context, _sizeOverSmall);
  static double micro(BuildContext context)      => scaled(context, _sizeMicro);
  static double tiny(BuildContext context)       => scaled(context, _sizeTiny);
  static double caption(BuildContext context)    => scaled(context, _sizeCaption);
  static double small(BuildContext context)      => scaled(context, _sizeSmall);
  static double body2(BuildContext context)      => scaled(context, _sizeBody2);
  static double body(BuildContext context)       => scaled(context, _sizeBody);
  static double bodyLarge(BuildContext context)   => scaled(context, _sizeBodyLarge);
  static double subtitle(BuildContext context)   => scaled(context, _sizeSubtitle);
  static double title(BuildContext context)      => scaled(context, _sizeTitle);
  static double titleLarge(BuildContext context)  => scaled(context, _sizeTitleLarge);
  static double heading(BuildContext context)    => scaled(context, _sizeHeading);
  static double headingLg(BuildContext context)  => scaled(context, _sizeHeadingLg);
  static double display(BuildContext context)    => scaled(context, _sizeDisplay);
  static double hero(BuildContext context)       => scaled(context, _sizeHero);
  static double watermark(BuildContext context)   => scaled(context, _sizeWatermark);
  static double ghostXl(BuildContext context)    => scaled(context, _sizeGhostXl);
  static double ghostXxl(BuildContext context)   => scaled(context, _sizeGhostXxl);

  // ─── Raw Base Sizes (for non-context situations) ──────────────────────────
  static const double sizeOverSmall  = _sizeOverSmall;
  static const double sizeMicro      = _sizeMicro;
  static const double sizeTiny       = _sizeTiny;
  static const double sizeCaption    = _sizeCaption;
  static const double sizeSmall      = _sizeSmall;
  static const double sizeBody2      = _sizeBody2;
  static const double sizeBody       = _sizeBody;
  static const double sizeBodyLarge  = _sizeBodyLarge;
  static const double sizeSubtitle   = _sizeSubtitle;
  static const double sizeTitle      = _sizeTitle;
  static const double sizeTitleLarge = _sizeTitleLarge;
  static const double sizeHeading    = _sizeHeading;
  static const double sizeHeadingLg  = _sizeHeadingLg;
  static const double sizeDisplay    = _sizeDisplay;
  static const double sizeHero       = _sizeHero;
  static const double sizeWatermark  = _sizeWatermark;
  static const double sizeGhostXl    = _sizeGhostXl;
  static const double sizeGhostXxl   = _sizeGhostXxl;

  // ─── Pre-built Text Styles ────────────────────────────────────────────────
  static TextStyle labelUppercase(BuildContext context, {Color? color, double? letterSpacing}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: micro(context),
    fontWeight: extraBold,
    letterSpacing: letterSpacing ?? 1.1,
    color: color ?? AppColors.white.withOpacity(0.35),
  );

  static TextStyle statValue(BuildContext context, {Color? color}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: heading(context),
    fontWeight: black,
    color: color ?? AppColors.neonGold,
    height: 1,
  );

  static TextStyle premiumSportsTitle(BuildContext context, {Color? color}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: caption(context),
    fontWeight: black,
    letterSpacing: 2.5,
    color: color ?? AppColors.neonGold,
  );

  static TextStyle statsGiant(BuildContext context, {Color? color}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: display(context),
    fontWeight: black,
    height: 0.9,
    color: color ?? AppColors.white,
  );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
    fontFamily: fontFamily,
    fontSize: heading(context),
    fontWeight: black,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle cardTitle(BuildContext context) => TextStyle(
    fontFamily: fontFamily,
    fontSize: subtitle(context),
    fontWeight: black,
    color: AppColors.white,
    height: 1.2,
  );

  static TextStyle pillLabel(BuildContext context, {Color? color, double? letterSpacing}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: micro(context),
    fontWeight: black,
    letterSpacing: letterSpacing ?? 1.6,
    color: color ?? AppColors.neonGold.withOpacity(0.9),
  );

  static TextStyle tagLabel(BuildContext context, {Color? color}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: caption(context),
    fontWeight: extraBold,
    letterSpacing: 2.0,
    color: color ?? AppColors.neonGold,
  );

  static TextStyle mutedText(BuildContext context) => TextStyle(
    fontFamily: fontFamily,
    fontSize: small(context),
    color: AppColors.textMuted,
  );

  static TextStyle bodyText(BuildContext context, {Color? color, FontWeight? weight}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: body(context),
    fontWeight: weight ?? bold,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle navLabel(BuildContext context, {required bool active}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: caption(context),
    fontWeight: active ? extraBold : medium,
    color: active ? AppColors.neonGold : AppColors.textMuted,
  );

  static TextStyle robotoRegular(BuildContext context) => TextStyle(
    fontFamily: fontFamily,
    fontWeight: regular,
    fontSize: subtitle(context),
  );

  static TextStyle robotoMedium(BuildContext context) => TextStyle(
    fontFamily: fontFamily,
    fontWeight: medium,
    fontSize: subtitle(context),
  );

  static TextStyle robotoSemiBold(BuildContext context) => TextStyle(
    fontFamily: fontFamily,
    fontWeight: semiBold,
    fontSize: subtitle(context),
  );

  static TextStyle robotoBold(BuildContext context) => TextStyle(
    fontFamily: fontFamily,
    fontWeight: bold,
    fontSize: subtitle(context),
  );

  static TextStyle robotoBlack(BuildContext context) => TextStyle(
    fontFamily: fontFamily,
    fontWeight: black,
    fontSize: subtitle(context),
  );

  static const double lineHeightTight    = 0.9;
  static const double lineHeightCompact  = 1.0;
  static const double lineHeightNormal   = 1.2;
  static const double lineHeightRelaxed  = 1.5;
  static const double lineHeightLoose    = 1.7;
  static const double lineHeightSpacious = 1.8;

  static const double trackingTight    = 0.3;
  static const double trackingNormal   = 0.5;
  static const double trackingWide     = 1.0;
  static const double trackingWider    = 1.2;
  static const double trackingWidest   = 1.6;
  static const double trackingUltra    = 2.0;
  static const double trackingMax      = 2.5;
}
