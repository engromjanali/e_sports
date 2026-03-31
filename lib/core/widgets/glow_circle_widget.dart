import 'package:e_sports/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GlowCircleWidget extends StatelessWidget {
  final double size;
  final Color color;

  const GlowCircleWidget({super.key, required this.size, this.color = AppColors.neonCyan});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [color, Colors.transparent],
      ),
    ),
  );
}
