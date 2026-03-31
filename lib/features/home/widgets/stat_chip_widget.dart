import 'package:e_sports/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StatChipWidget extends StatelessWidget {
  final String label, value;
  final Color color;
  final bool highlight;

  const StatChipWidget({
    required this.label,
    required this.value,
    required this.color,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.sm + 1,
          horizontal: AppSpacing.xs + 1,
        ),
        decoration: BoxDecoration(
          color: highlight
              ? AppColors.neonGold.withOpacity(AppColors.opacity15)
              : AppColors.white.withOpacity(AppColors.opacity7),
          borderRadius: AppRadius.borderMd,
          border: Border.all(
            color: highlight
                ? AppColors.neonGold.withOpacity(AppColors.opacity35)
                : AppColors.white.withOpacity(AppColors.opacity8),
            width: AppSizing.borderThin,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: AppTypography.sizeBody2,
                fontWeight: AppTypography.black,
                color: color,
              ),
            ),
            SizedBox(height: AppSpacing.xxs / 2),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTypography.sizeOverSmall,
                fontWeight: AppTypography.bold,
                color: AppColors.white.withOpacity(AppColors.opacity40),
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
