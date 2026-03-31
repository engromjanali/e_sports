// import 'package:e_sports/core/theme/app_theme.dart';
// import 'package:e_sports/core/controllers/app_data_controller.dart';

// import 'package:e_sports/core/widgets/app_header_widget.dart';
// import 'package:e_sports/features/home/widgets/my_rank_card_widget.dart';
// import 'package:e_sports/features/home/widgets/news_branner.dart';
// import 'package:e_sports/core/widgets/quick_nav_item_widget.dart';
// import 'package:e_sports/core/widgets/section_heading_widget.dart';
// import 'package:e_sports/core/widgets/sport_light_card_widget.dart';
// import 'package:e_sports/features/home/widgets/get_rewards_cta_widget.dart';
// import 'package:e_sports/features/home/widgets/match_mini_card_widget.dart';
// import 'package:e_sports/features/home/widgets/podium_card_widget.dart';
// import 'package:e_sports/features/home/widgets/top_scorer_card.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:e_sports/features/news/screens/news_list_screen.dart';
// import 'package:e_sports/features/news/screens/news_detail_screen.dart';
// import 'package:e_sports/features/compare/screens/compare_screen.dart';
// import 'package:e_sports/features/hall_of_fame/screens/hall_of_fame_screen.dart' as e_sports_hall_of_fame;
// class HomeScreen extends StatelessWidget {
//   final int newsBannerIndex;
//   final void Function(int) onNewsBannerTap;
//   final void Function(int) onNavigate;
//   final VoidCallback? onSearchTap;
//   final VoidCallback? onProfileTap;

//   const HomeScreen({
//     super.key,
//     required this.newsBannerIndex,
//     required this.onNewsBannerTap,
//     required this.onNavigate,
//     this.onSearchTap,
//     this.onProfileTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final appData = Get.find<AppDataController>();
//       final news = appData.news;
//       final n = news.isNotEmpty ? news[newsBannerIndex] : null;
//       final players = appData.seasonalPlayers;
//       final weeklyPlayers = appData.weeklyPlayers;
//       final monthlyPlayers = appData.monthlyPlayers;
//       final weeklyScorers = appData.weeklyScorers;
//       final monthlyScorers = appData.monthlyScorers;

//       // Safe fallbacks
//       final potw = weeklyPlayers.isNotEmpty ? weeklyPlayers.first : players.first;
//       final potm = monthlyPlayers.isNotEmpty ? monthlyPlayers.first : players.first;
//       final tsotw = weeklyScorers.isNotEmpty ? weeklyScorers.first : players.first;
//       final tsotm = monthlyScorers.isNotEmpty ? monthlyScorers.first : players.first;

//       return Column(children: [
//         AppHeader(
//           sub: "Season 2025 · Live",
//         onSearchTap: onSearchTap,
//         onProfileTap: onProfileTap,
//       ),
//       Expanded(child: SingleChildScrollView(
//         padding: EdgeInsets.zero,
//         child: Column(children: [

//           // ── My Rank ──
//           Padding(
//             padding: AppSpacing.screenH,
//             child: Column(
//               children: [
//                 SizedBox(height: AppSpacing.xxxl),
//                 SectionHeadingWidget(title: "📍 My Rank"),
//                 MyRankCard(),
//                 SizedBox(height: AppSpacing.cardInnerPadding),
//               ],
//             ),
//           ),

//           // ── News Banner ──
//           if (n != null) Padding(
//             padding: EdgeInsets.fromLTRB(AppSpacing.xxxl, AppSpacing.cardInnerPadding, AppSpacing.xxxl, 0),
//             child: GestureDetector(
//               onTap: () => Get.to(() => NewsDetailScreen(news: n), transition: Transition.cupertino),
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 400),
//                 transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
//                 child: NewsBannerWidget(n: n, index: newsBannerIndex, news: news, onDot: onNewsBannerTap,
//                     key: ValueKey(newsBannerIndex)),
//               ),
//             ),
//           ),
//           SizedBox(height: AppSpacing.cardInnerPadding),

