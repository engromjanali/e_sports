import 'package:e_sports/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String label; final bool active; final VoidCallback onTap; final Color color;
  const FilterChipWidget({required this.label, required this.active, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: AppSpacing.chipPadding,
      decoration: BoxDecoration(
        color: active ? color.withOpacity(AppColors.opacity15) : Colors.transparent,
        borderRadius: AppRadius.borderPill,
        border: Border.all(color: active ? color : AppColors.glassBorder),
        boxShadow: active ? AppElevation.subtleGlow(color) : AppElevation.none,
      ),
      child: Text(label, style: TextStyle(
        color: active ? color : AppColors.textMuted,
        fontSize: AppTypography.sizeBody,
        fontWeight: AppTypography.bold,
      )),
    ),
  );
}
