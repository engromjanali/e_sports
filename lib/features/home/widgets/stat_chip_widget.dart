import 'package:e_sports/core/utils/dimensions.dart';
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
          vertical: Dimensions.sm + 1,
          horizontal: Dimensions.xs + 1,
        ),
        decoration: BoxDecoration(
          color: highlight
              ? AppColors.neonGold.withOpacity(AppColors.opacity15)
              : AppColors.white.withOpacity(AppColors.opacity7),
          borderRadius: Dimensions.borderMd,
          border: Border.all(
            color: highlight
                ? AppColors.neonGold.withOpacity(AppColors.opacity35)
                : AppColors.white.withOpacity(AppColors.opacity8),
            width: Dimensions.borderThin,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: Dimensions.sizeBody2,
                fontWeight: Dimensions.black,
                color: color,
              ),
            ),
            SizedBox(height: Dimensions.xxs / 2),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.sizeOverSmall,
                fontWeight: Dimensions.bold,
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