//           // ── Quick Nav ──
//           Padding(
//             padding: AppSpacing.screenH,
//             child: Row(
//               children: [
//                 Expanded(child: QuickNavItem(icon: "🎮", label: "Matches",  sub: "Live",   color: AppColors.neonBlue,   onTap: () => onNavigate(1))),
//                 SizedBox(width: 4),
//                 Expanded(child: QuickNavItem(icon: "📊", label: "Ranks",    sub: "Tops",   color: AppColors.neonPurple, onTap: () => onNavigate(2))),
//                 SizedBox(width: 4),
//                 Expanded(child: QuickNavItem(icon: "⚔️", label: "VS",       sub: "Comp",   color: AppColors.neonRed,    onTap: () => Get.to(() => const CompareScreen(), transition: Transition.cupertino))),
//                 SizedBox(width: 4),
//                 Expanded(child: QuickNavItem(icon: "📰", label: "News",     sub: "Lat.",   color: AppColors.neonCyan,   onTap: () => Get.to(() => const NewsListScreen(), transition: Transition.cupertino))),
//                 SizedBox(width: 4),
//                 Expanded(child: QuickNavItem(icon: "🪙", label: "Rewards",  sub: "Earn",   color: AppColors.neonGold,   onTap: () => onNavigate(4))),
//               ],
//             ),
//           ),
//           SizedBox(height: AppSpacing.massive),

//           Padding(
//             padding: AppSpacing.screenH,
//             child: Column(children: [

//               // ── POTW + POTM ──
//               SectionHeadingWidget(
//                 title: "⭐ Player of Week / Month", 
//                 sub: "Season 2025 spotlight",
//                 onAll: () => Get.to(() => const e_sports_hall_of_fame.HallOfFameScreen(), transition: Transition.cupertino),
//               ),
//               Row(children: [
//                 Expanded(child: SpotlightCardWidget(player: potw, label: "POTW", badge: "👑",
//                     gradient: AppColors.blueHeroGradient)),
//                 SizedBox(width: AppSpacing.lg),
//                 Expanded(child: SpotlightCardWidget(player: potm, label: "POTM", badge: "🏆",
//                     gradient: AppColors.orangeHeroGradient)),
//               ]),
//               SizedBox(height: AppSpacing.xxxl),

//               // ── Overall Top 3 ──
//               if (players.length >= 3) ...[
//                 SectionHeadingWidget(title: "🥇 Overall Top 3 Players", onAll: () => onNavigate(2)),
//                 PodiumCard(
//                   players: [players[0], players[1], players[2]], 
//                   title: "All-Time Rankings",
//                   badgeAlignment: Alignment.topRight,
//                 ),
//                 SizedBox(height: AppSpacing.xxxl),
//               ],

//               // ── Seasonal Top 3 ──
//               if (players.length >= 3) ...[
//                 SectionHeadingWidget(title: "🥇 Seasonal Top 3 Players", onAll: () => onNavigate(2)),
//                 PodiumCard(
//                   players: [players[0], players[1], players[2]], 
//                   title: "Seasonal Rankings",
//                   accentColor: AppColors.neonPurple,
//                   badgeAlignment: Alignment.topRight,
//                 ),
//                 SizedBox(height: AppSpacing.xxxl),
//               ],

//               // ── TSOTW/M ──
//               SectionHeadingWidget(title: "⭐ Top Score of The Week / Month", sub: "Season 2025 spotlight"),
//               Row(children: [
//                 Expanded(child: TopScorerCard(player: tsotw, label: "TSOTW · THIS WEEK", badge: "👑",
//                     gradient: AppColors.blueHeroGradient)),
//                 SizedBox(width: AppSpacing.lg),
//                 Expanded(child: TopScorerCard(player: tsotm, label: "TSOTM · DECEMBER", badge: "🏆",
//                     gradient: AppColors.orangeHeroGradient)),
//               ]),
//               SizedBox(height: AppSpacing.xxxl),

//               // ── Overall Top Scorer ──
//               if (appData.seasonalScorers.length >= 3) ...[
//                 SectionHeadingWidget(title: "🥇 Overall Top 3 Scorer", onAll: () => onNavigate(2)),
//                 PodiumCard(
//                   players: [appData.seasonalScorers[0], appData.seasonalScorers[1], appData.seasonalScorers[2]], 
//                   title: "All-Time Rankings",
//                   accentColor: AppColors.neonRed,
//                   statLabel: "GOALS",
//                   badgeAlignment: Alignment.topRight,
//                 ),
//                 SizedBox(height: AppSpacing.xxxl),
//               ],

