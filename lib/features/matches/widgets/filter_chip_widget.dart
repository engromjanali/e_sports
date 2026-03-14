import 'package:e_sports/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String label; final bool active; final VoidCallback onTap; final Color color;
  const FilterChipWidget({required this.label, required this.active, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? color : AppColors.glassBorder),
        boxShadow: active ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8)] : [],
      ),
      child: Text(label, style: TextStyle(
        color: active ? color : AppColors.textMuted,
        fontSize: 12, fontWeight: FontWeight.w700,
      )),
    ),
  );
}
