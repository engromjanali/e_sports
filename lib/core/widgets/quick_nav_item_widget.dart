import 'package:e_sports/core/theme/app_theme.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: GlassCardWidget(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.body2,
            horizontal: AppSpacing.xs + 1,
          ),
          borderColor: color.withOpacity(AppColors.opacity20),
          child: Column(children: [
            Container(
              width: AppSizing.quickNavIconSize,
              height: AppSizing.quickNavIconSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.def + 1),
                color: color.withOpacity(AppColors.opacity12),
                border: Border.all(color: color.withOpacity(AppColors.opacity20)),
              ),
              alignment: Alignment.center,
              child: Text(icon, style: TextStyle(fontSize: AppTypography.sizeHeading)),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(label,
                style: TextStyle(
                    fontSize: AppTypography.sizeSmall,
                    fontWeight: AppTypography.bold,
                    color: AppColors.textPrimary)),
            Text(sub,
                style: TextStyle(
                  fontSize: AppTypography.sizeTiny,
                  color: AppColors.textMuted,
                )),
          ]),
        ),
      );
  }
}