//               // ── Seasonal Top Scorer ──
//               if (appData.seasonalScorers.length >= 3) ...[
//                 SectionHeadingWidget(title: "🥇 Seasonal Top 3 Scorer", onAll: () => onNavigate(2)),
//                 PodiumCard(
//                   players: [appData.seasonalScorers[0], appData.seasonalScorers[1], appData.seasonalScorers[2]], 
//                   title: "Seasonal Rankings",
//                   accentColor: AppColors.neonCyan,
//                   statLabel: "GOALS",
//                   badgeAlignment: Alignment.topRight,
//                 ),
//                 SizedBox(height: AppSpacing.xxxl),
//               ],

//               // ── Upcoming Matches ──
//               SectionHeadingWidget(title: "🎮 Upcoming Matches", onAll: () => onNavigate(1)),
//               ...appData.matches.take(3)
//                   .map((m) => Padding(
//                   padding: EdgeInsets.only(bottom: AppSpacing.md),
//                   child: MatchMiniCard(match: m))),

//               // ── Get Rewards CTA ──
//               GetRewardsCta(onTap: () => onNavigate(4)),
//               SizedBox(height: AppSpacing.xxxl),
//             ]),
//           ),
//         ]),
//       )),
//     ]);
//     });
//   }
// }

import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/core/controllers/app_data_controller.dart';

import 'package:e_sports/core/widgets/app_header_widget.dart';
import 'package:e_sports/features/home/widgets/my_rank_card_widget.dart';
import 'package:e_sports/features/home/widgets/news_branner.dart';
import 'package:e_sports/core/widgets/quick_nav_item_widget.dart';
import 'package:e_sports/core/widgets/section_heading_widget.dart';
import 'package:e_sports/core/widgets/sport_light_card_widget.dart';
import 'package:e_sports/features/home/widgets/get_rewards_cta_widget.dart';
import 'package:e_sports/features/home/widgets/match_mini_card_widget.dart';
import 'package:e_sports/features/home/widgets/podium_card_widget.dart';
import 'package:e_sports/features/home/widgets/top_scorer_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_sports/features/news/screens/news_list_screen.dart';
import 'package:e_sports/features/news/screens/news_detail_screen.dart';
import 'package:e_sports/features/compare/screens/compare_screen.dart';
import 'package:e_sports/features/hall_of_fame/screens/hall_of_fame_screen.dart';

class HomeScreen extends StatelessWidget {
  final int newsBannerIndex;
  final void Function(int) onNewsBannerTap;
  final void Function(int) onNavigate;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;

