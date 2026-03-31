import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card_widget.dart';
import '../../../core/widgets/player_avater.dart';
import "package:e_sports/core/controllers/app_data_controller.dart";
import "package:e_sports/core/data/models/computed_player_stats.dart";
import "package:get/get.dart";

class MiniPlayerCard extends StatelessWidget {
  final ComputedPlayerStats player;
  final bool isScorer;

  const MiniPlayerCard({
    super.key,
    required this.player,
    this.isScorer = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCardWidget(
      radius: AppRadius.card,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      borderColor: AppColors.white.withOpacity(0.05),
      child: Row(
        children: [
          // Rank Indicator
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: player.rank <= 3 
                ? AppColors.neonGold.withOpacity(0.15) 
                : AppColors.white.withOpacity(0.05),
              border: Border.all(
                color: player.rank <= 3 
                  ? AppColors.neonGold.withOpacity(0.3) 
                  : AppColors.white.withOpacity(0.1),
              ),
            ),
            child: Center(
              child: Text(
                "${player.rank}",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: AppTypography.black,
                  color: player.rank <= 3 ? AppColors.neonGold : AppColors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),

          PlayerAvatarWidget(
            name: player.name,
            size: 40,
            borderColor: AppColors.white.withOpacity(0.1),
          ),
          SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  player.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: AppTypography.sizeCaption,
                    fontWeight: AppTypography.black,
                    color: AppColors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "TEAM ALPHA",
                  style: TextStyle(
                    fontSize: 9,
                    color: AppColors.white.withOpacity(0.4),
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ],
            ),
          ),

          // Horizontal Stats
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatStandard(
                label: isScorer ? "GLS" : "PTS", 
                value: "${isScorer ? player.goals : player.pts}", 
                isHero: true,
              ),
              _Divider(),
              _StatStandard(label: "GP", value: "${player.matches}"),
              _Divider(),
              _StatStandard(label: "RAT", value: "8.4", isGold: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 12,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      color: AppColors.white.withOpacity(0.1),
    );
  }
}

class _StatStandard extends StatelessWidget {
  final String label, value;
  final bool isHero, isGold;
  const _StatStandard({required this.label, required this.value, this.isHero = false, this.isGold = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontWeight: AppTypography.bold,
            color: AppColors.white.withOpacity(0.3),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHero ? 12 : 10,
            fontWeight: AppTypography.black,
            color: isGold ? AppColors.neonGold : AppColors.white,
          ),
        ),
      ],
    );
  }
}
