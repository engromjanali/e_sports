import 'package:e_sports/core/utils/dimensions.dart';
import '../../../core/data/models/computed_player_stats.dart';
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
        borderRadius: Dimensions.borderXl,
        gradient: AppColors.goldGradient,
        border: Border.all(
          color: AppColors.neonGold.withOpacity(0.28),
          width: Dimensions.borderThin,
        ),
        boxShadow: Dimensions.accentGlow(AppColors.neonGold, opacity: AppColors.opacity15, blur: 20, offset: const Offset(0, 6)),
      ),
      child: ClipRRect(
        borderRadius: Dimensions.borderXl,
        child: Stack(
          children: [
            // Shimmer top bar
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: Dimensions.shimmerHeight,
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
                  fontSize: Dimensions.sizeWatermark,
                  color: AppColors.neonGold.withOpacity(0.05),
                  height: Dimensions.lineHeightCompact,
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(Dimensions.xxxl),
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
                            width: Dimensions.avatarXl,
                            height: Dimensions.avatarXl,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.neonGold, width: Dimensions.borderAvatar),
                              boxShadow: Dimensions.ringGlow(AppColors.neonGold, opacity: 0.42),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                imageUrl,
                                width: Dimensions.avatarXl,
                                height: Dimensions.avatarXl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.goldDeep,
                                  alignment: Alignment.center,
                                  child: Text(
                                    player.name.isNotEmpty
                                        ? player.name[0].toUpperCase()
                                        : "?",
                                    style: TextStyle(
                                      fontSize: Dimensions.sizeDisplay - 2,
                                      fontWeight: Dimensions.black,
                                      color: AppColors.neonGold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: Dimensions.xxl),

                      // Name + label + badges
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Label pill
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.dotLg,
                                vertical: Dimensions.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.neonGold.withOpacity(AppColors.opacity10),
                                borderRadius: Dimensions.borderSm,
                                border: Border.all(
                                  color: AppColors.neonGold.withOpacity(AppColors.opacity35),
                                  width: Dimensions.borderThin,
                                ),
                              ),
                              child: Text(
                                label.toUpperCase(),
                                style: Dimensions.pillLabel(context, letterSpacing: Dimensions.trackingWidest),
                              ),
                            ),
                            SizedBox(height: Dimensions.sm),

                            // Player name
                            Text(
                              player.name,
                              style: TextStyle(
                                fontSize: Dimensions.sizeTitleLarge,
                                fontWeight: Dimensions.black,
                                color: AppColors.white,
                              ),
                            ),

                            // Matches
                            Text(
                              "${player.matches} matches",
                              style: TextStyle(
                                fontSize: Dimensions.sizeSmall,
                                color: AppColors.white.withOpacity(AppColors.opacity40),
                                letterSpacing: Dimensions.trackingTight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.xxl),

                  // Gold divider
                  Container(
                    height: Dimensions.dividerHeight,
                    decoration: BoxDecoration(
                      gradient: AppColors.dividerGradient(color: AppColors.neonGold, opacity: 0.22),
                    ),
                  ),

                  SizedBox(height: Dimensions.xl),

                  // Stat chips
                  Row(
                    children: [
                      _StatMiniWidget(
                          label: "Goals",
                          value: "${player.goals}",
                          color: AppColors.neonGold),
                      SizedBox(width: Dimensions.md),
                      _StatMiniWidget(
                          label: "Points",
                          value: "${player.pts}",
                          color: AppColors.neonGold),
                      SizedBox(width: Dimensions.md),
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
        padding: EdgeInsets.symmetric(vertical: Dimensions.md),
        decoration: BoxDecoration(
          color: AppColors.neonGold.withOpacity(AppColors.opacity7),
          borderRadius: Dimensions.borderDef,
          border: Border.all(
            color: AppColors.neonGold.withOpacity(AppColors.opacity20),
            width: Dimensions.borderThin,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Dimensions.statValue(context, color: color),
            ),
            SizedBox(height: Dimensions.xs),
            Text(
              label.toUpperCase(),
              style: Dimensions.labelUppercase(context),
            ),
          ],
        ),
      ),
    );
  }
}