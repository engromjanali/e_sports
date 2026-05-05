import 'package:flutter/material.dart';
import 'package:e_sports/core/utils/dimensions.dart';

class FilterChipGroup extends StatelessWidget {
  final List<String> options;
  final String selected;
  final Function(String) onSelected;

  const FilterChipGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.xs + 1),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: Dimensions.borderMd + const BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        children: options.map((opt) {
          final isSelected = selected == opt.toLowerCase();
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(opt.toLowerCase()),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: Dimensions.md + 1),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.bgCard : Colors.transparent,
                  borderRadius: Dimensions.borderDef,
                  border: isSelected ? Border.all(color: AppColors.glassBorder) : null,
                  boxShadow: isSelected
                      ? [BoxShadow(color: AppColors.neonGold.withOpacity(AppColors.opacity6), blurRadius: 8)]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  opt.toUpperCase(),
                  style: TextStyle(
                    fontSize: Dimensions.sizeCaption,
                    fontWeight: Dimensions.extraBold,
                    color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
                    letterSpacing: Dimensions.trackingWider,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
