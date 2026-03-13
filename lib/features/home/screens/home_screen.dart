import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/app_header_widget.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:e_sports/core/widgets/my_rank_card_widget.dart';
import 'package:e_sports/core/widgets/news_branner.dart';
import 'package:e_sports/core/widgets/section_heading_widget.dart';
import 'package:e_sports/game_arena_screen.dart';
import 'package:e_sports/main.dart';
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
          SectionHeadingWidget(title: "📍 My Rank"),
          MyRankCard(),
          const SizedBox(height: 14),


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
                Expanded(child: SpotlightCard(player: players[0], label: "POTW · THIS WEEK", badge: "👑",
                    gradient: const LinearGradient(colors: [Color(0xFF0D1B4E), Color(0xFF1B4FD8)]))),
                const SizedBox(width: 10),
                Expanded(child: SpotlightCard(player: players[1], label: "POTM · DECEMBER", badge: "🏆",
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

              // ── Overall Top 3 ────────────────────────────────────────
              SectionHeadingWidget(title: "🥇 Overall Top 3 Scorer", onAll: () => onNavigate(2)),
              PodiumCard(players: [players[0], players[2], players[1]], title: "All-Time Rankings"),
              const SizedBox(height: 16),

              // ── Overall Top 3 ────────────────────────────────────────
              SectionHeadingWidget(title: "🥇 Seasonal Top 3 Scorer", onAll: () => onNavigate(2)),
              PodiumCard(players: [players[0], players[2], players[1]], title: "Seasonal Rankings"),
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

class GetRewardsCta extends StatelessWidget {
  final VoidCallback onTap;
  const GetRewardsCta({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1a0a2e), Color(0xFF2d1b5e)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.neonPurple.withOpacity(0.25)),
          boxShadow: [BoxShadow(color: AppColors.neonPurple.withOpacity(0.15), blurRadius: 20)],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("GET REWARDS", style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.neonGold, letterSpacing: 1.5)),
            const SizedBox(height: 3),
            const Text("Unlock Badges & Trophies",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.neonPurple.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: AppColors.neonPurple.withOpacity(0.4), blurRadius: 12)],
              ),
              child: const Text("Claim Now →",
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ]),
          const Text("🏆", style: TextStyle(fontSize: 52)),
        ]),
      ),
    );
  }
}

class PodiumCard extends StatelessWidget {
  final List<PlayerModel> players;
  final String title;
  const PodiumCard({required this.players, required this.title});

  @override
  Widget build(BuildContext context) {
    // Order: 2nd, 1st, 3rd for podium visual
    final order = [players[1], players[0], players[2]];
    final medals = ["🥈", "🥇", "🥉"];
    final colors = [AppColors.silver, AppColors.gold, AppColors.bronze];
    final heights = [128.0, 152.0, 112.0];
    final isFirst = [false, true, false];

    return GlassCardWidget(
      padding: const EdgeInsets.all(14),
      borderColor: AppColors.neonGold.withOpacity(0.15),
      child: Column(children: [
        Text(title, style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(3, (i) {
            final p = order[i];
            final c = playerColor(p.name);
            return Expanded(child: Container(
              height: heights[i],
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.fromLTRB(6, 10, 6, 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: isFirst[i]
                    ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Color(0xFF1B3A8A), Color(0xFF0D1B4E)])
                    : null,
                color: isFirst[i] ? null : AppColors.bgSurface,
                border: Border.all(color: colors[i].withOpacity(0.35), width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Text(medals[i], style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 3),
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [c, c.withOpacity(0.6)]),
                        border: Border.all(color: colors[i], width: 2),
                        boxShadow: [BoxShadow(color: colors[i].withOpacity(0.4), blurRadius: 8)],
                      ),
                      alignment: Alignment.center,
                      child: Text(p.name[0],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ]),
                  Column(children: [
                    Text(p.short,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                            color: isFirst[i] ? Colors.white : AppColors.textPrimary),
                        textAlign: TextAlign.center),
                    Text("${p.pts}",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: colors[i])),
                    Text("pts", style: TextStyle(
                        fontSize: 7, color: Colors.white.withOpacity(0.4))),
                  ]),
                ],
              ),
            ));
          }),
        ),
      ]),
    );
  }
}

class MatchMiniCard extends StatelessWidget {
  final MatchModel match;
  const MatchMiniCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final isLive = match.status == "live";
    return GlassCardWidget(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      borderColor: isLive ? AppColors.neonRed.withOpacity(0.3) : AppColors.glassBorder,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Text(match.i1, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(match.t1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ]),
          Column(children: [
            Text(match.date, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
            Text(match.time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            if (isLive) Row(children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.neonRed)),
              const SizedBox(width: 3),
              const Text("LIVE", style: TextStyle(fontSize: 9, color: AppColors.neonRed, fontWeight: FontWeight.w800)),
            ]),
          ]),
          Row(children: [
            Text(match.t2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(width: 8),
            Text(match.i2, style: const TextStyle(fontSize: 22)),
          ]),
        ],
      ),
    );
  }
}
