import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

class PodiumCardTwo extends StatelessWidget {
  final List<ComputedPlayerStats> players;
  final String title;
  const PodiumCardTwo({required this.players, required this.title});

  @override
  Widget build(BuildContext context) {
    return GlassCardWidget(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.cardInnerPadding,
        AppSpacing.xxxl,
        AppSpacing.cardInnerPadding,
        AppSpacing.cardInnerPadding,
      ),
      borderColor: AppColors.neonGold.withOpacity(AppColors.opacity12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: AppSpacing.xs,
              height: AppSpacing.xxl,
              decoration: BoxDecoration(
                color: AppColors.neonGold,
                borderRadius: AppRadius.borderXxs,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Text(title.toUpperCase(),
                style: TextStyle(
                  fontSize: AppTypography.sizeSmall,
                  fontWeight: AppTypography.black,
                  letterSpacing: AppTypography.trackingMax,
                  color: AppColors.textPrimary,
                )),
          ]),
          SizedBox(height: AppSpacing.xxxl),
          Row(
            children: [
              Expanded(
                child: _RankBoxTwo(
                  player: players[0],
                  rank: 1,
                  rankLabel: "1ST",
                  gradientColors: [AppColors.goldDark, AppColors.neonGold, AppColors.goldLight],
                  glowColor: AppColors.neonGold,
                  badgeColor: AppColors.neonGold,
                  badgeIcon: Icons.emoji_events_rounded,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _RankBoxTwo(
                  player: players[1],
                  rank: 2,
                  rankLabel: "2ND",
                  gradientColors: [AppColors.silverDark, AppColors.silverMid, AppColors.silverLight],
                  glowColor: AppColors.silverMid,
                  badgeColor: AppColors.silverMid,
                  badgeIcon: Icons.military_tech_rounded,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _RankBoxTwo(
                  player: players[2],
                  rank: 3,
                  rankLabel: "3RD",
                  gradientColors: [AppColors.bronzeDark, AppColors.bronzeMid, AppColors.bronzeLight],
                  glowColor: AppColors.bronzeMid,
                  badgeColor: AppColors.bronzeMid,
                  badgeIcon: Icons.workspace_premium_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankBoxTwo extends StatelessWidget {
  final ComputedPlayerStats player;
  final int rank;
  final String rankLabel;
  final List<Color> gradientColors;
  final Color glowColor;
  final Color badgeColor;
  final IconData badgeIcon;

  const _RankBoxTwo({
    required this.player,
    required this.rank,
    required this.rankLabel,
    required this.gradientColors,
    required this.glowColor,
    required this.badgeColor,
    required this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    final avatarColor = playerColor(player.name);

    return Container(
      height: AppSizing.rankBoxHeight,
      decoration: BoxDecoration(
        borderRadius: AppRadius.borderLg,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientColors[0].withOpacity(AppColors.opacity35),
            gradientColors[1].withOpacity(AppColors.opacity15),
            Colors.transparent,
          ],
        ),
        border: Border.all(
          color: gradientColors[1].withOpacity(AppColors.opacity45),
          width: AppSizing.borderThin,
        ),
        boxShadow: AppElevation.accentGlow(glowColor, opacity: AppColors.opacity18, blur: 12, offset: const Offset(0, 3)),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.borderLg,
        child: Stack(
          children: [
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: AppSizing.shimmerThick,
                decoration: BoxDecoration(
                  gradient: AppColors.shimmerGradient(color: gradientColors[2].withOpacity(AppColors.opacity90)),
                ),
              ),
            ),
            Positioned(
              right: -4, bottom: -10,
              child: Text(
                rank.toString(),
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: AppTypography.black,
                  color: gradientColors[1].withOpacity(AppColors.opacity7),
                  height: AppTypography.lineHeightCompact,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(badgeIcon, color: badgeColor, size: AppSizing.iconLg),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.iconGap,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(AppColors.opacity18),
                          borderRadius: AppRadius.borderSm,
                          border: Border.all(
                            color: badgeColor.withOpacity(AppColors.opacity45),
                            width: AppSizing.borderThin,
                          ),
                        ),
                        child: Text(
                          rankLabel,
                          style: TextStyle(
                            fontSize: AppTypography.sizeCaption,
                            fontWeight: AppTypography.black,
                            letterSpacing: AppTypography.trackingWider,
                            color: gradientColors[2],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: AppSizing.avatarXs + 4,
                    height: AppSizing.avatarXs + 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: avatarColor.withOpacity(0.2),
                      border: Border.all(
                        color: gradientColors[1].withOpacity(AppColors.opacity60),
                        width: AppSizing.borderMedium,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        player.name.isNotEmpty ? player.name[0].toUpperCase() : "?",
                        style: TextStyle(
                          fontSize: AppTypography.sizeTitle,
                          fontWeight: AppTypography.extraBold,
                          color: gradientColors[2],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        player.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppTypography.sizeBody2,
                          fontWeight: AppTypography.bold,
                          color: gradientColors[2],
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxs),
                      Text(
                        "${player.goals} goals",
                        style: TextStyle(
                          fontSize: AppTypography.sizeSmall,
                          fontWeight: AppTypography.medium,
                          color: gradientColors[1].withOpacity(0.85),
                        ),
                      ),
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
