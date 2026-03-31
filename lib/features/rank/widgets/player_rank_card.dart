import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'package:e_sports/core/data/models/computed_player_stats.dart';
import '../../../core/widgets/player_avater.dart';

enum PlayerCardType { playerOfWeek, playerOfMonth, topScorerWeek, topScorerMonth }

class PlayerRankCard extends StatelessWidget {
  final PlayerCardType type;
  final ComputedPlayerStats player;

  const PlayerRankCard({
    super.key,
    required this.type,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    final isScorer = type == PlayerCardType.topScorerWeek || type == PlayerCardType.topScorerMonth;
    final isMonth = type == PlayerCardType.playerOfMonth || type == PlayerCardType.topScorerMonth;
    
    final accentColor = isScorer ? AppColors.neonBlue : AppColors.neonGold;
    final label = _getLabel();
    final gradient = isScorer ? AppColors.blueDeepHeroGradient : AppColors.goldHeroGradient;

    return Container(
      padding: AppSpacing.hugePadding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: accentColor.withOpacity(AppColors.opacity20)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(AppColors.opacity20),
            blurRadius: AppElevation.blurXl,
          )
        ],
      ),
      child: Stack(
        children: [
          // Background accent icon or decorative element
          Positioned(
            right: -20,
            bottom: -20,
            child: Text(
              isScorer ? "⚽" : "🏆",
              style: TextStyle(fontSize: 80, color: Colors.white.withOpacity(0.05)),
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 1),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(AppColors.opacity15),
                      borderRadius: AppRadius.borderSm,
                      border: Border.all(color: accentColor.withOpacity(AppColors.opacity30)),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: AppTypography.sizeCaption,
                        fontWeight: AppTypography.extraBold,
                        color: accentColor,
                        letterSpacing: AppTypography.trackingWider,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface.withOpacity(AppColors.opacity40),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Text(
                      "#${player.rank}",
                      style: TextStyle(
                        fontSize: AppTypography.sizeCaption,
                        fontWeight: AppTypography.black,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  PlayerAvatarWidget(
                    name: player.name,
                    imageUrl: player.player.imageUrl,
                    size: AppSizing.avatarHero,
                  ),
                  SizedBox(width: AppSpacing.xl),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: TextStyle(
                            fontSize: AppTypography.sizeHeading,
                            fontWeight: AppTypography.black,
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          isMonth ? "MTD PERFORMANCE" : "WEEKLY STATS",
                          style: TextStyle(
                            fontSize: AppTypography.sizeTiny,
                            fontWeight: AppTypography.bold,
                            color: AppColors.white.withOpacity(AppColors.opacity55),
                            letterSpacing: AppTypography.trackingWidest,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    label: "PTS",
                    value: "${player.pts}",
                    icon: "🔥",
                  ),
                  _StatItem(
                    label: "GOALS",
                    value: "${player.goals}",
                    icon: "⚽",
                  ),
                  _StatItem(
                    label: "WINS",
                    value: "${player.wins}",
                    icon: "🛡️",
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLabel() {
    switch (type) {
      case PlayerCardType.playerOfWeek: return "PLAYER OF THE WEEK";
      case PlayerCardType.playerOfMonth: return "PLAYER OF THE MONTH";
      case PlayerCardType.topScorerWeek: return "WEEKLY TOP SCORER";
      case PlayerCardType.topScorerMonth: return "MONTHLY TOP SCORER";
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label, value, icon;
  const _StatItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 12)),
            SizedBox(width: AppSpacing.xs),
            Text(
              value,
              style: TextStyle(
                fontSize: AppTypography.sizeSubtitle,
                fontWeight: AppTypography.black,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: AppTypography.sizeTiny,
            color: AppColors.white.withOpacity(AppColors.opacity50),
            fontWeight: AppTypography.bold,
          ),
        ),
      ],
    );
  }
}
