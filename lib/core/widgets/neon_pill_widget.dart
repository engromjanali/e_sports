import 'package:e_sports/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class NeonPillWidget extends StatelessWidget {
  final String label;
  final Color color;
  final double fontSize;

  const NeonPillWidget({
    super.key,
    required this.label,
    this.color = AppColors.neonGold,
    this.fontSize = Dimensions.sizeCaption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Dimensions.pillPadding,
      decoration: BoxDecoration(
        color: color.withOpacity(AppColors.opacity12),
        borderRadius: Dimensions.borderPill,
        border: Border.all(color: color.withOpacity(AppColors.opacity30)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: Dimensions.extraBold,
        ),
      ),
    );
  }
}
