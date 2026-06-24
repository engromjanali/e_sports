import 'package:flutter/material.dart';
import 'package:e_sports/core/utils/dimensions.dart';

class SeasonFilterBar extends StatelessWidget {
  final String selected;
  final List<String> options;
  final Function(String) onSelected;

  const SeasonFilterBar({
    super.key,
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screenPadding),
      child: Row(
        children: options.map((opt) {
          final isSelected = selected.toLowerCase() == opt.toLowerCase();
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.md),
            child: GestureDetector(
              onTap: () => onSelected(opt.toLowerCase()),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.xl,
                  vertical: Dimensions.md,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.blueHeroGradient : null,
                  color: isSelected ? null : AppColors.bgSurface.withOpacity(AppColors.opacity40),
                  borderRadius: Dimensions.borderPill,
                  border: Border.all(
                    color: isSelected ? AppColors.neonBlue.withOpacity(AppColors.opacity40) : AppColors.glassBorder,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: AppColors.neonBlue.withOpacity(AppColors.opacity20),
                      blurRadius: 10,
                    )
                  ] : [],
                ),
                child: Text(
                  opt.toUpperCase(),
                  style: TextStyle(
                    fontSize: Dimensions.sizeCaption,
                    fontWeight: Dimensions.black,
                    color: isSelected ? AppColors.white : AppColors.textMuted,
                    letterSpacing: 1.2,
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
