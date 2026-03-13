import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/app_header_widget.dart';
import 'package:e_sports/core/widgets/full_score_widget.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:e_sports/core/widgets/neon_pill_widget.dart';
import 'package:e_sports/core/widgets/player_avater.dart';
import 'package:e_sports/core/widgets/pot_banner_widget.dart';
import 'package:e_sports/core/widgets/section_heading_widget.dart';
import 'package:e_sports/game_arena_screen.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});
  @override State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}


class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _type = "players";

  @override
  Widget build(BuildContext context) {
    final players = AppData.players;

    return Column(children: [
      const AppHeader(sub: "Rankings & Highlights"),
      Expanded(child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // Toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              for (final t in [("players", "🏆 Top Players"), ("scorers", "⚽ Top Scorers")])
                Expanded(child: GestureDetector(
                  onTap: () => setState(() => _type = t.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: _type == t.$1 ? AppColors.bgCard : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: _type == t.$1 ? Border.all(color: AppColors.glassBorder) : null,
                      boxShadow: _type == t.$1 ? [BoxShadow(color: AppColors.neonGold.withOpacity(0.06), blurRadius: 8)] : [],
                    ),
                    alignment: Alignment.center,
                    child: Text(t.$2,
                        style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w800,
                          color: _type == t.$1 ? AppColors.textPrimary : AppColors.textMuted,
                        )),
                  ),
                )),
            ]),
          ),
          const SizedBox(height: 16),

          if (_type == "players") ...[
            // POTW Banner
            SectionHeadingWidget(title: "Player of the Week", sub: "This week's best"),
            PotBannerWidget(player: players[0], label: "PLAYER OF THE WEEK",
                gradient: const LinearGradient(colors: [Color(0xFF0D1B4E), Color(0xFF1B4FD8)]),
                badge: "👑"),
            const SizedBox(height: 16),

            // Full Rankings
            SectionHeadingWidget(title: "Full Rankings"),
            FullRankingList(players: players),
            const SizedBox(height: 20),
          ],

          if (_type == "scorers") ...[
            // Top Scorers
            SectionHeadingWidget(title: "Overall Top 3 Scorers", sub: "Most goals all-time"),
            Scorer3List(players: [players[0], players[2], players[1]]),
            const SizedBox(height: 16),

            // Full scorer list
            SectionHeadingWidget(title: "Full Scorer List"),
            FullScorerList(players: players),
            const SizedBox(height: 20),
          ],
        ]),
      )),
    ]);
  }
}


class FullRankingList extends StatelessWidget {
  final List<PlayerModel> players;
  const FullRankingList({required this.players});

  @override
  Widget build(BuildContext context) {
    final medals = ["🥇", "🥈", "🥉"];
    final colors = [AppColors.gold, AppColors.silver, AppColors.bronze,
      AppColors.neonBlue, AppColors.textMuted, AppColors.textMuted];

    return GlassCardWidget(
      child: Column(children: List.generate(players.length, (i) {
        final p = players[i];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            border: i < players.length - 1
                ? Border(bottom: BorderSide(color: AppColors.glassBorder)) : null,
            gradient: i == 0 ? LinearGradient(
              colors: [AppColors.neonGold.withOpacity(0.06), Colors.transparent],
            ) : null,
          ),
          child: Row(children: [
            SizedBox(width: 22, child: Text(
              i < 3 ? medals[i] : "${i + 1}",
              style: TextStyle(fontSize: i < 3 ? 18 : 12,
                  fontWeight: FontWeight.w800, color: colors[i]),
              textAlign: TextAlign.center,
            )),
            const SizedBox(width: 10),
            PlayerAvatarWidget(name: p.name, size: 36),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(p.name, style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                if (i < 2) ...[
                  const SizedBox(width: 5),
                  NeonPillWidget(label: "VIP", color: AppColors.neonGold),
                ],
              ]),
              Text("${p.gf} GF · ${p.wins} W",
                  style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text("${p.pts}", style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w900, color: colors[i])),
              const Text("pts", style: TextStyle(fontSize: 8, color: AppColors.textMuted)),
            ]),
          ]),
        );
      })),
    );
  }
}
