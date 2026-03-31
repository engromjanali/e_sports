import 'package:e_sports/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class GetRewardsCta extends StatelessWidget {
  final VoidCallback onTap;
  const GetRewardsCta({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.huge),
        decoration: BoxDecoration(
          gradient: AppColors.purpleGradient,
          borderRadius: AppRadius.borderXl,
          border: Border.all(color: AppColors.neonPurple.withOpacity(AppColors.opacity25)),
          boxShadow: AppElevation.accentGlow(AppColors.neonPurple, opacity: AppColors.opacity15, blur: 20),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("GET REWARDS",
                style: TextStyle(
                    fontSize: AppTypography.sizeCaption,
                    fontWeight: AppTypography.extraBold,
                    color: AppColors.neonGold,
                    letterSpacing: AppTypography.trackingWidest)),
            SizedBox(height: AppSpacing.xs),
            Text("Unlock Badges & Trophies",
                style: TextStyle(
                    fontSize: AppTypography.sizeTitleLarge,
                    fontWeight: AppTypography.black,
                    color: AppColors.white)),
            SizedBox(height: AppSpacing.lg),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.huge,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.neonPurple.withOpacity(AppColors.opacity80),
                borderRadius: AppRadius.borderDef,
                boxShadow: AppElevation.subtleGlow(AppColors.neonPurple, opacity: AppColors.opacity40, blur: 12),
              ),
              child: Text("Claim Now →",
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppTypography.sizeBody,
                      fontWeight: AppTypography.bold)),
            ),
          ]),
          Text("🏆", style: TextStyle(fontSize: AppSizing.iconEmoji)),
        ]),
      ),
    );
  }
}
