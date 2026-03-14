import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/main.dart';
import 'package:flutter/material.dart';

class NeonProgressBarWidget extends StatelessWidget {
  final double value;
  final double max;
  final Color color;
  final double height;

  const NeonProgressBarWidget({
    super.key,
    required this.value,
    required this.max,
    this.color = AppColors.neonGold,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (value / max).clamp(0.0, 1.0);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: pct),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(height),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: v,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height),
                gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6, spreadRadius: 1)],
              ),
            ),
          ),
        );
      },
    );
  }
}
