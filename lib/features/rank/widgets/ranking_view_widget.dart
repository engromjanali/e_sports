import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/section_heading_widget.dart';
import "package:e_sports/core/controllers/app_data_controller.dart";
import "package:get/get.dart";
import '../../../core/data/models/computed_player_stats.dart';
import '../controllers/rank_controller.dart';
import 'premium_hero_card.dart';
import 'mini_player_card.dart';
import '../../profile/screens/profile_screen.dart';

class RankingViewWidget extends StatelessWidget {
  final bool isScorer;

  const RankingViewWidget({super.key, this.isScorer = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RankController>();
    
    return Obx(() {
      final hWeek = isScorer ? controller.sotWeek : controller.potWeek;
      final hMonth = isScorer ? controller.sotMonth : controller.potMonth;
      final hSeason = isScorer ? controller.sotSeason : controller.potSeason;

      final lWeek = isScorer ? controller.weeklyScorers : controller.weeklyPlayers;
      final lMonth = isScorer ? controller.monthlyScorers : controller.monthlyPlayers;
      final lSeason = isScorer ? controller.seasonalScorers : controller.seasonalPlayers;

      return SingleChildScrollView(
        padding: AppSpacing.screenAll,
        child: Column(
          children: [
            // ─── 3 Highlight Cards (Horizontal Scroll) ──────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _HeroWrapper(child: GestureDetector(
                    onTap: hWeek == null ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(player: hWeek, isSubScreen: true))),
                    child: PremiumHeroCard(
                      type: MvpType.week, 
                      player: hWeek ?? controller.rankedPlayers.first, 
                      isScorer: isScorer,
                    ),
                  )),
                  _HeroWrapper(child: GestureDetector(
                    onTap: hMonth == null ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(player: hMonth, isSubScreen: true))),
                    child: PremiumHeroCard(
                      type: MvpType.month, 
                      player: hMonth ?? controller.rankedPlayers.first, 
                      isScorer: isScorer,
                    ),
                  )),
                  _HeroWrapper(child: GestureDetector(
                    onTap: hSeason == null ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(player: hSeason, isSubScreen: true))),
                    child: PremiumHeroCard(
                      type: MvpType.season, 
                      player: hSeason ?? controller.rankedPlayers.first, 
                      isScorer: isScorer,
                      action: _SeasonSelector(
                        selected: controller.selectedSeason,
                        onSelected: controller.setSelectedSeason,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.massive),

            // ─── Weekly Full List ───────────────────────────────────────────
            _ListSection(
              title: isScorer ? "Weekly Scorers" : "Weekly Rankings", 
              players: lWeek, 
              isScorer: isScorer,
            ),
            SizedBox(height: AppSpacing.xl),

            // ─── Monthly Full List ──────────────────────────────────────────
            _ListSection(
              title: isScorer ? "Monthly Scorers" : "Monthly Rankings", 
              players: lMonth, 
              isScorer: isScorer,
            ),
            SizedBox(height: AppSpacing.xl),

            // ─── Seasonal Full List ─────────────────────────────────────────
            _ListSection(
              title: isScorer ? "Season Top Scorers" : "Season Standings", 
              players: lSeason, 
              isScorer: isScorer,
              trailing: _SeasonSelector(
                selected: controller.selectedSeason,
                onSelected: controller.setSelectedSeason,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _HeroWrapper extends StatelessWidget {
  final Widget child;
  const _HeroWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: EdgeInsets.only(right: AppSpacing.xl),
      child: child,
    );
  }
}

class _ListSection extends StatelessWidget {
  final String title;
  final List<ComputedPlayerStats> players;
  final bool isScorer;
  final Widget? trailing;

  const _ListSection({
    required this.title,
    required this.players,
    required this.isScorer,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeadingWidget(
          title: "🏆 $title",
          sub: "Full ranking order",
          trailing: trailing,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: players.length,
          separatorBuilder: (context, i) => SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, i) => GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(player: players[i], isSubScreen: true))),
            child: MiniPlayerCard(
              player: players[i],
              isScorer: isScorer,
            ),
          ),
        ),
      ],
    );
  }
}

class _SeasonSelector extends StatelessWidget {
  final String selected;
  final Function(String) onSelected;

  const _SeasonSelector({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final options = ["Overall", "2024/25", "2025/26"];
    
    return PopupMenuButton<String>(
      onSelected: (val) => onSelected(val.toLowerCase()),
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderCard),
      color: AppColors.bgCard,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(AppColors.opacity10),
          borderRadius: AppRadius.borderPill,
          border: Border.all(color: AppColors.white.withOpacity(AppColors.opacity20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: AppTypography.black,
                color: AppColors.white,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.white),
          ],
        ),
      ),
      itemBuilder: (context) => options.map((opt) => PopupMenuItem(
        value: opt,
        child: Text(
          opt,
          style: TextStyle(
            fontSize: AppTypography.sizeBody,
            fontWeight: AppTypography.bold,
            color: AppColors.white,
          ),
        ),
      )).toList(),
    );
  }
}
