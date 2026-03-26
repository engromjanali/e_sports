import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:e_sports/core/widgets/player_tags_widget.dart';
import 'package:flutter/material.dart';


class SpotlightCardWidget extends StatelessWidget {
  final ComputedPlayerStats player;
  final String label;
  final String badge;
  final Gradient gradient;

  const SpotlightCardWidget({
    required this.player,
    required this.label,
    required this.badge,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = "https://i.pravatar.cc/150?img=15";

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: AppColors.neonGold.withOpacity(0.32),
          width: AppSizing.borderThin,
        ),
        boxShadow: AppElevation.accentGlow(AppColors.neonGold, opacity: 0.14),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.borderXl,
        child: Stack(
          children: [
            // ── Shimmer top bar
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: AppSizing.shimmerHeight,
                decoration: BoxDecoration(
                  gradient: AppColors.shimmerGradient(color: AppColors.goldLight),
                ),
              ),
            ),

            // ── Watermark label
            Positioned(
              right: 2, bottom: 0, top: 2,
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: AppTypography.black,
                  color: AppColors.neonGold.withOpacity(AppColors.opacity8),
                  height: AppTypography.lineHeightCompact,
                  letterSpacing: AppTypography.trackingUltra,
                ),
              ),
            ),

            // ── Main content
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.cardInnerPadding - 1,
                AppSpacing.cardInnerPadding,
                AppSpacing.cardInnerPadding - 1,
                AppSpacing.cardInnerPadding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Left: avatar + name + matches
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label pill
                      Container(
                        padding: AppSpacing.pillPadding,
                        decoration: BoxDecoration(
                          color: AppColors.neonGold.withOpacity(AppColors.opacity12),
                          borderRadius: AppRadius.borderSm,
                          border: Border.all(
                            color: AppColors.neonGold.withOpacity(AppColors.opacity35),
                            width: AppSizing.borderThin,
                          ),
                        ),
                        child: Text(
                          label.toUpperCase(),
                          style: AppTypography.pillLabel(context),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),

                      // Avatar with badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: AppSizing.avatarXxl,
                            height: AppSizing.avatarXxl,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.neonGold,
                                width: AppSizing.borderAvatar,
                              ),
                              boxShadow: AppElevation.ringGlow(AppColors.neonGold),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                imageUrl,
                                width: AppSizing.avatarXxl,
                                height: AppSizing.avatarXxl,
                                fit: BoxFit.cover,
                                loadingBuilder: (ctx, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    color: AppColors.goldDeep.withOpacity(0.5),
                                    child: Center(
                                      child: SizedBox(
                                        width: AppSpacing.massive,
                                        height: AppSpacing.massive,
                                        child: CircularProgressIndicator(
                                          strokeWidth: AppSizing.borderThick,
                                          color: AppColors.neonGold,
                                          value: progress.expectedTotalBytes != null
                                              ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.goldDeep.withOpacity(0.5),
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

                          // Badge — corner ribbon style
                          Positioned(
                            top: -2, right: -2,
                            child: ClipRRect(
                              borderRadius: AppRadius.ribbonTopRight,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                  AppSpacing.sm, AppSpacing.xxs, AppSpacing.sm, AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldRibbonGradient,
                                ),
                                child: Text(
                                  badge,
                                  style: TextStyle(fontSize: AppTypography.sizeSmall),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.lg),

                      // Name
                      Text(
                        player.short,
                        style: TextStyle(
                          fontSize: AppTypography.sizeSubtitle,
                          fontWeight: AppTypography.black,
                          color: AppColors.white,
                          height: AppTypography.lineHeightNormal,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      
                      // Dynamic Tags
                      PlayerTagsWidget(
                        tags: player.tags,
                        accentColor: AppColors.neonGold,
                      ),
                      
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        "${player.matches} matches",
                        style: TextStyle(
                          fontSize: AppTypography.sizeBody,
                          color: AppColors.white.withOpacity(AppColors.opacity45),
                          letterSpacing: AppTypography.trackingTight + 0.1,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: AppSpacing.xxl),

                  // ── Right: vertical stats
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppSpacing.xxxl * 2),
                        _StatRow(
                          label: "Goals",
                          value: "${player.goals}",
                          accentColor: AppColors.neonGold,
                          fillFraction: (player.goals / 20).clamp(0.0, 1.0),
                        ),
                        SizedBox(height: AppSpacing.md),
                        _StatRow(
                          label: "Points",
                          value: "${player.pts}",
                          accentColor: AppColors.neonGold,
                          fillFraction: (player.pts / 100).clamp(0.0, 1.0),
                        ),
                        SizedBox(height: AppSpacing.md),
                        _StatRow(
                          label: "Win",
                          value: "${player.wins}",
                          accentColor: AppColors.neonGold,
                          fillFraction: (player.wins / 10).clamp(0.0, 1.0),
                        ),
                      ],
                    ),
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


class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;
  final double fillFraction;

  const _StatRow({
    required this.label,
    required this.value,
    required this.accentColor,
    required this.fillFraction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.caption, AppSpacing.micro, AppSpacing.caption, AppSpacing.micro,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(AppColors.opacity4),
        borderRadius: AppRadius.borderDef,
        border: Border.all(
          color: accentColor.withOpacity(AppColors.opacity18),
          width: AppSizing.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: AppTypography.labelUppercase(context, color: AppColors.white.withOpacity(AppColors.opacity45)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppTypography.sizeBodyLarge,
                  fontWeight: AppTypography.black,
                  color: accentColor,
                  height: AppTypography.lineHeightCompact,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          // Progress bar
          ClipRRect(
            borderRadius: AppRadius.borderXs,
            child: Stack(
              children: [
                Container(
                  height: AppSizing.progressBarSm,
                  color: AppColors.white.withOpacity(AppColors.opacity8),
                ),
                FractionallySizedBox(
                  widthFactor: fillFraction,
                  child: Container(
                    height: AppSizing.progressBarSm,
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.borderXs,
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(AppColors.opacity60),
                          accentColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}