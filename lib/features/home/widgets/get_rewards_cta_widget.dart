import 'package:e_sports/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class GetRewardsCta extends StatelessWidget {
  final VoidCallback onTap;
  const GetRewardsCta({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimensions.huge),
        decoration: BoxDecoration(
          gradient: AppColors.purpleGradient,
          borderRadius: Dimensions.borderXl,
          border: Border.all(color: AppColors.neonPurple.withOpacity(AppColors.opacity25)),
          boxShadow: Dimensions.accentGlow(AppColors.neonPurple, opacity: AppColors.opacity15, blur: 20),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("GET REWARDS",
                style: TextStyle(
                    fontSize: Dimensions.sizeCaption,
                    fontWeight: Dimensions.extraBold,
                    color: AppColors.neonGold,
                    letterSpacing: Dimensions.trackingWidest)),
            SizedBox(height: Dimensions.xs),
            Text("Unlock Badges & Trophies",
                style: TextStyle(
                    fontSize: Dimensions.sizeTitleLarge,
                    fontWeight: Dimensions.black,
                    color: AppColors.white)),
            SizedBox(height: Dimensions.lg),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.huge,
                vertical: Dimensions.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.neonPurple.withOpacity(AppColors.opacity80),
                borderRadius: Dimensions.borderDef,
                boxShadow: Dimensions.subtleGlow(AppColors.neonPurple, opacity: AppColors.opacity40, blur: 12),
              ),
              child: Text("Claim Now →",
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: Dimensions.sizeBody,
                      fontWeight: Dimensions.bold)),
            ),
          ]),
          Text("🏆", style: TextStyle(fontSize: Dimensions.iconEmoji)),
        ]),
      ),
    );
  }
}
