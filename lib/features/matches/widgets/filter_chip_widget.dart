import 'package:e_sports/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String label; final bool active; final VoidCallback onTap; final Color color;
  const FilterChipWidget({required this.label, required this.active, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: Dimensions.chipPadding,
      decoration: BoxDecoration(
        color: active ? color.withOpacity(AppColors.opacity15) : Colors.transparent,
        borderRadius: Dimensions.borderPill,
        border: Border.all(color: active ? color : AppColors.glassBorder),
        boxShadow: active ? Dimensions.subtleGlow(color) : Dimensions.none,
      ),
      child: Text(label, style: TextStyle(
        color: active ? color : AppColors.textMuted,
        fontSize: Dimensions.sizeBody,
        fontWeight: Dimensions.bold,
      )),
    ),
  );
}
