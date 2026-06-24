import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';
import '../../../core/widgets/app_footer_widget.dart';
import '../../../core/widgets/section_heading_widget.dart';
import '../domain/model/rank_mvp_model.dart';
import '../domain/model/rank_list_item_model.dart';
import '../../splash/domain/models/season_model.dart';
import '../../splash/domain/models/season_period.dart';
import '../controllers/rank_controller.dart';
import '../controllers/rank_list_view_controller.dart';
import 'premium_hero_card.dart';
import 'mini_player_card.dart';

class RankingViewWidget extends StatelessWidget {
  final bool isScorer;

  const RankingViewWidget({super.key, this.isScorer = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RankController>();
    
    return Obx(() {
      final hWeek = controller.weekMvp;
      final hMonth = controller.monthMvp;
      final hSeason = controller.seasonMvp;

      final lWeek = controller.weeklyList;
      final lMonth = controller.monthlyList;
      final lSeason = controller.seasonList;

      // Opens the full, paginated list for a section using its current filters.
      void openAll(RankPeriod period, String title) {
        final a = controller.listArgsFor(period);
        if (a == null) return;
        Get.toNamed(
          RouteHelper.rankListView,
          arguments: RankListViewArgs(
            title: title,
            isScorer: isScorer,
            start: a.start,
            end: a.end,
            seasonId: a.seasonId,
            overall: a.overall,
          ),
        );
      }

      // Season id passed to the detail screen (null = overall).
      final weekDetailSeason = controller.currentSeasonId;
      final monthDetailSeason = controller.currentSeasonId;
      final seasonMvpDetailSeason = controller.mvpSeasonOverall ? null : controller.mvpSeasonId;

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
                final compact = !isDesktop;
                final gap = compact ? Dimensions.md : Dimensions.xl;
                final rawCardWidth = isDesktop ? (constraints.maxWidth - gap * 2) / 3 : constraints.maxWidth * 0.78;
                final cardWidth = rawCardWidth > 450 ? 450.0 : rawCardWidth;

                // MVP card selectors use the MVP-only state (independent of the lists).
                final weekSelector = _PeriodSelector(
                  periods: controller.weeks,
                  selectedNumber: controller.mvpWeekNumber,
                  onSelected: controller.setMvpWeek,
                );
                final monthSelector = _PeriodSelector(
                  periods: controller.months,
                  selectedNumber: controller.mvpMonthNumber,
                  onSelected: controller.setMvpMonth,
                );

                // A hero card. When the period has no player it falls back to a
                // demo placeholder (non-tappable). While loading, a spinner is
                // overlaid on top of the card. [detailSeason] is the season
                // passed to the detail screen (null = overall).
                Widget hero(MvpType type, RankMvpModel? player, Widget? action, int? detailSeason, bool loading) {
                  final model = player ?? RankMvpModel.demo();
                  final card = PremiumHeroCard(type: type, player: model, isScorer: isScorer, action: action, compact: compact);

                  // Demo placeholder has no real player to open.
                  Widget content = model.isDemo
                      ? card
                      : GestureDetector(
                          onTap: () => Get.toNamed(RouteHelper.getRankDetailRoute(model.id, seasonId: detailSeason)),
                          child: card,
                        );

                  if (!loading) return content;

                  // Loading: keep the card visible with a spinner overlaid on top.
                  return Stack(
                    children: [
                      content,
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: Dimensions.borderHero,
                          child: Container(
                            color: AppColors.bg.withOpacity(AppColors.opacity60),
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: Dimensions.iconMd,
                              width: Dimensions.iconMd,
                              child: CircularProgressIndicator(strokeWidth: Dimensions.borderMedium, color: AppColors.neonGold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                final cards = <Widget>[
                  hero(MvpType.week, hWeek, weekSelector, weekDetailSeason, controller.weekMvpLoading.value),
                  hero(MvpType.month, hMonth, monthSelector, monthDetailSeason, controller.monthMvpLoading.value),
                  hero(MvpType.season, hSeason, _SeasonFilter(
                    seasons: controller.seasons,
                    overall: controller.mvpSeasonOverall,
                    seasonId: controller.mvpSeasonId,
                    onOverallChanged: controller.setMvpSeasonOverall,
                    onSeasonSelected: controller.setMvpSeason,
                  ), seasonMvpDetailSeason, controller.seasonMvpLoading.value),
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
              loading: controller.weeklyLoading.value,
              detailSeason: controller.weeklySeasonId,
              onViewAll: () => openAll(RankPeriod.week, isScorer ? "Weekly Scorers" : "Weekly Rankings"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SeasonNameDropdown(
                    seasons: controller.seasons,
                    selectedId: controller.weeklySeasonId,
                    onSelected: controller.setWeeklySeason,
                  ),
                  SizedBox(width: Dimensions.sm),
                  _PeriodSelector(
                    periods: controller.weeklyWeeks,
                    selectedNumber: controller.selectedWeekNumber,
                    onSelected: controller.setSelectedWeek,
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.xl),

            // ─── Monthly Full List ──────────────────────────────────────────
            _ListSection(
              title: isScorer ? "Monthly Scorers" : "Monthly Rankings",
              players: lMonth,
              isScorer: isScorer,
              loading: controller.monthlyLoading.value,
              detailSeason: controller.currentSeasonId,
              onViewAll: () => openAll(RankPeriod.month, isScorer ? "Monthly Scorers" : "Monthly Rankings"),
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
              loading: controller.seasonLoading.value,
              detailSeason: controller.listSeasonOverall ? null : controller.listSeasonId,
              onViewAll: () => openAll(RankPeriod.season, isScorer ? "Season Top Scorers" : "Season Standings"),
              trailing: _SeasonFilter(
                seasons: controller.seasons,
                overall: controller.listSeasonOverall,
                seasonId: controller.listSeasonId,
                onOverallChanged: controller.setListSeasonOverall,
                onSeasonSelected: controller.setListSeason,
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
  final List<RankListItemModel> players;
  final bool isScorer;
  final Widget? trailing;
  final bool loading;
  final int? detailSeason;
  final VoidCallback? onViewAll;

  const _ListSection({
    required this.title,
    required this.players,
    required this.isScorer,
    this.trailing,
    this.loading = false,
    this.detailSeason,
    this.onViewAll,
  });

  /// "View all" affordance — compact chevron on phones, full label on tab/desktop.
  Widget _viewAllButton(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return GestureDetector(
        onTap: onViewAll,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.all(Dimensions.xs),
          child: Icon(Icons.chevron_right,
              color: AppColors.neonGold, size: Dimensions.iconMd),
        ),
      );
    }
    return TextButton.icon(
      onPressed: onViewAll,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.sm),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Text(
        "View all",
        style: TextStyle(
          color: AppColors.neonGold,
          fontWeight: Dimensions.extraBold,
          fontSize: Dimensions.sizeSmall,
        ),
      ),
      label: Icon(Icons.chevron_right,
          color: AppColors.neonGold, size: Dimensions.iconSm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showViewAll = onViewAll != null && players.isNotEmpty;
    // Keep the filter and the "View all" button together on the header row.
    final Widget? headerTrailing = (trailing != null && showViewAll)
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              trailing!,
              SizedBox(width: Dimensions.xs),
              _viewAllButton(context),
            ],
          )
        : (trailing ?? (showViewAll ? _viewAllButton(context) : null));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeadingWidget(
          title: "🏆 $title",
          sub: "Full ranking order",
          trailing: headerTrailing,
        ),
        if (loading && players.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.xl),
            child: Center(
              child: SizedBox(
                height: Dimensions.iconMd,
                width: Dimensions.iconMd,
                child: CircularProgressIndicator(strokeWidth: Dimensions.borderMedium, color: AppColors.neonGold),
              ),
            ),
          )
        else if (players.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.xl),
            child: Text("No data for this period", style: TextStyle(color: AppColors.textMuted, fontSize: Dimensions.sizeSmall)),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: players.length,
            separatorBuilder: (context, i) => SizedBox(height: Dimensions.sm),
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => Get.toNamed(RouteHelper.getRankDetailRoute(players[i].id, seasonId: detailSeason)),
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

/// Dropdown of real season names (value = season id). Greys out when [enabled]
/// is false (e.g. when an "Overall" toggle is active).
class _SeasonNameDropdown extends StatelessWidget {
  final List<SeasonModel> seasons;
  final int? selectedId;
  final void Function(int) onSelected;
  final bool enabled;

  const _SeasonNameDropdown({
    required this.seasons,
    required this.selectedId,
    required this.onSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (seasons.isEmpty) return const SizedBox.shrink();
    final label = (seasons.firstWhereOrNull((s) => s.id == selectedId) ?? seasons.last).name;
    final fg = enabled ? AppColors.white : AppColors.white.withOpacity(AppColors.opacity35);

    return PopupMenuButton<int>(
      enabled: enabled,
      onSelected: onSelected,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: Dimensions.borderCard),
      color: AppColors.bgCard,
      constraints: const BoxConstraints(maxHeight: 400),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.md, vertical: Dimensions.xs),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(enabled ? AppColors.opacity10 : AppColors.opacity4),
          borderRadius: Dimensions.borderPill,
          border: Border.all(color: AppColors.white.withOpacity(AppColors.opacity20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(fontSize: 9, fontWeight: Dimensions.black, color: fg, letterSpacing: 1.0),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 14, color: fg),
          ],
        ),
      ),
      itemBuilder: (context) => seasons.map((s) => PopupMenuItem<int>(
        value: s.id,
        child: Text(
          s.name,
          style: TextStyle(fontSize: Dimensions.sizeBody, fontWeight: Dimensions.bold, color: AppColors.white),
        ),
      )).toList(),
    );
  }
}

/// "Overall" check button + a season-name dropdown. When Overall is checked the
/// dropdown is disabled (used for the season MVP card and Season Standings).
class _SeasonFilter extends StatelessWidget {
  final List<SeasonModel> seasons;
  final bool overall;
  final int? seasonId;
  final void Function(bool) onOverallChanged;
  final void Function(int) onSeasonSelected;

  const _SeasonFilter({
    required this.seasons,
    required this.overall,
    required this.seasonId,
    required this.onOverallChanged,
    required this.onSeasonSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => onOverallChanged(!overall),
          borderRadius: Dimensions.borderPill,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                overall ? Icons.check_box : Icons.check_box_outline_blank,
                size: 16,
                color: overall ? AppColors.neonCyan : AppColors.white,
              ),
              SizedBox(width: 4),
              Text(
                "Overall",
                style: TextStyle(fontSize: 9, fontWeight: Dimensions.black, color: AppColors.white, letterSpacing: 1.0),
              ),
            ],
          ),
        ),
        SizedBox(width: Dimensions.sm),
        _SeasonNameDropdown(
          seasons: seasons,
          selectedId: seasonId,
          onSelected: onSeasonSelected,
          enabled: !overall,
        ),
      ],
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

