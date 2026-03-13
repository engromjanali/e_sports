import 'package:e_sports/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BrandTitleWidget extends StatelessWidget {
  final String highlightText;
  final String primaryText;
  final String subtitle;
  final Color highlightColor;
  final double fontSize;

  const BrandTitleWidget({
    required this.highlightText,
    required this.primaryText,
    required this.subtitle,
    this.highlightColor = AppColors.neonCyan,
    this.fontSize = 19,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: highlightText,
                style: TextStyle(
                  color: highlightColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: primaryText,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}