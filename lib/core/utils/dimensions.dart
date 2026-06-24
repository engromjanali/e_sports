import 'package:flutter/material.dart';
import 'package:get/get.dart';

export 'package:e_sports/core/constants/app_colors.dart';

import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';

class Dimensions {
  // Responsive font sizes
  static double get fontSizeOverSmall => ResponsiveHelper.isDesktopWidth(Get.width) ? 10 : 8;
  static double get fontSizeExtraSmall => ResponsiveHelper.isDesktopWidth(Get.width) ? 12 : 10; // Check if 40 is a typo here!
  static double get fontSizeSmall => ResponsiveHelper.isDesktopWidth(Get.width) ? 14 : 12;
  static double get fontSizeDefault => ResponsiveHelper.isDesktopWidth(Get.width) ? 16 : 14;
  static double get fontSizeLarge => ResponsiveHelper.isDesktopWidth(Get.width) ? 18 : 16;
  static double get fontSizeExtraLarge => ResponsiveHelper.isDesktopWidth(Get.width) ? 20 : 18;
  static double get fontSizeOverLarge => ResponsiveHelper.isDesktopWidth(Get.width) ? 26 : 24;

  // Padding sizes
  static const double paddingSizeExtraSmall = 5.0;
  static const double paddingSizeSmall = 10.0;
  static const double paddingSizeDefault = 15.0;
  static const double paddingSizeLarge = 20.0;
  static const double paddingSizeExtraLarge = 25.0;
  static const double paddingSizeExtremeLarge = 30.0;
  static const double paddingSizeExtraOverLarge = 35.0;

  // Radius sizes
  static const double radiusSmall = 5.0;
  static const double radiusMedium = 8.0;
  static const double radiusDefault = 10.0;
  static const double radiusLarge = 15.0;
  static const double radiusExtraLarge = 20.0;

  // Layout limits
  static const double webMaxWidth = 1200;
  static const int messageInputLength = 1000;

  // Map sizes
  static const double pickMapIconSize = 100.0;

  // Spacing scale
  static const double xxs = 2.0;
  static const double xs = 3.0;
  static const double sm = 5.0;
  static const double micro = 7.0;
  static const double md = 8.0;
  static const double caption = 9.0;
  static const double lg = 10.0;
  static const double xl = 12.0;
  static const double bodyLarge = 13.0;
  static const double xxl = 14.0;
  static const double body2 = 11.0;
  static const double xxxl = 16.0;
  static const double huge = 18.0;
  static const double massive = 20.0;
  static const double giant = 24.0;

  // Component spacing
  static const double sectionGap = 16.0;
  static const double cardInnerPadding = 14.0;
  static const double cardOuterGap = 10.0;
  static const double screenPadding = 16.0;
  static const double headerPaddingH = 20.0;
  static const double headerPaddingV = 14.0;
  static const double statusBarPaddingH = 24.0;
  static const double statusBarPaddingV = 8.0;
  static const double dividerGap = 14.0;
  static const double chipSpacing = 8.0;
  static const double iconGap = 6.0;
  static const double pillPaddingH = 8.0;
  static const double pillPaddingV = 3.0;
  static const double buttonPaddingV = 14.0;

  // Responsive value helpers
  static double scaled(BuildContext context, double baseValue) {
    if (ResponsiveHelper.isDesktop(context)) return baseValue * 1.25;
    if (ResponsiveHelper.isTab(context)) return baseValue * 1.1;
    return baseValue;
  }

