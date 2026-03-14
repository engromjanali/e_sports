import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:e_sports/core/widgets/neon_pill_widget.dart';
import 'package:e_sports/core/widgets/player_avater.dart';
import 'package:flutter/material.dart';

class FullRankingList extends StatelessWidget {
  final List<PlayerModel> players;
  const FullRankingList({required this.players});

  @override
  Widget build(BuildContext context) {
    final medals = ["🥇", "🥈", "🥉"];
    final colors = [
      AppColors.gold,
      AppColors.silver,
      AppColors.bronze,
      AppColors.neonBlue,
      AppColors.textMuted,
      AppColors.textMuted
    ];

    return GlassCardWidget(
      child: Column(
          children: List.generate(players.length, (i) {
            final p = players[i];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
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
                    width: 22,
                    child: Text(
                      i < 3 ? medals[i] : "${i + 1}",
                      style: TextStyle(
                          fontSize: i < 3 ? 18 : 12,
                          fontWeight: FontWeight.w800,
                          color: colors[i]),
                      textAlign: TextAlign.center,
                    )),
                const SizedBox(width: 10),
                PlayerAvatarWidget(name: p.name, size: 36),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(p.name,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                        if (i < 2) ...[
                          const SizedBox(width: 5),
                          NeonPillWidget(label: "VIP", color: AppColors.neonGold),
                        ],
                      ]),
                      Text("${p.gf} GF · ${p.wins} W",
                          style: const TextStyle(
                              fontSize: 9, color: AppColors.textMuted)),
                    ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text("${p.pts}",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: colors[i])),
                  const Text("pts",
                      style: TextStyle(fontSize: 8, color: AppColors.textMuted)),
                ]),
              ]),
            );
          })),
    );
  }
}
