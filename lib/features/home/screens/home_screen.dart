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
import 'package:e_sports/features/home/widgets/podium_card_two_widget.dart';
import 'package:e_sports/features/home/widgets/podium_card_widget.dart';
import 'package:e_sports/features/home/widgets/top_scorer_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_sports/features/news/screens/news_list_screen.dart';
import 'package:e_sports/features/news/screens/news_detail_screen.dart';
import 'package:e_sports/features/compare/screens/compare_screen.dart';
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

      // Safe fallbacks
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
                child: NewsBannerWidget(n: n, index: newsBannerIndex, news: news, onDot: onNewsBannerTap,
                    key: ValueKey(newsBannerIndex)),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.cardInnerPadding),

          // ── Quick Nav ──
          Padding(
            padding: AppSpacing.screenH,
            child: Row(
              children: [
                Expanded(child: QuickNavItem(icon: "🎮", label: "Matches",  sub: "Live",   color: AppColors.neonBlue,   onTap: () => onNavigate(1))),
                SizedBox(width: 4),
                Expanded(child: QuickNavItem(icon: "📊", label: "Ranks",    sub: "Tops",   color: AppColors.neonPurple, onTap: () => onNavigate(2))),
                SizedBox(width: 4),
                Expanded(child: QuickNavItem(icon: "⚔️", label: "VS",       sub: "Comp",   color: AppColors.neonRed,    onTap: () => Get.to(() => const CompareScreen(), transition: Transition.cupertino))),
                SizedBox(width: 4),
                Expanded(child: QuickNavItem(icon: "📰", label: "News",     sub: "Lat.",   color: AppColors.neonCyan,   onTap: () => Get.to(() => const NewsListScreen(), transition: Transition.cupertino))),
                SizedBox(width: 4),
                Expanded(child: QuickNavItem(icon: "🪙", label: "Rewards",  sub: "Earn",   color: AppColors.neonGold,   onTap: () => onNavigate(4))),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.massive),

          Padding(
            padding: AppSpacing.screenH,
            child: Column(children: [

              // ── POTW + POTM ──
              SectionHeadingWidget(title: "⭐ Player of Week / Month", sub: "Season 2025 spotlight"),
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
                PodiumCard(players: [players[0], players[2], players[1]], title: "All-Time Rankings"),
                SizedBox(height: AppSpacing.xxxl),
              ],

              // ── Seasonal Top 3 ──
              if (players.length >= 3) ...[
                SectionHeadingWidget(title: "🥇 Seasonal Top 3 Players", onAll: () => onNavigate(2)),
                PodiumCard(players: [players[0], players[2], players[1]], title: "Seasonal Rankings"),
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
              if (players.length >= 3) ...[
                SectionHeadingWidget(title: "🥇 Overall Top 3 Scorer", onAll: () => onNavigate(2)),
                PodiumCardTwo(players: [players[0], players[2], players[1]], title: "All-Time Rankings"),
                SizedBox(height: AppSpacing.xxxl),
              ],

              // ── Seasonal Top Scorer ──
              if (players.length >= 3) ...[
                SectionHeadingWidget(title: "🥇 Seasonal Top 3 Scorer", onAll: () => onNavigate(2)),
                PodiumCardTwo(players: [players[0], players[2], players[1]], title: "Seasonal Rankings"),
                SizedBox(height: AppSpacing.xxxl),
              ],

              // ── Upcoming Matches ──
              SectionHeadingWidget(title: "🎮 Upcoming Matches", onAll: () => onNavigate(1)),
              ...appData.matches.take(3)
                  .map((m) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: MatchMiniCard(match: m))),

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
