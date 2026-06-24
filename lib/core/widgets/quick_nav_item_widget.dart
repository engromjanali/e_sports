import 'package:e_sports/core/utils/dimensions.dart';
import 'glass_card_widget.dart';
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
            vertical: Dimensions.body2,
            horizontal: Dimensions.xs + 1,
          ),
          borderColor: color.withOpacity(AppColors.opacity20),
          child: Column(children: [
            Container(
              width: Dimensions.quickNavIconSize,
              height: Dimensions.quickNavIconSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefValue + 1),
                color: color.withOpacity(AppColors.opacity12),
                border: Border.all(color: color.withOpacity(AppColors.opacity20)),
              ),
              alignment: Alignment.center,
              child: Text(icon, style: TextStyle(fontSize: Dimensions.sizeHeading)),
            ),
            SizedBox(height: Dimensions.sm),
            Text(label,
                style: TextStyle(
                    fontSize: Dimensions.sizeSmall,
                    fontWeight: Dimensions.bold,
                    color: AppColors.textPrimary)),
            Text(sub,
                style: TextStyle(
                  fontSize: Dimensions.sizeTiny,
                  color: AppColors.textMuted,
                )),
          ]),
        ),
      );
  }
}
