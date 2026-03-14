import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color bg         = Color(0xFF080D1A);
  static const Color bgCard     = Color(0xFF0C1425);
  static const Color bgSurface  = Color(0xFF111A30);
  static const Color bgGlass    = Color(0x0AFFFFFF);

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

  // Glass
  static const Color glassBorder    = Color(0x1AFFFFFF);
  static const Color glassHighlight = Color(0x08FFFFFF);

  static const Color white      = Color(0xFFFFFFFF);

}

Color playerColor(String name) {
  final colors = [
    const Color(0xFF3B82F6), const Color(0xFFEF4444), const Color(0xFFF59E0B),
    const Color(0xFF10B981), const Color(0xFF8B5CF6), const Color(0xFFEC4899), const Color(0xFF06B6D4),
  ];
  return colors[name.codeUnitAt(0) % colors.length];
}