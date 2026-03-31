import 'package:e_sports/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SectionHeadingWidget extends StatelessWidget {
  final String title;
  final String? sub;
  final VoidCallback? onAll;
  final Widget? trailing;

  const SectionHeadingWidget({
    super.key, 
    required this.title, 
    this.sub, 
    this.onAll,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(
                  fontSize: AppTypography.sizeTitle,
                  fontWeight: AppTypography.extraBold,
                  color: AppColors.textPrimary)),
              if (sub != null) Text(sub!, style: TextStyle(
                  fontSize: AppTypography.sizeSmall,
                  color: AppColors.textSecondary)),
            ],
          ),
          if (trailing != null)
            trailing!
          else if (onAll != null)
            GestureDetector(
              onTap: onAll,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs + 1,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neonBlue.withOpacity(AppColors.opacity10),
                  borderRadius: AppRadius.borderPill,
                  border: Border.all(color: AppColors.neonBlue.withOpacity(AppColors.opacity25)),
                ),
                child: Text("View All →",
                    style: TextStyle(
                      color: AppColors.neonBlue,
                      fontSize: AppTypography.sizeBody2,
                      fontWeight: AppTypography.bold,
                    )),
              ),
            ),
        ],
      ),
    );
  }
}
