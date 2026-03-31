import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/core/controllers/app_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRankCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appData = Get.find<AppDataController>();
      if (appData.rankedPlayers.isEmpty) return const SizedBox.shrink();
      
      final me = appData.rankedPlayers.first; // Default authenticated player
      String wlabel = "${me.rank}";
      
      return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.borderXl,
        gradient: AppColors.goldGradient,
        border: Border.all(color: AppColors.neonGold.withOpacity(0.28), width: AppSizing.borderThin),
        boxShadow: AppElevation.accentGlow(AppColors.neonGold, opacity: 0.16, blur: 22, offset: const Offset(0, 7)),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.borderXl,
        child: Stack(
          children: [
            // Shimmer top bar
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: AppSizing.shimmerHeight,
                decoration: BoxDecoration(
                  gradient: AppColors.shimmerGradient(color: AppColors.goldLight),
                ),
              ),
            ),

            // Giant ghost rank number
            Positioned(
              right: 0, top: 10,
              child: SizedBox(
                width: 300,
                child: Text(
                  "#$wlabel",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: wlabel.length > 5 ? 60 : 80,
                    fontWeight: AppTypography.black,
                    color: AppColors.neonGold.withOpacity(AppColors.opacity7),
                    height: AppTypography.lineHeightCompact,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(AppSpacing.xxxl),
              child: Column(
                children: [
                  // Top row: avatar left, rank center, tier right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Network Avatar
                      Container(
                        width: AppSizing.avatarLg,
                        height: AppSizing.avatarLg,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.neonGold, width: AppSizing.borderAvatar),
                          boxShadow: AppElevation.ringGlow(AppColors.neonGold, opacity: AppColors.opacity40),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            "https://i.pravatar.cc/150?img=8",
                            width: AppSizing.avatarLg,
                            height: AppSizing.avatarLg,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.goldDeep,
                              alignment: Alignment.center,
                              child: Text("A",
                                  style: TextStyle(
                                    fontSize: AppTypography.sizeDisplay - 2,
                                    fontWeight: AppTypography.black,
                                    color: AppColors.neonGold,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.xxl),

                      // Name + handle + badges
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              me.name,
                              style: TextStyle(
                                fontSize: AppTypography.sizeTitleLarge,
                                fontWeight: AppTypography.black,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              "@${me.short.toLowerCase()}",
                              style: TextStyle(
                                fontSize: AppTypography.sizeSmall,
                                color: AppColors.white.withOpacity(AppColors.opacity40),
                                letterSpacing: AppTypography.trackingTight,
                              ),
                            ),
                            SizedBox(height: AppSizing.dotLg),
                            Row(
                              children: [
                                // Ribbon rank badge
                                ClipRRect(
                                  borderRadius: AppRadius.ribbonLeft,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                      AppSpacing.md, AppSpacing.xs,
                                      AppSpacing.md, AppSpacing.xs + 1,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.goldRibbonGradient,
                                    ),
                                    child: Text(
                                      "RANK #1",
                                      style: TextStyle(
                                        fontSize: AppTypography.sizeTiny,
                                        fontWeight: AppTypography.black,
                                        letterSpacing: 1.4,
                                        color: AppColors.goldDeep,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppSpacing.iconGap),
                                // Elite ghost pill
                                Container(
                                  padding: AppSpacing.pillPadding,
                                  decoration: BoxDecoration(
                                    color: AppColors.neonGold.withOpacity(AppColors.opacity10),
                                    borderRadius: AppRadius.borderSm,
                                    border: Border.all(
                                      color: AppColors.neonGold.withOpacity(AppColors.opacity35),
                                      width: AppSizing.borderThin,
                                    ),
                                  ),
                                  child: Text(
                                    "ELITE GAMER",
                                    style: AppTypography.pillLabel(context,
                                      color: AppColors.goldLight.withOpacity(AppColors.opacity90),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.xxl),

                  // Gold divider
                  Container(
                    height: AppSizing.dividerHeight,
                    decoration: BoxDecoration(
                      gradient: AppColors.dividerGradient(color: AppColors.neonGold, opacity: AppColors.opacity25),
                    ),
                  ),

                  SizedBox(height: AppSpacing.xxl),

                  // Stat chips row
                  Row(
                    children: [
                      _StatChip(label: "PTS", value: "${me.pts}"),
                      SizedBox(width: AppSpacing.md),
                      _StatChip(label: "GOALS", value: "${me.goals}"),
                      SizedBox(width: AppSpacing.md),
                      _StatChip(label: "WINS", value: "${me.wins}"),
                      SizedBox(width: AppSpacing.md),
                      _StatChip(label: "MATCHES", value: "${me.matches}"),
                    ],
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
    });
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.neonGold.withOpacity(AppColors.opacity7),
          borderRadius: AppRadius.borderDef,
          border: Border.all(
            color: AppColors.neonGold.withOpacity(0.22),
            width: AppSizing.borderThin,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.statValue(context),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelUppercase(context),
            ),
          ],
        ),
      ),
    );
  }
}
