import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
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

class HomeScreen extends StatelessWidget {
  final int newsBannerIndex;
  final void Function(int) onNewsBannerTap;
  final void Function(int) onNavigate;

  const HomeScreen({
    super.key,
    required this.newsBannerIndex,
    required this.onNewsBannerTap,
    required this.onNavigate,

  });

  @override
  Widget build(BuildContext context) {
    final news = AppData.news;
    final n = news[newsBannerIndex];
    final players = AppData.players;

    return Column(children: [
      AppHeader(sub: "Season 2025 · Live"),
      Expanded(child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(children: [

          // ── My Rank ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 16,),
            child: Column(
              children: [
                SizedBox(height: 16,),
                SectionHeadingWidget(title: "📍 My Rank"),
                MyRankCard(),
                const SizedBox(height: 14),
              ],
            ),
          ),


          // ── News Banner ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: GestureDetector(
              onTap: () {},
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                child: NewsBannerWidget(n: n, index: newsBannerIndex, news: news, onDot: onNewsBannerTap,
                    key: ValueKey(newsBannerIndex)),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Quick Nav ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              QuickNavItem(icon: "🎮", label: "Matches",  sub: "Live Now",  color: AppColors.neonBlue,   onTap: () => onNavigate(1)),
              const SizedBox(width: 8),
              QuickNavItem(icon: "📊", label: "Ranks",    sub: "Top List",  color: AppColors.neonPurple, onTap: () => onNavigate(2)),
              const SizedBox(width: 8),
              QuickNavItem(icon: "📰", label: "News",     sub: "Latest",    color: AppColors.neonCyan,   onTap: () {}),
              const SizedBox(width: 8),
              QuickNavItem(icon: "🪙", label: "Rewards",  sub: "Earn Now",  color: AppColors.neonGold,   onTap: () => onNavigate(4)),
            ]),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [

              // ── POTW + POTM ──────────────────────────────────────────
              SectionHeadingWidget(title: "⭐ Player of Week / Month", sub: "Season 2025 spotlight"),
              Row(children: [
                Expanded(child: SpotlightCardWidget(player: players[0], label: "POTW", badge: "👑",
                    gradient: const LinearGradient(colors: [Color(0xFF0D1B4E), Color(0xFF1B4FD8)]))),
                const SizedBox(width: 10),
                Expanded(child: SpotlightCardWidget(player: players[1], label: "POTM", badge: "🏆",
                    gradient: const LinearGradient(colors: [Color(0xFF7C2D12), Color(0xFFC2410C)]))),
              ]),
              const SizedBox(height: 16),

              // ── Overall Top 3 ────────────────────────────────────────
              SectionHeadingWidget(title: "🥇 Overall Top 3 Players", onAll: () => onNavigate(2)),
              PodiumCard(players: [players[0], players[2], players[1]], title: "All-Time Rankings"),
              const SizedBox(height: 16),

              // ── Overall Top 3 ────────────────────────────────────────
              SectionHeadingWidget(title: "🥇 Seasonal Top 3 Players", onAll: () => onNavigate(2)),
              PodiumCard(players: [players[0], players[2], players[1]], title: "Seasonal Rankings"),
              const SizedBox(height: 16),


              // ── TSOTW/M ──────────────────────────────────────────
              SectionHeadingWidget(title: "⭐ Top Score of The Week / Month", sub: "Season 2025 spotlight"),
              Row(children: [
                Expanded(child: TopScorerCard(player: players[0], label: "TSOTW · THIS WEEK", badge: "👑",
                    gradient: const LinearGradient(colors: [Color(0xFF0D1B4E), Color(0xFF1B4FD8)]))),
                const SizedBox(width: 10),
                Expanded(child: TopScorerCard(player: players[1], label: "TSOTM · DECEMBER", badge: "🏆",
                    gradient: const LinearGradient(colors: [Color(0xFF7C2D12), Color(0xFFC2410C)]))),
              ]),
              const SizedBox(height: 16),

              // ── Overall Top Scorer ────────────────────────────────────────
              SectionHeadingWidget(title: "🥇 Overall Top 3 Scorer", onAll: () => onNavigate(2)),
              PodiumCardTwo(players: [players[0], players[2], players[1]], title: "All-Time Rankings"),
              const SizedBox(height: 16),

              // ── Seasonal Top Scorer ────────────────────────────────────────
              SectionHeadingWidget(title: "🥇 Seasonal Top 3 Scorer", onAll: () => onNavigate(2)),
              PodiumCardTwo(players: [players[0], players[2], players[1]], title: "Seasonal Rankings"),
              const SizedBox(height: 16),


              // ── Upcoming Matches ─────────────────────────────────────
              SectionHeadingWidget(title: "🎮 Upcoming Matches", onAll: () => onNavigate(1)),
              ...AppData.matches.where((m) => m.status != "completed").take(3)
                  .map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MatchMiniCard(match: m))),


              // ── Get Rewards CTA ──────────────────────────────────────
              GetRewardsCta(onTap: () => onNavigate(4)),
              const SizedBox(height: 24),
            ]),
          ),
        ]),
      )),
    ]);
  }
}

