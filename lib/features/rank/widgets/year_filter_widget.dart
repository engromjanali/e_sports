import 'package:flutter/material.dart';
import 'package:e_sports/core/utils/dimensions.dart';

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
      padding: EdgeInsets.all(Dimensions.xs),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: Dimensions.borderPill,
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
                horizontal: Dimensions.md,
                vertical: Dimensions.xs + 1,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.neonBlue.withOpacity(AppColors.opacity15) : Colors.transparent,
                borderRadius: Dimensions.borderPill,
                border: isSelected ? Border.all(color: AppColors.neonBlue.withOpacity(AppColors.opacity30)) : null,
              ),
              child: Text(
                opt.toUpperCase(),
                style: TextStyle(
                  fontSize: 9, // Extra small for header placement
                  fontWeight: Dimensions.extraBold,
                  color: isSelected ? AppColors.neonBlue : AppColors.textMuted,
                  letterSpacing: Dimensions.trackingWider,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