  // EdgeInsets presets
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: screenPadding);
  static const EdgeInsets screenAll = EdgeInsets.all(screenPadding);
  static const EdgeInsets cardPadding = EdgeInsets.all(cardInnerPadding);
  static const EdgeInsets headerPadding = EdgeInsets.symmetric(
    horizontal: headerPaddingH,
    vertical: headerPaddingV,
  );
  static const EdgeInsets statusBarPadding = EdgeInsets.symmetric(
    horizontal: statusBarPaddingH,
    vertical: statusBarPaddingV,
  );
  static const EdgeInsets pillPadding = EdgeInsets.symmetric(
    horizontal: pillPaddingH,
    vertical: pillPaddingV,
  );
  static const EdgeInsets navPadding = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets hugePadding = EdgeInsets.all(huge);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(horizontal: xxxl, vertical: md);

  // Border radius values
  static const double radiusXxsValue = 2.0;
  static const double radiusXsValue = 4.0;
  static const double radiusSmValue = 6.0;
  static const double radiusMdValue = 8.0;
  static const double radiusDefValue = 10.0;
  static const double radiusLgValue = 14.0;
  static const double radiusXlValue = 18.0;
  static const double radiusXxlValue = 22.0;
  static const double radiusPillValue = 30.0;
  static const double radiusTitleValue = 16.0;
  static const double radiusCardValue = 20.0;
  static const double radiusHeroValue = 28.0;

  // Radius presets
  static const Radius radiusXxs = Radius.circular(radiusXxsValue);
  static const Radius radiusXs = Radius.circular(radiusXsValue);
  static const Radius radiusSm = Radius.circular(radiusSmValue);
  static const Radius radiusMd = Radius.circular(radiusMdValue);
  static const Radius radiusDef = Radius.circular(radiusDefValue);
  static const Radius radiusLg = Radius.circular(radiusLgValue);
  static const Radius radiusXl = Radius.circular(radiusXlValue);
  static const Radius radiusXxl = Radius.circular(radiusXxlValue);
  static const Radius radiusPill = Radius.circular(radiusPillValue);
  static const Radius radiusCardCircle = Radius.circular(radiusCardValue);
  static const Radius radiusHeroCircle = Radius.circular(radiusHeroValue);

  // BorderRadius presets
  static final BorderRadius borderXxs = BorderRadius.circular(radiusXxsValue);
  static final BorderRadius borderXs = BorderRadius.circular(radiusXsValue);
  static final BorderRadius borderSm = BorderRadius.circular(radiusSmValue);
  static final BorderRadius borderMd = BorderRadius.circular(radiusMdValue);
  static final BorderRadius borderDef = BorderRadius.circular(radiusDefValue);
  static final BorderRadius borderLg = BorderRadius.circular(radiusLgValue);
  static final BorderRadius borderXl = BorderRadius.circular(radiusXlValue);
  static final BorderRadius borderXxl = BorderRadius.circular(radiusXxlValue);
  static final BorderRadius borderPill = BorderRadius.circular(radiusPillValue);
  static final BorderRadius borderTitle = BorderRadius.circular(radiusTitleValue);
  static final BorderRadius borderCard = BorderRadius.circular(radiusCardValue);
  static final BorderRadius borderHero = BorderRadius.circular(radiusHeroValue);

  // Custom BorderRadius shapes
  static const BorderRadius ribbonLeft = BorderRadius.only(
    topLeft: Radius.circular(6),
    bottomLeft: Radius.circular(6),
    topRight: Radius.circular(3),
    bottomRight: Radius.circular(3),
  );
  static const BorderRadius ribbonTopRight = BorderRadius.only(
    topRight: Radius.circular(10),
    bottomLeft: Radius.circular(6),
  );
  static const BorderRadius ribbonBadge = BorderRadius.only(
    topRight: Radius.circular(14),
    bottomLeft: Radius.circular(8),
  );
  static const BorderRadius borderXlOnlyTop = BorderRadius.vertical(
    top: Radius.circular(radiusXlValue),
  );

  // Icon sizes
  static const double iconXs = 10.0;
  static const double iconSm = 14.0;
  static const double iconMd = 16.0;
  static const double iconLg = 18.0;
  static const double iconXl = 22.0;
  static const double iconXxl = 28.0;
  static const double iconEmoji = 52.0;
  static const double iconEmojiSm = 24.0;
  static const double iconBtnSm = 28.0;
  static const double iconBtnMd = 38.0;
  static const double iconBtnLg = 52.0;

  // Avatar sizes
  static const double avatarXs = 32.0;
  static const double avatarSm = 34.0;
  static const double avatarMd = 40.0;
  static const double avatarMdLg = 44.0;
  static const double avatarLg = 60.0;
  static const double avatarXl = 64.0;
  static const double avatarXxl = 68.0;
  static const double avatarHero = 70.0;
  static const double avatarPodium = 80.0;
  static const double avatarGiant = 90.0;

  // Component sizes
  static const double headerIconSize = 34.0;
  static const double badgeSm = 15.0;
  static const double badgeMd = 16.0;
  static const double dotSm = 5.0;
  static const double dotMd = 6.0;
  static const double dotLg = 7.0;
  static const double onlineIndicatorFactor = 0.28;
  static const double progressHeightSm = 3.0;
  static const double progressHeightLg = 8.0;
  static const double progressBarSm = 3.0;
  static const double progressBarMd = 5.0;
  static const double progressBarDefault = 6.0;
  static const double progressBarLg = 8.0;
  static const double shimmerHeight = 2.0;
  static const double shimmerThick = 2.5;
  static const double dividerHeight = 1.0;
  static const double navIndicatorWidth = 18.0;
  static const double navIndicatorHeight = 2.5;
  static const double newsbannerHeight = 145.0;
  static const double rankBoxHeight = 120.0;
  static const double heroCardHeight = 240.0;
  static const double miniCardWidth = 160.0;
  static const double scorerCardWidth = 160.0;
  static const double resultBoxSize = 32.0;
  static const double resultChipSize = 32.0;
  static const double achievementChipWidth = 85.0;
  static const double borderThin = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick = 2.0;
  static const double borderAvatar = 2.5;
  static const double quickNavIconSize = 40.0;
  static const double batteryWidth = 18.0;
  static const double batteryHeight = 10.0;

  // Responsive scale helpers
  static double scale(BuildContext context, double baseValue) {
    if (ResponsiveHelper.isDesktop(context)) return baseValue * 1.1;
    if (ResponsiveHelper.isTab(context)) return baseValue * 1.05;
    if (ResponsiveHelper.isSmallMobile(context)) return baseValue * 0.9;
    return baseValue;
  }

  static double scaledIcon(BuildContext context, double baseSize) => scale(context, baseSize);
  static double scaledAvatar(BuildContext context, double baseSize) => scale(context, baseSize);

  // Font family and weights
  static String get fontFamily => 'Roboto';
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // Text size values
  static const double sizeOverSmall = 6.5;
  static const double sizeMicro = 7.0;
  static const double sizeTiny = 8.0;
  static const double sizeCaption = 9.0;
  static const double sizeSmall = 10.0;
  static const double sizeBody2 = 11.0;
  static const double sizeBody = 12.0;
  static const double sizeBodyLarge = 13.0;
  static const double sizeSubtitle = 14.0;
  static const double sizeTitle = 15.0;
  static const double sizeTitleLarge = 16.0;
  static const double sizeHeading = 18.0;
  static const double sizeHeadingLg = 20.0;
  static const double sizeDisplay = 26.0;
  static const double sizeHero = 46.0;
  static const double sizeWatermark = 75.0;
  static const double sizeGhostXl = 90.0;
  static const double sizeGhostXxl = 110.0;

  // Responsive text sizes
  static double overSmall(BuildContext context) => scaleText(context, sizeOverSmall);
  static double textMicro(BuildContext context) => scaleText(context, sizeMicro);
  static double tiny(BuildContext context) => scaleText(context, sizeTiny);
  static double textCaption(BuildContext context) => scaleText(context, sizeCaption);
  static double small(BuildContext context) => scaleText(context, sizeSmall);
  static double textBody2(BuildContext context) => scaleText(context, sizeBody2);
  static double body(BuildContext context) => scaleText(context, sizeBody);
  static double textBodyLarge(BuildContext context) => scaleText(context, sizeBodyLarge);
  static double subtitle(BuildContext context) => scaleText(context, sizeSubtitle);
  static double title(BuildContext context) => scaleText(context, sizeTitle);
  static double titleLarge(BuildContext context) => scaleText(context, sizeTitleLarge);
  static double heading(BuildContext context) => scaleText(context, sizeHeading);
  static double headingLg(BuildContext context) => scaleText(context, sizeHeadingLg);
  static double display(BuildContext context) => scaleText(context, sizeDisplay);
  static double hero(BuildContext context) => scaleText(context, sizeHero);
  static double watermark(BuildContext context) => scaleText(context, sizeWatermark);
  static double ghostXl(BuildContext context) => scaleText(context, sizeGhostXl);
  static double ghostXxl(BuildContext context) => scaleText(context, sizeGhostXxl);

  // Text scale helper
  static double scaleText(BuildContext context, double baseSize) {
    final scaleFactor = ResponsiveHelper.isDesktop(context) ? 1.15 : 1.0;
    return baseSize * scaleFactor;
  }

  // TextStyle presets
  static TextStyle labelUppercase(BuildContext context, {Color? color, double? letterSpacing}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: textMicro(context),
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
    fontSize: textCaption(context),
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
    fontSize: textMicro(context),
    fontWeight: black,
    letterSpacing: letterSpacing ?? 1.6,
    color: color ?? AppColors.neonGold.withOpacity(0.9),
  );

  static TextStyle tagLabel(BuildContext context, {Color? color}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: textCaption(context),
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
    fontSize: textCaption(context),
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

  // Text line height and tracking
  static const double lineHeightTight = 0.9;
  static const double lineHeightCompact = 1.0;
  static const double lineHeightNormal = 1.2;
  static const double lineHeightRelaxed = 1.5;
  static const double lineHeightLoose = 1.7;
  static const double lineHeightSpacious = 1.8;
  static const double trackingTight = 0.3;
  static const double trackingNormal = 0.5;
  static const double trackingWide = 1.0;
  static const double trackingWider = 1.2;
  static const double trackingWidest = 1.6;
  static const double trackingUltra = 2.0;
  static const double trackingMax = 2.5;

  // Blur values
  static const double glassBlur = 12.0;
  static const double blurLg = 12.0;
  static const double blurXl = 20.0;

  // Shadow presets
  static const List<BoxShadow> none = [];
  static const List<BoxShadow> low = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
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

  static List<BoxShadow> heroShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 24,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> accentGlow(Color color, {double opacity = 0.15, double blur = 18, Offset offset = const Offset(0, 6)}) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blur,
      offset: offset,
    ),
  ];

  static List<BoxShadow> subtleGlow(Color color, {double opacity = 0.2, double blur = 8}) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blur,
    ),
  ];

  static List<BoxShadow> strongGlow(Color color, {double opacity = 0.4, double blur = 16, Offset offset = const Offset(0, 4)}) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blur,
      offset: offset,
    ),
  ];

  static List<BoxShadow> ringGlow(Color color, {double opacity = 0.45, double blur = 14, double spread = 1}) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blur,
      spreadRadius: spread,
    ),
  ];

  static List<BoxShadow> navShadow = [
    BoxShadow(
      color: AppColors.neonGold.withOpacity(0.04),
      blurRadius: 20,
      offset: const Offset(0, -4),
    ),
  ];

  static List<BoxShadow> bannerShadow(Color color, {double opacity = 0.25}) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}
