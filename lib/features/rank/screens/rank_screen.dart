import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/app_header_widget.dart';
import 'package:e_sports/features/rank/widgets/full_score_widget.dart';
import 'package:e_sports/core/widgets/neon_pill_widget.dart';
import 'package:e_sports/core/widgets/player_avater.dart';
import 'package:e_sports/features/rank/widgets/pot_banner_widget.dart';
import 'package:e_sports/features/rank/widgets/top_three_scorer_list_widget.dart';
import 'package:e_sports/core/widgets/section_heading_widget.dart';
import 'package:e_sports/features/rank/widgets/full_ranking_list_widget.dart';
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
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
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
                badge: "POTW"),
            const SizedBox(height: 16),

            // Full Rankings
            SectionHeadingWidget(title: "Full Rankings"),
            FullRankingList(players: players),
            const SizedBox(height: 20),
          ],

          if (_type == "scorers") ...[
            // Top Scorers
            SectionHeadingWidget(title: "Overall Top 3 Scorers", sub: "Most goals all-time"),
            TopThreeScorersWidget(players: [players[0], players[2], players[1]]),
            const SizedBox(height: 16),

            // Full scorer list
            SectionHeadingWidget(title: "Full Scorer List"),
            FullScorerListWidget(players: players),
            const SizedBox(height: 20),
          ],
        ]),
      )),
    ]);
  }
}
