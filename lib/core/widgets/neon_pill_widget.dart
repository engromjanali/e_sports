import 'package:e_sports/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class NeonPillWidget extends StatelessWidget {
  final String label;
  final Color color;
  final double fontSize;

  const NeonPillWidget({super.key, required this.label, this.color = AppColors.neonGold, this.fontSize = 9});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w800),
      ),
    );
  }
}
