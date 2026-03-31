import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:e_sports/core/widgets/neon_pill_widget.dart';
import 'package:e_sports/core/widgets/player_avater.dart';
import 'package:flutter/material.dart';

class FullRankingList extends StatelessWidget {
  final List<ComputedPlayerStats> players;
  final bool isScorerList;
  const FullRankingList({required this.players, this.isScorerList = false});

  @override
  Widget build(BuildContext context) {
    final medals = ["🥇", "🥈", "🥉"];
    final colors = [
      AppColors.gold,
      AppColors.silver,
      AppColors.bronze,
      AppColors.neonBlue,
      AppColors.textMuted,
    ];

    return GlassCardWidget(
      child: Column(
          children: List.generate(players.length, (i) {
            final p = players[i];
            final color = colors[i.clamp(0, colors.length - 1)];
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.cardInnerPadding,
                vertical: AppSpacing.body2,
              ),
              decoration: BoxDecoration(
                border: i < players.length - 1
                    ? Border(bottom: BorderSide(color: AppColors.glassBorder))
                    : null,
                gradient: i == 0
                    ? LinearGradient(
                  colors: [AppColors.neonGold.withOpacity(0.06), Colors.transparent],
                )
                    : null,
              ),
              child: Row(children: [
                SizedBox(
                    width: AppTypography.sizeHeadingLg + 2,
                    child: Text(
                      i < 3 ? medals[i] : "${i + 1}",
                      style: TextStyle(
                          fontSize: i < 3 ? AppTypography.sizeHeading : AppTypography.sizeBody,
                          fontWeight: AppTypography.extraBold,
                          color: color),
                      textAlign: TextAlign.center,
                    )),
                SizedBox(width: AppSpacing.lg),
                PlayerAvatarWidget(name: p.name, imageUrl: p.player.imageUrl, size: AppSizing.avatarXs + 4),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(p.name,
                            style: TextStyle(
                                fontSize: AppTypography.sizeBody,
                                fontWeight: AppTypography.bold,
                                color: AppColors.textPrimary)),
                        if (i < 2) ...[
                          SizedBox(width: AppSpacing.sm),
                          NeonPillWidget(label: "VIP", color: AppColors.neonGold),
                        ],
                      ]),
                      Text(isScorerList ? "${p.goals} Goals · ${p.hattricks} 🎩" : "${p.gf} GF · ${p.wins} W",
                          style: TextStyle(
                              fontSize: AppTypography.sizeCaption,
                              color: AppColors.textMuted)),
                    ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(isScorerList ? "${p.goals}" : "${p.pts}",
                      style: TextStyle(
                          fontSize: AppTypography.sizeTitle,
                          fontWeight: AppTypography.black,
                          color: color)),
                  Text(isScorerList ? "goals" : "pts",
                      style: TextStyle(
                        fontSize: AppTypography.sizeTiny,
                        color: AppColors.textMuted,
                      )),
                ]),
              ]),
            );
          })),
    );
  }
}
