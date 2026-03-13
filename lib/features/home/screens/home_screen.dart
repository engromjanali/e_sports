import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/app_header_widget.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:e_sports/core/widgets/my_rank_card_widget.dart';
import 'package:e_sports/core/widgets/news_branner.dart';
import 'package:e_sports/core/widgets/section_heading_widget.dart';
import 'package:e_sports/core/widgets/sport_light_card_widget.dart';
import 'package:e_sports/features/dashboard/screens/dashboard_screen.dart';
import 'package:e_sports/features/home/widgets/diagonal_slash_printer_widget.dart';
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
                Expanded(child: SpotlightCardWidget(player: players[0], label: "POTW · THIS WEEK", badge: "👑",
                    gradient: const LinearGradient(colors: [Color(0xFF0D1B4E), Color(0xFF1B4FD8)]))),
                const SizedBox(width: 10),
                Expanded(child: SpotlightCardWidget(player: players[1], label: "POTM · DECEMBER", badge: "🏆",
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


class TopScorerCard extends StatelessWidget {
  final PlayerModel player;
  final String label, badge;
  final Gradient gradient;

  const TopScorerCard({
    required this.player,
    required this.label,
    required this.badge,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final c = playerColor(player.name);
    final double ratio = player.matches > 0
        ? (player.goals / player.matches)
        : 0.0;

    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: gradient,
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: c.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // ── Diagonal slash background ──────────────────────────────
            Positioned.fill(
              child: CustomPaint(painter: DiagonalSlashPainterWidget(color: c)),
            ),

            // ── Faint corner glow ──────────────────────────────────────
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [c.withOpacity(0.25), Colors.transparent],
                  ),
                ),
              ),
            ),

            // ── Content ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Label pill + badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.15), width: 1),
                        ),
                        child: Text(
                          label.toUpperCase(),
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.75),
                            letterSpacing: 1.6,
                          ),
                        ),
                      ),
                      Text(badge, style: const TextStyle(fontSize: 18)),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Avatar + name block
                  Row(
                    children: [
                      // Avatar circle with initial
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [c, c.withOpacity(0.5)],
                          ),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.3), width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: c.withOpacity(0.5), blurRadius: 10)
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          player.name[0],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Name + matches
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.short.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                                height: 1.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.neonGold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${player.matches} matches",
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    color: Colors.white.withOpacity(0.55),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Divider line
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Hero goals number ──────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${player.goals}",
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 0.9,
                          shadows: [
                            Shadow(
                                color: c.withOpacity(0.6),
                                blurRadius: 16)
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GOALS",
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                color: AppColors.neonGold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              "scored",
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white.withOpacity(0.4),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ── Bottom stat row: Matches · Goals · Ratio ──────
                  Row(
                    children: [
                      StatChipWidget(
                        label: "MTH",
                        value: "${player.matches}",
                        color: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(width: 6),
                      StatChipWidget(
                        label: "FA",
                        value: "${player.fa}",
                        color: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(width: 6),
                      StatChipWidget(
                        label: "RATIO",
                        value: ratio.toStringAsFixed(2),
                        color: AppColors.neonGold,
                        highlight: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatChipWidget extends StatelessWidget {
  final String label, value;
  final Color color;
  final bool highlight;

  const StatChipWidget({
    required this.label,
    required this.value,
    required this.color,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: highlight
              ? AppColors.neonGold.withOpacity(0.15)
              : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: highlight
                ? AppColors.neonGold.withOpacity(0.35)
                : Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                fontSize: 6.5,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.4),
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Scorer3ListWidget extends StatelessWidget {
  final List<PlayerModel> players;
  const Scorer3ListWidget({required this.players});

  @override
  Widget build(BuildContext context) {
    final medals = ["🥇", "🥈", "🥉"];
    final colors = [AppColors.gold, AppColors.silver, AppColors.bronze];

    return GlassCardWidget(
      padding: const EdgeInsets.all(12),
      child: Column(children: List.generate(players.length, (i) {
        final p = players[i];
        final c = playerColor(p.name);
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: i == 0 ? LinearGradient(
              colors: [AppColors.neonGold.withOpacity(0.08), Colors.transparent],
            ) : null,
          ),
          child: Row(children: [
            Text(medals[i], style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [c, c.withOpacity(0.6)]),
              ),
              alignment: Alignment.center,
              child: Text(p.name[0],
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Text("${p.matches}PL · ${p.wins}W",
                  style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text("${p.goals}", style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w900, color: colors[i])),
              const Text("goals", style: TextStyle(fontSize: 7, color: AppColors.textMuted)),
            ]),
          ]),
        );
      })),
    );
  }
}
