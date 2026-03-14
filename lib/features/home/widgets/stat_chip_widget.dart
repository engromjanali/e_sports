import 'package:e_sports/core/constants/app_colors.dart';
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
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: highlight
              ? AppColors.neonGold.withOpacity(0.15)
              : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: highlight
                ? AppColors.neonGold.withOpacity(0.35)
                : Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                fontSize: 6.5,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.4),
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
