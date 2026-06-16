import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';
import '../../../core/widgets/app_footer_widget.dart';
import '../../../core/widgets/section_heading_widget.dart';
import '../../../core/data/models/computed_player_stats.dart';
import '../../splash/domain/models/season_period.dart';
import '../controllers/rank_controller.dart';
import 'premium_hero_card.dart';
import 'mini_player_card.dart';

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
        padding: Dimensions.screenAll,
        child: Column(
          children: [
            // ─── 3 Highlight Cards ──────────────────────────────────────────
            // Desktop: all 3 fit side-by-side within the content width.
            // Mobile: horizontal scroll, each card ~85% of the viewport.
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = ResponsiveHelper.isDesktop(context);
                final gap = Dimensions.xl;
                final cardWidth = isDesktop ? (constraints.maxWidth - gap * 2) / 3 : constraints.maxWidth * 0.85;

                final weekSelector = _PeriodSelector(
                  periods: controller.weeks,
                  selectedNumber: controller.selectedWeekNumber,
                  onSelected: controller.setSelectedWeek,
                );
                final monthSelector = _PeriodSelector(
                  periods: controller.months,
                  selectedNumber: controller.selectedMonthNumber,
                  onSelected: controller.setSelectedMonth,
                );

                // A hero card, or an empty-state placeholder (still showing the
                // period selector) when the period has no player.
                Widget hero(MvpType type, ComputedPlayerStats? player, Widget? action) {
                  if (player == null) return _EmptyHeroCard(type: type, action: action);
                  return GestureDetector(
                    onTap: () => Get.toNamed(RouteHelper.getPlayerProfileRoute(player.id)),
                    child: PremiumHeroCard(type: type, player: player, isScorer: isScorer, action: action),
                  );
                }

                final cards = <Widget>[
                  hero(MvpType.week, hWeek, weekSelector),
                  hero(MvpType.month, hMonth, monthSelector),
                  hero(MvpType.season, hSeason, _SeasonSelector(
                    selected: controller.selectedSeason,
                    onSelected: controller.setSelectedSeason,
                  )),
                ];

                final row = Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < cards.length; i++) ...[
                      SizedBox(width: cardWidth, child: cards[i]),
                      if (i < cards.length - 1) SizedBox(width: gap),
                    ],
                  ],
                );

                return isDesktop
                    ? row
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: row,
                      );
              },
            ),
            SizedBox(height: Dimensions.massive),

            // ─── Weekly Full List ───────────────────────────────────────────
            _ListSection(
              title: isScorer ? "Weekly Scorers" : "Weekly Rankings",
              players: lWeek,
              isScorer: isScorer,
              trailing: _PeriodSelector(
                periods: controller.weeks,
                selectedNumber: controller.selectedWeekNumber,
                onSelected: controller.setSelectedWeek,
              ),
            ),
            SizedBox(height: Dimensions.xl),

            // ─── Monthly Full List ──────────────────────────────────────────
            _ListSection(
              title: isScorer ? "Monthly Scorers" : "Monthly Rankings",
              players: lMonth,
              isScorer: isScorer,
              trailing: _PeriodSelector(
                periods: controller.months,
                selectedNumber: controller.selectedMonthNumber,
                onSelected: controller.setSelectedMonth,
              ),
            ),
            SizedBox(height: Dimensions.xl),

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
            if (ResponsiveHelper.isDesktop(context)) AppDesktopFooter(),
          ],
        ),
      );
    });
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
          separatorBuilder: (context, i) => SizedBox(height: Dimensions.sm),
          itemBuilder: (context, i) => GestureDetector(
            onTap: () => Get.toNamed(RouteHelper.getPlayerProfileRoute(players[i].id)),
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
      shape: RoundedRectangleBorder(borderRadius: Dimensions.borderCard),
      color: AppColors.bgCard,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.md, vertical: Dimensions.xs),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(AppColors.opacity10),
          borderRadius: Dimensions.borderPill,
          border: Border.all(color: AppColors.white.withOpacity(AppColors.opacity20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: Dimensions.black,
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
            fontSize: Dimensions.sizeBody,
            fontWeight: Dimensions.bold,
            color: AppColors.white,
          ),
        ),
      )).toList(),
    );
  }
}

/// Dropdown for selecting a week / month period of the current season.
/// Shows nothing when the season has no periods (e.g. config not loaded).
class _PeriodSelector extends StatelessWidget {
  final List<SeasonPeriod> periods;
  final int? selectedNumber;
  final void Function(int) onSelected;

  const _PeriodSelector({
    required this.periods,
    required this.selectedNumber,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (periods.isEmpty) return const SizedBox.shrink();
    final label = periods
        .firstWhere((p) => p.number == selectedNumber, orElse: () => periods.last)
        .name; // "week-3" / "month-2"

    return PopupMenuButton<int>(
      onSelected: onSelected,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: Dimensions.borderCard),
      color: AppColors.bgCard,
      constraints: const BoxConstraints(maxHeight: 400),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.md, vertical: Dimensions.xs),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(AppColors.opacity10),
          borderRadius: Dimensions.borderPill,
          border: Border.all(color: AppColors.white.withOpacity(AppColors.opacity20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: Dimensions.black,
                color: AppColors.white,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.white),
          ],
        ),
      ),
      itemBuilder: (context) => periods.map((p) => PopupMenuItem<int>(
        value: p.number,
        child: Text(
          p.name,
          style: TextStyle(
            fontSize: Dimensions.sizeBody,
            fontWeight: Dimensions.bold,
            color: AppColors.white,
          ),
        ),
      )).toList(),
    );
  }
}

/// Placeholder shown in a hero slot when the selected period has no player.
/// Keeps the period selector visible so the user can switch periods.
class _EmptyHeroCard extends StatelessWidget {
  final MvpType type;
  final Widget? action;

  const _EmptyHeroCard({required this.type, this.action});

  @override
  Widget build(BuildContext context) {
    final label = type == MvpType.week
        ? "WEEK"
        : type == MvpType.month
            ? "MONTH"
            : "SEASON";

    return Container(
      padding: EdgeInsets.all(Dimensions.xl),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(AppColors.opacity4),
        borderRadius: Dimensions.borderCard,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.sizeCaption,
                  fontWeight: Dimensions.black,
                  color: AppColors.textMuted,
                  letterSpacing: 1.2,
                ),
              ),
              if (action != null) Flexible(child: Align(alignment: Alignment.centerRight, child: action!)),
            ],
          ),
          SizedBox(height: Dimensions.massive),
          Center(
            child: Text(
              "No data for this period",
              style: TextStyle(fontSize: Dimensions.sizeSmall, color: AppColors.textMuted),
            ),
          ),
          SizedBox(height: Dimensions.massive),
        ],
      ),
    );
  }
}