  const HomeScreen({
    super.key,
    required this.newsBannerIndex,
    required this.onNewsBannerTap,
    required this.onNavigate,
    this.onSearchTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appData = Get.find<AppDataController>();
      final news = appData.news;
      final n = news.isNotEmpty ? news[newsBannerIndex] : null;
      final players = appData.seasonalPlayers;
      final weeklyPlayers = appData.weeklyPlayers;
      final monthlyPlayers = appData.monthlyPlayers;
      final weeklyScorers = appData.weeklyScorers;
      final monthlyScorers = appData.monthlyScorers;

      final potw = weeklyPlayers.isNotEmpty ? weeklyPlayers.first : players.first;
      final potm = monthlyPlayers.isNotEmpty ? monthlyPlayers.first : players.first;
      final tsotw = weeklyScorers.isNotEmpty ? weeklyScorers.first : players.first;
      final tsotm = monthlyScorers.isNotEmpty ? monthlyScorers.first : players.first;

      return Column(children: [
        AppHeader(
          sub: "Season 2025 · Live",
          onSearchTap: onSearchTap,
          onProfileTap: onProfileTap,
        ),
        Expanded(child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(children: [

            // ── My Rank ──
            Padding(
              padding: AppSpacing.screenH,
              child: Column(
                children: [
                  SizedBox(height: AppSpacing.xxxl),
                  SectionHeadingWidget(title: "📍 My Rank"),
                  MyRankCard(),
                  SizedBox(height: AppSpacing.cardInnerPadding),
                ],
              ),
            ),

            // ── News Banner ──
            if (n != null) Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.xxxl, AppSpacing.cardInnerPadding, AppSpacing.xxxl, 0),
              child: GestureDetector(
                onTap: () => Get.to(() => NewsDetailScreen(news: n), transition: Transition.cupertino),
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
            SizedBox(height: AppSpacing.cardInnerPadding),

            // ── Quick Nav ──
            Padding(
              padding: AppSpacing.screenH,
              child: Row(
                children: [
                  Expanded(child: QuickNavItem(icon: "🎮", label: "Matches", sub: "Live",  color: AppColors.neonBlue,   onTap: () => onNavigate(1))),
                  SizedBox(width: 4),
                  Expanded(child: QuickNavItem(icon: "📊", label: "Ranks",   sub: "Tops",  color: AppColors.neonPurple, onTap: () => onNavigate(2))),
                  SizedBox(width: 4),
                  Expanded(child: QuickNavItem(icon: "⚔️", label: "VS",      sub: "Comp",  color: AppColors.neonRed,    onTap: () => Get.to(() => const CompareScreen(), transition: Transition.cupertino))),
                  SizedBox(width: 4),
                  Expanded(child: QuickNavItem(icon: "📰", label: "News",    sub: "Lat.",  color: AppColors.neonCyan,   onTap: () => Get.to(() => const NewsListScreen(), transition: Transition.cupertino))),
                  SizedBox(width: 4),
                  Expanded(child: QuickNavItem(icon: "🪙", label: "Rewards", sub: "Earn",  color: AppColors.neonGold,   onTap: () => onNavigate(4))),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.massive),

            Padding(
              padding: AppSpacing.screenH,
              child: Column(children: [

                // ── Hall of Fame Banner ───────────────────────────────────────
                _HallOfFameBanner(),
                SizedBox(height: AppSpacing.xxxl),

                // ── POTW + POTM ──
                SectionHeadingWidget(
                  title: "⭐ Player of Week / Month",
                  sub: "Season 2025 spotlight",
                  onAll: () => Get.to(() => const HallOfFameScreen(), transition: Transition.cupertino),
                ),
                Row(children: [
                  Expanded(child: SpotlightCardWidget(player: potw, label: "POTW", badge: "👑",
                      gradient: AppColors.blueHeroGradient)),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(child: SpotlightCardWidget(player: potm, label: "POTM", badge: "🏆",
                      gradient: AppColors.orangeHeroGradient)),
                ]),
                SizedBox(height: AppSpacing.xxxl),

                // ── Overall Top 3 ──
                if (players.length >= 3) ...[
                  SectionHeadingWidget(title: "🥇 Overall Top 3 Players", onAll: () => onNavigate(2)),
                  PodiumCard(
                    players: [players[0], players[1], players[2]],
                    title: "All-Time Rankings",
                    badgeAlignment: Alignment.topRight,
                  ),
                  SizedBox(height: AppSpacing.xxxl),
                ],

                // ── Seasonal Top 3 ──
                if (players.length >= 3) ...[
                  SectionHeadingWidget(title: "🥇 Seasonal Top 3 Players", onAll: () => onNavigate(2)),
                  PodiumCard(
                    players: [players[0], players[1], players[2]],
                    title: "Seasonal Rankings",
                    accentColor: AppColors.neonPurple,
                    badgeAlignment: Alignment.topRight,
                  ),
                  SizedBox(height: AppSpacing.xxxl),
                ],

                // ── TSOTW/M ──
                SectionHeadingWidget(title: "⭐ Top Score of The Week / Month", sub: "Season 2025 spotlight"),
                Row(children: [
                  Expanded(child: TopScorerCard(player: tsotw, label: "TSOTW · THIS WEEK", badge: "👑",
                      gradient: AppColors.blueHeroGradient)),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(child: TopScorerCard(player: tsotm, label: "TSOTM · DECEMBER", badge: "🏆",
                      gradient: AppColors.orangeHeroGradient)),
                ]),
                SizedBox(height: AppSpacing.xxxl),

                // ── Overall Top Scorer ──
                if (appData.seasonalScorers.length >= 3) ...[
                  SectionHeadingWidget(title: "🥇 Overall Top 3 Scorer", onAll: () => onNavigate(2)),
                  PodiumCard(
                    players: [appData.seasonalScorers[0], appData.seasonalScorers[1], appData.seasonalScorers[2]],
                    title: "All-Time Rankings",
                    accentColor: AppColors.neonRed,
                    statLabel: "GOALS",
                    badgeAlignment: Alignment.topRight,
                  ),
                  SizedBox(height: AppSpacing.xxxl),
                ],

                // ── Seasonal Top Scorer ──
                if (appData.seasonalScorers.length >= 3) ...[
                  SectionHeadingWidget(title: "🥇 Seasonal Top 3 Scorer", onAll: () => onNavigate(2)),
                  PodiumCard(
                    players: [appData.seasonalScorers[0], appData.seasonalScorers[1], appData.seasonalScorers[2]],
                    title: "Seasonal Rankings",
                    accentColor: AppColors.neonCyan,
                    statLabel: "GOALS",
                    badgeAlignment: Alignment.topRight,
                  ),
                  SizedBox(height: AppSpacing.xxxl),
                ],

                // ── Upcoming Matches ──
                SectionHeadingWidget(title: "🎮 Upcoming Matches", onAll: () => onNavigate(1)),
                ...appData.matches.take(3).map((m) => Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: MatchMiniCard(match: m),
                    )),

                // ── Get Rewards CTA ──
                GetRewardsCta(onTap: () => onNavigate(4)),
                SizedBox(height: AppSpacing.xxxl),
              ]),
            ),
          ]),
        )),
      ]);
    });
  }
}

