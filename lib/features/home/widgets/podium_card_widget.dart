import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

class PodiumCard extends StatelessWidget {
  final List<ComputedPlayerStats> players;
  final String title;
  const PodiumCard({required this.players, required this.title});

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
          SizedBox(height: AppSpacing.massive),
          Row(
            children: [
              Expanded(child: _RankBox(
                player: players[0],
                rank: 1,
                rankLabel: "1ST",
                medal: "🥇",
                gradientColors: AppColors.podiumGradientColors[0],
                glowColor: AppColors.podiumGlowColors[0],
                badgeColor: AppColors.podiumBadgeColors[0],
              )),
              SizedBox(width: AppSpacing.md),
              Expanded(child: _RankBox(
                player: players[1],
                rank: 2,
                rankLabel: "2ND",
                medal: "🥈",
                gradientColors: AppColors.podiumGradientColors[1],
                glowColor: AppColors.podiumGlowColors[1],
                badgeColor: AppColors.podiumBadgeColors[1],
              )),
              SizedBox(width: AppSpacing.md),
              Expanded(child: _RankBox(
                player: players[2],
                rank: 3,
                rankLabel: "3RD",
                medal: "🥉",
                gradientColors: AppColors.podiumGradientColors[2],
                glowColor: AppColors.podiumGlowColors[2],
                badgeColor: AppColors.podiumBadgeColors[2],
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankBox extends StatelessWidget {
  final ComputedPlayerStats player;
  final int rank;
  final String rankLabel;
  final String medal;
  final List<Color> gradientColors;
  final Color glowColor;
  final Color badgeColor;

  const _RankBox({
    required this.player,
    required this.rank,
    required this.rankLabel,
    required this.medal,
    required this.gradientColors,
    required this.glowColor,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    const double avatarSize = AppSizing.avatarPodium;
    const double overflowAmt = 10.0;

    final imageUrl = player.player.imageUrl;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderLg + const BorderRadius.all(Radius.circular(2)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradientColors[0].withOpacity(0.72),
                gradientColors[0].withOpacity(0.38),
                Colors.transparent,
              ],
            ),
            border: Border.all(
              color: gradientColors[1].withOpacity(AppColors.opacity45 - 0.03),
              width: AppSizing.borderThin,
            ),
            boxShadow: AppElevation.accentGlow(glowColor, opacity: AppColors.opacity18, blur: 14, offset: const Offset(0, 5)),
          ),
          child: ClipRRect(
            borderRadius: AppRadius.borderLg,
            child: Stack(
              children: [
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: Container(
                    height: AppSizing.shimmerHeight,
                    decoration: BoxDecoration(
                      gradient: AppColors.shimmerGradient(color: gradientColors[2].withOpacity(AppColors.opacity90)),
                    ),
                  ),
                ),
                Positioned(
                  right: -4, bottom: -14,
                  child: Text(
                    rank.toString(),
                    style: TextStyle(
                      fontSize: AppTypography.sizeGhostXl,
                      fontWeight: AppTypography.black,
                      color: gradientColors[1].withOpacity(0.06),
                      height: AppTypography.lineHeightCompact,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: overflowAmt + (avatarSize / 2) + 20),
                    Text(
                      player.short.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppTypography.sizeSubtitle,
                        fontWeight: AppTypography.bold,
                        letterSpacing: AppTypography.trackingWider,
                        color: gradientColors[2].withOpacity(0.95),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.iconGap),
                      decoration: BoxDecoration(
                        color: gradientColors[1].withOpacity(AppColors.opacity12),
                        borderRadius: AppRadius.borderDef,
                        border: Border.all(
                          color: gradientColors[1].withOpacity(AppColors.opacity35),
                          width: AppSizing.borderThin,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${player.pts}",
                            style: TextStyle(
                              fontSize: AppTypography.sizeHeadingLg,
                              fontWeight: AppTypography.black,
                              color: gradientColors[1],
                              height: AppTypography.lineHeightCompact,
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.xxs),
                            child: Text(
                              "PTS",
                              style: TextStyle(
                                fontSize: AppTypography.sizeTiny,
                                fontWeight: AppTypography.extraBold,
                                letterSpacing: AppTypography.trackingWider,
                                color: gradientColors[1].withOpacity(AppColors.opacity60),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: overflowAmt + 4,
          right: 0,
          child: ClipRRect(
            borderRadius: AppRadius.ribbonBadge,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.xs + 1,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [badgeColor.withOpacity(0.85), badgeColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(medal, style: TextStyle(fontSize: AppTypography.sizeSmall)),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    rankLabel,
                    style: TextStyle(
                      fontSize: AppTypography.sizeTiny,
                      fontWeight: AppTypography.black,
                      letterSpacing: 1.4,
                      color: gradientColors[0],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -overflowAmt,
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: gradientColors[1], width: AppSizing.borderAvatar),
              boxShadow: AppElevation.ringGlow(glowColor, opacity: 0.5),
            ),
            child: ClipOval(
              child: Image.network(
                imageUrl,
                width: avatarSize,
                height: avatarSize,
                fit: BoxFit.cover,
                loadingBuilder: (ctx, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: gradientColors[0].withOpacity(0.5),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: AppSizing.borderThick,
                          color: gradientColors[1],
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
                  color: gradientColors[0].withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Text(
                    player.name.isNotEmpty ? player.name[0].toUpperCase() : "?",
                    style: TextStyle(
                      fontSize: AppTypography.sizeDisplay,
                      fontWeight: AppTypography.black,
                      color: gradientColors[1],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
