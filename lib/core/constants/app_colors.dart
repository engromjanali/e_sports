import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color bg         = Color(0xFF0F172A);
  static const Color bgCard     = Color(0xFF1E293B);
  static const Color bgSurface  = Color(0xFF334155);
  static const Color bgGlass    = Color(0x1AFFFFFF);

  // Primary / Semantic
  static const Color primary    = neonGold;
  static const Color secondary  = neonCyan;
  static const Color error      = neonRed;
  static const Color success    = neonGreen;
  static const Color warning    = neonOrange;
  static const Color info       = neonBlue;

  // Neon accents
  static const Color neonGold   = Color(0xFFFFD700);
  static const Color neonGoldDim= Color(0xFFF5A623);
  static const Color neonCyan   = Color(0xFF00E5FF);
  static const Color neonBlue   = Color(0xFF4DA6FF);
  static const Color neonGreen  = Color(0xFF00E676);
  static const Color neonRed    = Color(0xFFFF1744);
  static const Color neonPurple = Color(0xFFE040FB);
  static const Color neonOrange = Color(0xFFFF6D00);
  static const Color neonPink   = Color(0xFFFF4081);

  // Text
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF90A4AE);
  static const Color textMuted     = Color(0xFF546E7A);

  // Metal
  static const Color gold   = Color(0xFFFFD700);
  static const Color silver = Color(0xFF9E9E9E);
  static const Color bronze = Color(0xFFCD7F32);

  // Extended metal
  static const Color goldDark   = Color(0xFFB8860B);
  static const Color goldDeep   = Color(0xFF3D2400);
  static const Color goldLight  = Color(0xFFFFF4C2);
  static const Color goldBgDark = Color(0xFF1A0F00);
  static const Color goldBgMid  = Color(0xFF2A1800);
  static const Color silverDark  = Color(0xFF6B6B6B);
  static const Color silverMid   = Color(0xFFB0B0B0);
  static const Color silverLight = Color(0xFFE8E8E8);
  static const Color silverBg    = Color(0xFF1A1A1A);
  static const Color bronzeDark  = Color(0xFF6B3A1F);
  static const Color bronzeMid   = Color(0xFFCD7F32);
  static const Color bronzeLight = Color(0xFFEDA96A);
  static const Color bronzeBg    = Color(0xFF2A0F00);

  // Glass
  static const Color glassBorder    = Color(0x1AFFFFFF);
  static const Color glassHighlight = Color(0x08FFFFFF);

  static const Color white      = Color(0xFFFFFFFF);

  static const Color blueDeep = Color(0xFF0D1B4E);
  static const Color blueMid  = Color(0xFF1B4FD8);
  static const Color blueBright = Color(0xFF1440B8);
  static const Color purpleDeep = Color(0xFF1a0a2e);
  static const Color purpleMid  = Color(0xFF2d1b5e);
  static const Color orangeDeep  = Color(0xFF7C2D12);
  static const Color orangeBright = Color(0xFFC2410C);

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldDeep, goldBgDark, goldBgMid],
  );

  static const LinearGradient goldHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldDeep, gold, goldLight],
  );

  static const LinearGradient goldRibbonGradient = LinearGradient(
    colors: [goldDark, neonGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blueDeep, blueMid],
  );

  static const LinearGradient blueHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blueDeep, blueMid, blueBright],
  );

  static const LinearGradient blueDeepHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1B4E), Color(0xFF2d1b5e)],
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [orangeDeep, orangeBright],
  );

  static const LinearGradient orangeHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [orangeDeep, orangeBright, Color(0xFFF97316)],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [purpleDeep, purpleMid],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgCard, bg],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x12FFFFFF), Color(0x06FFFFFF)],
  );

  static LinearGradient shimmerGradient({Color color = goldLight}) => LinearGradient(
    colors: [Colors.transparent, color, Colors.transparent],
  );

  static LinearGradient dividerGradient({Color color = neonGold, double opacity = 0.25}) => LinearGradient(
    colors: [Colors.transparent, color.withOpacity(opacity), Colors.transparent],
  );

  static List<List<Color>> get podiumGradientColors => [
    [goldDeep, neonGold, goldLight],
    [silverBg, silverMid, silverLight],
    [bronzeBg, bronzeMid, bronzeLight],
  ];

  static List<Color> get podiumGlowColors => [neonGold, silverMid, bronzeMid];
  static List<Color> get podiumBadgeColors => [neonGold, Color(0xFFC0C0C0), bronzeMid];

  static const double opacity4  = 0.04;
  static const double opacity5  = 0.05;
  static const double opacity6  = 0.06;
  static const double opacity7  = 0.07;
  static const double opacity8  = 0.08;
  static const double opacity10 = 0.10;
  static const double opacity12 = 0.12;
  static const double opacity15 = 0.15;
  static const double opacity18 = 0.18;
  static const double opacity20 = 0.20;
  static const double opacity25 = 0.25;
  static const double opacity30 = 0.30;
  static const double opacity35 = 0.35;
  static const double opacity40 = 0.40;
  static const double opacity45 = 0.45;
  static const double opacity50 = 0.50;
  static const double opacity55 = 0.55;
  static const double opacity60 = 0.60;
  static const double opacity80 = 0.80;
  static const double opacity90 = 0.90;
}

Color playerColor(String name) {
  final colors = [
    const Color(0xFF3B82F6), const Color(0xFFEF4444), const Color(0xFFF59E0B),
    const Color(0xFF10B981), const Color(0xFF8B5CF6), const Color(0xFFEC4899), const Color(0xFF06B6D4),
  ];
  return colors[name.codeUnitAt(0) % colors.length];
}