// ─── Hall of Fame Banner ──────────────────────────────────────────────────────

class _HallOfFameBanner extends StatelessWidget {
  const _HallOfFameBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => const HallOfFameScreen(), transition: Transition.cupertino),
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
          borderRadius: AppRadius.borderDef,
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
          horizontal: AppSpacing.massive,
          vertical: AppSpacing.cardInnerPadding,
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
                  fontWeight: AppTypography.black,
                  color: AppColors.neonGold.withOpacity(0.05),
                  height: AppTypography.lineHeightCompact,
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
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldRibbonGradient,
                          borderRadius: AppRadius.borderPill,
                        ),
                        child: const Text(
                          "HOUSE OF ELITES",
                          style: TextStyle(
                            fontSize: AppTypography.sizeTiny,
                            fontWeight: AppTypography.black,
                            letterSpacing: AppTypography.trackingMax,
                            color: AppColors.bg,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text(
                        "Hall Of Fame",
                        style: TextStyle(
                          fontSize: AppTypography.sizeHeading,
                          fontWeight: AppTypography.black,
                          color: AppColors.white,
                          height: AppTypography.lineHeightCompact,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      const Text(
                        "Legends & Champions across\nall seasons",
                        style: TextStyle(
                          fontSize: AppTypography.sizeCaption,
                          color: AppColors.textSecondary,
                          height: AppTypography.lineHeightRelaxed,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // CTA row
                      Row(
                        children: [
                          Text(
                            "View All",
                            style: TextStyle(
                              fontSize: AppTypography.sizeSmall,
                              fontWeight: AppTypography.extraBold,
                              color: AppColors.neonGold,
                              letterSpacing: AppTypography.trackingNormal,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: AppTypography.sizeCaption,
                            color: AppColors.neonGold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.lg),

                // // Right: trophy emoji + season count chips
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     const Text("🏆", style: TextStyle(fontSize: 48)),
                //     const SizedBox(height: AppSpacing.md),
                //     // _buildMiniChip("4 Awards", AppColors.neonGold),
                //     // const SizedBox(height: AppSpacing.xs),
                //     // _buildMiniChip("18 Champs", AppColors.neonCyan),
                //     // const SizedBox(height: AppSpacing.xs),
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
  //       horizontal: AppSpacing.md,
  //       vertical: AppSpacing.xxs,
  //     ),
  //     decoration: BoxDecoration(
  //       color: color.withOpacity(AppColors.opacity10),
  //       borderRadius: AppRadius.borderXxs,
  //       border: Border.all(color: color.withOpacity(AppColors.opacity25)),
  //     ),
  //     child: Text(
  //       label,
  //       style: TextStyle(
  //         fontSize: AppTypography.sizeTiny,
  //         fontWeight: AppTypography.extraBold,
  //         color: color,
  //         letterSpacing: AppTypography.trackingNormal,
  //       ),
  //     ),
  //   );
  // }
}