import 'package:e_sports/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SideBySideBarChart extends StatelessWidget {
  final String label;
  final num v1;
  final num v2;
  final num max;
  final Color color1;
  final Color color2;
  final bool isPercent;

  const SideBySideBarChart({
    super.key,
    required this.label,
    required this.v1,
    required this.v2,
    required this.max,
    this.color1 = AppColors.neonBlue,
    this.color2 = AppColors.neonRed,
    this.isPercent = false,
  });

  @override
  Widget build(BuildContext context) {
    final s1 = isPercent ? "${(v1 * 100).toStringAsFixed(1)}%" : "$v1";
    final s2 = isPercent ? "${(v2 * 100).toStringAsFixed(1)}%" : "$v2";

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), 
              style: TextStyle(color: AppColors.textMuted, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          SizedBox(height: AppSpacing.xs),
          _buildHorizontalBar(v1.toDouble(), max.toDouble(), color1, s1),
          SizedBox(height: 4),
          _buildHorizontalBar(v2.toDouble(), max.toDouble(), color2, s2),
        ],
      ),
    );
  }

  Widget _buildHorizontalBar(double value, double max, Color color, String label) {
    final widthFactor = (value / max).clamp(0.05, 1.0);
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: widthFactor,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.4)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(0.2), blurRadius: 4, spreadRadius: 1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: AppTypography.black)),
      ],
    );
  }
}

class CompareBarChartsColumn extends StatelessWidget {
  final double goalsPerMatch1;
  final double goalsPerMatch2;
  final double winRate1;
  final double winRate2;
  final double drawRate1;
  final double drawRate2;
  final double lossRate1;
  final double lossRate2;
  final double csRate1;
  final double csRate2;

  const CompareBarChartsColumn({
    super.key,
    required this.goalsPerMatch1,
    required this.goalsPerMatch2,
    required this.winRate1,
    required this.winRate2,
    required this.drawRate1,
    required this.drawRate2,
    required this.lossRate1,
    required this.lossRate2,
    required this.csRate1,
    required this.csRate2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SideBySideBarChart(label: "Win Rate", v1: winRate1, v2: winRate2, max: 1.0, isPercent: true),
        SideBySideBarChart(label: "Draw Rate", v1: drawRate1, v2: drawRate2, max: 1.0, isPercent: true),
        SideBySideBarChart(label: "Loss Rate", v1: lossRate1, v2: lossRate2, max: 1.0, isPercent: true),
        SideBySideBarChart(label: "Goals / M", v1: num.parse(goalsPerMatch1.toStringAsFixed(2)), v2: num.parse(goalsPerMatch2.toStringAsFixed(2)), max: 3.0),
        SideBySideBarChart(label: "CS Rate", v1: csRate1, v2: csRate2, max: 1.0, isPercent: true),
      ],
    );
  }
}
