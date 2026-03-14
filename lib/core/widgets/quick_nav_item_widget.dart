import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

class QuickNavItem extends StatelessWidget {
  final String icon, label, sub;
  final Color color;
  final VoidCallback onTap;
  const QuickNavItem({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: GlassCardWidget(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
          borderColor: color.withOpacity(0.2),
          child: Column(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: color.withOpacity(0.12),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 5),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text(sub,
                style: const TextStyle(fontSize: 8, color: AppColors.textMuted)),
          ]),
        ),
      ),
    );
  }
}
