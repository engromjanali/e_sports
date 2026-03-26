import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class YearFilterWidget extends StatelessWidget {
  final String selected;
  final List<String> options;
  final Function(String) onSelected;

  const YearFilterWidget({
    super.key,
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppRadius.borderPill,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final isSelected = selected == opt.toLowerCase();
          return GestureDetector(
            onTap: () => onSelected(opt.toLowerCase()),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs + 1,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.neonBlue.withOpacity(AppColors.opacity15) : Colors.transparent,
                borderRadius: AppRadius.borderPill,
                border: isSelected ? Border.all(color: AppColors.neonBlue.withOpacity(AppColors.opacity30)) : null,
              ),
              child: Text(
                opt.toUpperCase(),
                style: TextStyle(
                  fontSize: 9, // Extra small for header placement
                  fontWeight: AppTypography.extraBold,
                  color: isSelected ? AppColors.neonBlue : AppColors.textMuted,
                  letterSpacing: AppTypography.trackingWider,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
