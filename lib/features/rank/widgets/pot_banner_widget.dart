import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:flutter/material.dart';

class PotBannerWidget extends StatelessWidget {
  final ComputedPlayerStats player;
  final String label;
  final String badge;
  final Gradient gradient;

  const PotBannerWidget({
    required this.player,
    required this.label,
    required this.gradient,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = player.player.imageUrl;

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.borderXl,
        gradient: AppColors.goldGradient,
        border: Border.all(
          color: AppColors.neonGold.withOpacity(0.28),
          width: AppSizing.borderThin,
        ),
        boxShadow: AppElevation.accentGlow(AppColors.neonGold, opacity: AppColors.opacity15, blur: 20, offset: const Offset(0, 6)),
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

            // Ghost watermark
            Positioned(
              right: 2, top: 2,
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: AppTypography.sizeWatermark,
                  color: AppColors.neonGold.withOpacity(0.05),
                  height: AppTypography.lineHeightCompact,
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(AppSpacing.xxxl),
              child: Column(
                children: [
                  // Top: avatar + info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: AppSizing.avatarXl,
                            height: AppSizing.avatarXl,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.neonGold, width: AppSizing.borderAvatar),
                              boxShadow: AppElevation.ringGlow(AppColors.neonGold, opacity: 0.42),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                imageUrl,
                                width: AppSizing.avatarXl,
                                height: AppSizing.avatarXl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.goldDeep,
                                  alignment: Alignment.center,
                                  child: Text(
                                    player.name.isNotEmpty
                                        ? player.name[0].toUpperCase()
                                        : "?",
                                    style: TextStyle(
                                      fontSize: AppTypography.sizeDisplay - 2,
                                      fontWeight: AppTypography.black,
                                      color: AppColors.neonGold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: AppSpacing.xxl),

                      // Name + label + badges
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Label pill
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizing.dotLg,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.neonGold.withOpacity(AppColors.opacity10),
                                borderRadius: AppRadius.borderSm,
                                border: Border.all(
                                  color: AppColors.neonGold.withOpacity(AppColors.opacity35),
                                  width: AppSizing.borderThin,
                                ),
                              ),
                              child: Text(
                                label.toUpperCase(),
                                style: AppTypography.pillLabel(context, letterSpacing: AppTypography.trackingWidest),
                              ),
                            ),
                            SizedBox(height: AppSpacing.sm),

                            // Player name
                            Text(
                              player.name,
                              style: TextStyle(
                                fontSize: AppTypography.sizeTitleLarge,
                                fontWeight: AppTypography.black,
                                color: AppColors.white,
                              ),
                            ),

                            // Matches
                            Text(
                              "${player.matches} matches",
                              style: TextStyle(
                                fontSize: AppTypography.sizeSmall,
                                color: AppColors.white.withOpacity(AppColors.opacity40),
                                letterSpacing: AppTypography.trackingTight,
                              ),
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
                      gradient: AppColors.dividerGradient(color: AppColors.neonGold, opacity: 0.22),
                    ),
                  ),

                  SizedBox(height: AppSpacing.xl),

                  // Stat chips
                  Row(
                    children: [
                      _StatMiniWidget(
                          label: "Goals",
                          value: "${player.goals}",
                          color: AppColors.neonGold),
                      SizedBox(width: AppSpacing.md),
                      _StatMiniWidget(
                          label: "Points",
                          value: "${player.pts}",
                          color: AppColors.neonGold),
                      SizedBox(width: AppSpacing.md),
                      _StatMiniWidget(
                          label: "FA",
                          value: "${player.fa}",
                          color: AppColors.neonGold),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatMiniWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatMiniWidget({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.neonGold.withOpacity(AppColors.opacity7),
          borderRadius: AppRadius.borderDef,
          border: Border.all(
            color: AppColors.neonGold.withOpacity(AppColors.opacity20),
            width: AppSizing.borderThin,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.statValue(context, color: color),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              label.toUpperCase(),
              style: AppTypography.labelUppercase(context),
            ),
          ],
        ),
      ),
    );
  }
}