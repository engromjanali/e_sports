import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';
import 'package:e_sports/features/matches/controllers/match_controller.dart';
import 'package:e_sports/features/news/controllers/news_controller.dart';
import 'package:e_sports/features/rank/controllers/rank_controller.dart';
import 'package:e_sports/features/splash/controllers/splash_controller.dart';
import '../../player/controllers/player_controller.dart';
import '../controllers/home_controller.dart';

import '../../../core/widgets/app_footer_widget.dart';
import '../../../core/widgets/app_header_widget.dart';
import '../widgets/my_rank_card_widget.dart';
import '../widgets/news_branner.dart';
import '../../../core/widgets/quick_nav_item_widget.dart';
import '../../../core/widgets/section_heading_widget.dart';
import '../../../core/widgets/sport_light_card_widget.dart';
import '../widgets/match_mini_card_widget.dart';
import '../widgets/podium_card_widget.dart';
import '../widgets/top_scorer_card.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helper/route_helper.dart';

class HomeScreen extends StatelessWidget {
  final int newsBannerIndex;
  final void Function(int) onNewsBannerTap;
  final void Function(int) onNavigate;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;

  const HomeScreen({
    super.key,
    required this.newsBannerIndex,
    required this.onNewsBannerTap,
    required this.onNavigate,
    this.onSearchTap,
    this.onProfileTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    return Obx(() {
      final playerData = Get.find<PlayerController>();
      final news = Get.find<NewsController>().newsHome;
      final n = news.isNotEmpty ? news[newsBannerIndex % news.length] : null;
      final players = playerData.seasonalPlayers;
      final weeklyPlayers = playerData.weeklyPlayers;
      final monthlyPlayers = playerData.monthlyPlayers;
      final weeklyScorers = playerData.weeklyScorers;
      final monthlyScorers = playerData.monthlyScorers;

      if (playerData.isLoading.value || players.isEmpty) {
        return Column(children: [
          AppHeader(
            sub: Get.find<SplashController>().configModel?.seasons.firstWhereOrNull((season) => season.id == Get.find<SplashController>().configModel?.currentSeason)?.name  ?? "Season XX",
            onSearchTap: onSearchTap,
            onProfileTap: onProfileTap,
            onMenuTap: onMenuTap,
          ),
          const Expanded(child: Center(child: CircularProgressIndicator())),
        ]);
      }

      final potw = weeklyPlayers.isNotEmpty ? weeklyPlayers.first : players.first;
      final potm = monthlyPlayers.isNotEmpty ? monthlyPlayers.first : players.first;
      final tsotw = weeklyScorers.isNotEmpty ? weeklyScorers.first : players.first;
      final tsotm = monthlyScorers.isNotEmpty ? monthlyScorers.first : players.first;

      return GetBuilder<RankController>(
        builder: (rankController) {
          return Column(children: [
            AppHeader(
              sub: Get.find<SplashController>().configModel?.seasons.firstWhereOrNull((season) => season.id == Get.find<SplashController>().configModel?.currentSeason)?.name  ?? "Season XX",
              onSearchTap: onSearchTap,
              onProfileTap: onProfileTap,
              onMenuTap: onMenuTap,
            ),
            Expanded(child: RefreshIndicator(
              onRefresh: () async {
                await playerData.loadData();
                await home.reloadData();
              },
              child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(children: [
          
                // ── My Rank ──
                Padding(
                  padding: Dimensions.screenH,
                  child: Column(
                    children: [
                      SizedBox(height: Dimensions.xxxl),
                      SectionHeadingWidget(title: "📍 My Rank"),
                      MyRankCard(),
                      SizedBox(height: Dimensions.cardInnerPadding),
                    ],
                  ),
                ),
          
                // ── News Banner ──
                if (n != null) Padding(
                  padding: EdgeInsets.fromLTRB(Dimensions.xxxl, Dimensions.cardInnerPadding, Dimensions.xxxl, 0),
                  child: GestureDetector(
                    onTap: () => Get.toNamed(RouteHelper.getNewsDetailsRoute(n.id), arguments: n),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                      child: NewsBannerWidget(
                        n: n, index: newsBannerIndex, news: news, onDot: onNewsBannerTap,
                        key: ValueKey(newsBannerIndex),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.cardInnerPadding),
          
                // ── Quick Nav ──
                Padding(
                  padding: Dimensions.screenH,
                  child: Row(
                    children: [
                      Expanded(child: QuickNavItem(icon: "🎮", label: "Matches", sub: "Live",  color: AppColors.neonBlue,   onTap: () => onNavigate(1))),
                      SizedBox(width: 4),
                      Expanded(child: QuickNavItem(icon: "📊", label: "Ranks",   sub: "Tops",  color: AppColors.neonPurple, onTap: () => onNavigate(2))),
                      SizedBox(width: 4),
                      Expanded(child: QuickNavItem(icon: "⚔️", label: "VS",      sub: "Comp",  color: AppColors.neonRed,    onTap: () => Get.toNamed(RouteHelper.compare))),
                      SizedBox(width: 4),
                      Expanded(child: QuickNavItem(icon: "📰", label: "News",    sub: "Lat.",  color: AppColors.neonCyan,   onTap: () => Get.toNamed(RouteHelper.news))),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.massive),
          
                Padding(
                  padding: Dimensions.screenH,
                  child: Column(children: [
          
                    // ── Hall of Fame Banner ───────────────────────────────────────
                    _HallOfFameBanner(),
                    SizedBox(height: Dimensions.xxxl),
          
                    // ── POTW + POTM ──
                    SectionHeadingWidget(
                      title: "⭐ Player of The Week & Month",
                      sub: "Season 2025 spotlight",
                      onAll: () => Get.toNamed(RouteHelper.hallOfFame),
                    ),
                    Row(children: [
                      Expanded(child: SpotlightCardWidget(player: potw, label: "POTW", badge: "👑",
                          gradient: AppColors.blueHeroGradient)),
                      SizedBox(width: Dimensions.lg),
                      Expanded(child: SpotlightCardWidget(player: potm, label: "POTM", badge: "🏆",
                          gradient: AppColors.orangeHeroGradient)),
                    ]),
                    SizedBox(height: Dimensions.xxxl),
          
                    // ── Overall Top 3 ──
                    if (rankController.overAllTopThreePlayer.isNotEmpty) ...[
                      SectionHeadingWidget(title: "🥇 Overall Top 3 Players", onAll: () => onNavigate(2)),
                      PodiumCard(
                        players: rankController.overAllTopThreePlayer ?? [],
                        title: "All-Time Rankings",
                        badgeAlignment: Alignment.topRight,
                      ),
                      SizedBox(height: Dimensions.xxxl),
                    ],
          
                    // ── Seasonal Top 3 ──
                    if (rankController.seasonalTopThreePlayer.isNotEmpty) ...[
                      SectionHeadingWidget(title: "🥇 Seasonal Top 3 Players", onAll: () => onNavigate(2)),
                      PodiumCard(
                        players: rankController.seasonalTopThreePlayer ?? [],
                        title: "Seasonal Rankings",
                        accentColor: AppColors.neonPurple,
                        badgeAlignment: Alignment.topRight,
                      ),
                      SizedBox(height: Dimensions.xxxl),
                    ],
          
                    // ── TSOTW/M ──
                    SectionHeadingWidget(title: "⭐ Top Score of The Week & Month", sub: "Season 2025 spotlight"),
                    Row(children: [
                      Expanded(child: TopScorerCard(player: tsotw, label: "TSOTW · THIS WEEK", badge: "👑", gradient: AppColors.blueHeroGradient)),
                      SizedBox(width: Dimensions.lg),
                      Expanded(child: TopScorerCard(player: tsotm, label: "TSOTM · DECEMBER", badge: "🏆", gradient: AppColors.orangeHeroGradient)),
                    ]),
                    SizedBox(height: Dimensions.xxxl),
          
                    // ── Overall Top Scorer ──
                    if (rankController.overAllTopThreePlayer.isNotEmpty) ...[
                      SectionHeadingWidget(title: "🥇 Overall Top 3 Scorer", onAll: () => onNavigate(2)),
                      PodiumCard(
                        players: rankController.overAllTopThreePlayer ?? [],
                        title: "All-Time Rankings",
                        accentColor: AppColors.neonRed,
                        statLabel: "GOALS",
                        badgeAlignment: Alignment.topRight,
                      ),
                      SizedBox(height: Dimensions.xxxl),
                    ],
          
                    // ── Seasonal Top Scorer ──
                    if (rankController.seasonalTopThreeScorer.isNotEmpty) ...[
                      SectionHeadingWidget(title: "🥇 Seasonal Top 3 Scorer", onAll: () => onNavigate(2)),
                      PodiumCard(
                        players: rankController.seasonalTopThreeScorer ?? [],
                        title: "Seasonal Rankings",
                        accentColor: AppColors.neonCyan,
                        statLabel: "GOALS",
                        badgeAlignment: Alignment.topRight,
                      ),
                      SizedBox(height: Dimensions.xxxl),
                    ],
          
                    // ── Upcoming Matches ──
                    SectionHeadingWidget(title: "🎮 Live & Upcoming Matches", onAll: () => onNavigate(1)),
                    ...Get.find<MatchController>().matchesHome.map((m) => Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.md),
                          child: MatchMiniCard(match: m),
                        )),
          
                    if (ResponsiveHelper.isDesktop(context)) AppDesktopFooter(),
                    SizedBox(height: Dimensions.xxxl),
                  ]),
                ),
              ]),
            )))),
          ]);
        }
      );
    });
  }
}

// ─── Hall of Fame Banner ──────────────────────────────────────────────────────

class _HallOfFameBanner extends StatelessWidget {
  const _HallOfFameBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(RouteHelper.hallOfFame),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0x33FFD700), // neonGold ~20%
              Color(0x0AFFFFFF),
              Color(0x08FFD700),
            ],
          ),
          borderRadius: Dimensions.borderDef,
          border: Border.all(color: AppColors.neonGold.withOpacity(AppColors.opacity25)),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonGold.withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.massive,
          vertical: Dimensions.cardInnerPadding,
        ),
        child: Stack(
          children: [
            // Ghost watermark
            Positioned(
              right: -4,
              bottom: -10,
              child: Text(
                "HOF",
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: Dimensions.black,
                  color: AppColors.neonGold.withOpacity(0.05),
                  height: Dimensions.lineHeightCompact,
                  letterSpacing: -2,
                ),
              ),
            ),

            Row(
              children: [
                // Left: texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pill label
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.md,
                          vertical: Dimensions.xxs,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldRibbonGradient,
                          borderRadius: Dimensions.borderPill,
                        ),
                        child: const Text(
                          "HOUSE OF ELITES",
                          style: TextStyle(
                            fontSize: Dimensions.sizeTiny,
                            fontWeight: Dimensions.black,
                            letterSpacing: Dimensions.trackingMax,
                            color: AppColors.bg,
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.md),
                      const Text(
                        "Hall Of Fame",
                        style: TextStyle(
                          fontSize: Dimensions.sizeHeading,
                          fontWeight: Dimensions.black,
                          color: AppColors.white,
                          height: Dimensions.lineHeightCompact,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: Dimensions.xxs),
                      const Text(
                        "Legends & Champions across\nall seasons",
                        style: TextStyle(
                          fontSize: Dimensions.sizeCaption,
                          color: AppColors.textSecondary,
                          height: Dimensions.lineHeightRelaxed,
                        ),
                      ),
                      const SizedBox(height: Dimensions.md),
                      // CTA row
                      Row(
                        children: [
                          Text(
                            "View All",
                            style: TextStyle(
                              fontSize: Dimensions.sizeSmall,
                              fontWeight: Dimensions.extraBold,
                              color: AppColors.neonGold,
                              letterSpacing: Dimensions.trackingNormal,
                            ),
                          ),
                          const SizedBox(width: Dimensions.xs),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: Dimensions.sizeCaption,
                            color: AppColors.neonGold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: Dimensions.lg),

                // // Right: trophy emoji + season count chips
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     const Text("🏆", style: TextStyle(fontSize: 48)),
                //     const SizedBox(height: Dimensions.md),
                //     // _buildMiniChip("4 Awards", AppColors.neonGold),
                //     // const SizedBox(height: Dimensions.xs),
                //     // _buildMiniChip("18 Champs", AppColors.neonCyan),
                //     // const SizedBox(height: Dimensions.xs),
                //     // _buildMiniChip("6+ Seasons", AppColors.neonPurple),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildMiniChip(String label, Color color) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: Dimensions.md,
  //       vertical: Dimensions.xxs,
  //     ),
  //     decoration: BoxDecoration(
  //       color: color.withOpacity(AppColors.opacity10),
  //       borderRadius: Dimensions.borderXxs,
  //       border: Border.all(color: color.withOpacity(AppColors.opacity25)),
  //     ),
  //     child: Text(
  //       label,
  //       style: TextStyle(
  //         fontSize: Dimensions.sizeTiny,
  //         fontWeight: Dimensions.extraBold,
  //         color: color,
  //         letterSpacing: Dimensions.trackingNormal,
  //       ),
  //     ),
  //   );
  // }
}
