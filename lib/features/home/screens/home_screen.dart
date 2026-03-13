import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/app_header_widget.dart';
import 'package:e_sports/core/widgets/brand_title.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:e_sports/core/widgets/my_rank_card_widget.dart';
import 'package:e_sports/core/widgets/news_branner.dart';
import 'package:e_sports/core/widgets/section_heading_widget.dart';
import 'package:e_sports/core/widgets/sport_light_card_widget.dart';
import 'package:e_sports/features/dashboard/screens/dashboard_screen.dart';
import 'package:e_sports/features/home/widgets/diagonal_slash_printer_widget.dart';
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
    return GlassCardWidget(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      borderColor: AppColors.neonGold.withOpacity(0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 3, height: 14,
              decoration: BoxDecoration(
                color: AppColors.neonGold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w900,
                  letterSpacing: 2.5, color: AppColors.textPrimary,
                )),
          ]),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _RankBox(
                player: players[0],
                rank: 1,
                rankLabel: "1ST",
                medal: "🥇",
                gradientColors: [
                  const Color(0xFF3D2400),
                  const Color(0xFFFFD700),
                  const Color(0xFFFFF4C2),
                ],
                glowColor: const Color(0xFFFFD700),
                badgeColor: const Color(0xFFFFD700),
              )),
              const SizedBox(width: 8),
              Expanded(child: _RankBox(
                player: players[1],
                rank: 2,
                rankLabel: "2ND",
                medal: "🥈",
                gradientColors: [
                  const Color(0xFF1A1A1A),
                  const Color(0xFFB8B8B8),
                  const Color(0xFFEEEEEE),
                ],
                glowColor: const Color(0xFFB0B0B0),
                badgeColor: const Color(0xFFC0C0C0),
              )),
              const SizedBox(width: 8),
              Expanded(child: _RankBox(
                player: players[2],
                rank: 3,
                rankLabel: "3RD",
                medal: "🥉",
                gradientColors: [
                  const Color(0xFF2A0F00),
                  const Color(0xFFCD7F32),
                  const Color(0xFFEFBB85),
                ],
                glowColor: const Color(0xFFCD7F32),
                badgeColor: const Color(0xFFCD7F32),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _RankBox extends StatelessWidget {
  final PlayerModel player;
  final int rank;
  final String rankLabel;
  final String medal;
  final List<Color> gradientColors;
  final Color glowColor;
  final Color badgeColor;

  const _RankBox({
    required this.player,
    required this.rank,
    required this.rankLabel,
    required this.medal,
    required this.gradientColors,
    required this.glowColor,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    const double avatarSize   = 80;
    const double overflowAmt  = 10.0;

    // ── Demo fallback image ──────────────────────────────────────────────────
    final demoImages = [
      "https://i.pravatar.cc/150?img=11",
      "https://i.pravatar.cc/150?img=32",
      "https://i.pravatar.cc/150?img=57",
    ];
    final imageUrl =  demoImages[rank - 1];

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // ── Card ─────────────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradientColors[0].withOpacity(0.72),
                gradientColors[0].withOpacity(0.38),
                Colors.transparent,
              ],
            ),
            border: Border.all(
              color: gradientColors[1].withOpacity(0.42), width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(0.18),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                // Shimmer top bar
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.transparent,
                        gradientColors[2].withOpacity(0.9),
                        Colors.transparent,
                      ]),
                    ),
                  ),
                ),

                // Rank watermark
                Positioned(
                  right: -4, bottom: -14,
                  child: Text(
                    rank.toString(),
                    style: TextStyle(
                      fontSize: 90, fontWeight: FontWeight.w900,
                      color: gradientColors[1].withOpacity(0.06), height: 1,
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Space for avatar
                    const SizedBox(height: overflowAmt + (avatarSize / 2) + 20),

                    // Name
                    Text(
                      player.short.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: gradientColors[2].withOpacity(0.95),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Points pill
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: gradientColors[1].withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: gradientColors[1].withOpacity(0.35), width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${player.pts}",
                            style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900,
                              color: gradientColors[1], height: 1,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              "PTS",
                              style: TextStyle(
                                fontSize: 8, fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: gradientColors[1].withOpacity(0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Unique Rank Badge ─────────────────────────────────────────────────
        // Diagonal ribbon in top-right corner
        Positioned(
          top: overflowAmt + 4,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(14),
              bottomLeft: Radius.circular(8),
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 3, 8, 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    badgeColor.withOpacity(0.85),
                    badgeColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    medal,
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    rankLabel,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                      color: rank == 1
                          ? const Color(0xFF3D2400)
                          : rank == 2
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFF2A0F00),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Avatar (10pt overflow) ────────────────────────────────────────────
        Positioned(
          top: -overflowAmt,
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: gradientColors[1], width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(0.5),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                imageUrl,
                width: avatarSize,
                height: avatarSize,
                fit: BoxFit.cover,
                loadingBuilder: (ctx, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: gradientColors[0].withOpacity(0.5),
                    child: Center(
                      child: SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, color: gradientColors[1],
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: gradientColors[0].withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Text(
                    player.name.isNotEmpty
                        ? player.name[0].toUpperCase()
                        : "?",
                    style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w900,
                      color: gradientColors[1],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CrownPainter extends CustomPainter {
  final Color color;
  const _CrownPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Crown base shape
    path.moveTo(0, h);                    // bottom-left
    path.lineTo(0, h * 0.45);            // left side up
    path.lineTo(w * 0.25, h * 0.75);     // left inner dip
    path.lineTo(w * 0.5, 0);             // top center peak
    path.lineTo(w * 0.75, h * 0.75);     // right inner dip
    path.lineTo(w, h * 0.45);            // right side up
    path.lineTo(w, h);                   // bottom-right
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    // Three jewel dots
    final jewel = Paint()..color = Colors.white.withOpacity(0.85);
    canvas.drawCircle(Offset(w * 0.5, h * 0.22), 2.5, jewel);    // center top
    canvas.drawCircle(Offset(w * 0.12, h * 0.56), 2.0, jewel);   // left peak
    canvas.drawCircle(Offset(w * 0.88, h * 0.56), 2.0, jewel);   // right peak
  }

  @override
  bool shouldRepaint(_CrownPainter old) => old.color != color;
}

class PodiumCardTwo extends StatelessWidget {
  final List<PlayerModel> players;
  final String title;
  const PodiumCardTwo({required this.players, required this.title});

  @override
  Widget build(BuildContext context) {
    return GlassCardWidget(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      borderColor: AppColors.neonGold.withOpacity(0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title row ──
          Row(children: [
            Container(
              width: 3, height: 14,
              decoration: BoxDecoration(
                color: AppColors.neonGold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                  color: AppColors.textPrimary,
                )),
          ]),

          const SizedBox(height: 16),

          // ── All 3 boxes in a single row ──
          Row(
            children: [
              // 1st Place — Gold
              Expanded(
                child: _RankBoxTwo(
                  player: players[0],
                  rank: 1,
                  rankLabel: "1ST",
                  gradientColors: [const Color(0xFFB8860B), const Color(0xFFFFD700), const Color(0xFFFFF0A0)],
                  glowColor: const Color(0xFFFFD700),
                  badgeColor: const Color(0xFFFFD700),
                  badgeIcon: Icons.emoji_events_rounded,
                ),
              ),
              const SizedBox(width: 8),
              // 2nd Place — Silver
              Expanded(
                child: _RankBoxTwo(
                  player: players[1],
                  rank: 2,
                  rankLabel: "2ND",
                  gradientColors: [const Color(0xFF6B6B6B), const Color(0xFFB0B0B0), const Color(0xFFE8E8E8)],
                  glowColor: const Color(0xFFB0B0B0),
                  badgeColor: const Color(0xFFC0C0C0),
                  badgeIcon: Icons.military_tech_rounded,
                ),
              ),
              const SizedBox(width: 8),
              // 3rd Place — Bronze
              Expanded(
                child: _RankBoxTwo(
                  player: players[2],
                  rank: 3,
                  rankLabel: "3RD",
                  gradientColors: [const Color(0xFF6B3A1F), const Color(0xFFCD7F32), const Color(0xFFEDA96A)],
                  glowColor: const Color(0xFFCD7F32),
                  badgeColor: const Color(0xFFCD7F32),
                  badgeIcon: Icons.workspace_premium_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _RankBoxTwo extends StatelessWidget {
  final PlayerModel player;
  final int rank;
  final String rankLabel;
  final List<Color> gradientColors;
  final Color glowColor;
  final Color badgeColor;
  final IconData badgeIcon;

  const _RankBoxTwo({
    required this.player,
    required this.rank,
    required this.rankLabel,
    required this.gradientColors,
    required this.glowColor,
    required this.badgeColor,
    required this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    final avatarColor = playerColor(player.name);

    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientColors[0].withOpacity(0.35),
            gradientColors[1].withOpacity(0.15),
            Colors.transparent,
          ],
        ),
        border: Border.all(
          color: gradientColors[1].withOpacity(0.45),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.18),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // ── Shimmer top bar ──
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: 2.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    gradientColors[2].withOpacity(0.9),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),

            // ── Rank watermark ──
            Positioned(
              right: -4, bottom: -10,
              child: Text(
                rank.toString(),
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w900,
                  color: gradientColors[1].withOpacity(0.07),
                  height: 1,
                ),
              ),
            ),

            // ── Content (vertical layout for narrow columns) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Badge icon + rank pill
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(badgeIcon, color: badgeColor, size: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: badgeColor.withOpacity(0.45),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          rankLabel,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: gradientColors[2],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Avatar circle
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: avatarColor.withOpacity(0.2),
                      border: Border.all(
                        color: gradientColors[1].withOpacity(0.6),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        player.name.isNotEmpty ? player.name[0].toUpperCase() : "?",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: gradientColors[2],
                        ),
                      ),
                    ),
                  ),

                  // Name + score
                  Column(
                    children: [
                      Text(
                        player.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: gradientColors[2],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${"player.score"} pts",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: gradientColors[1].withOpacity(0.85),
                        ),
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

class _PodiumSlot extends StatelessWidget {
  final PlayerModel player;
  final String rank;
  final Color accentColor;
  final Color avatarColor;
  final double height;
  final bool isFirst;

  const _PodiumSlot({
    required this.player,
    required this.rank,
    required this.accentColor,
    required this.avatarColor,
    required this.height,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Card body ──
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isFirst
                ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1C3F9E), Color(0xFF0A1640)],
            )
                : LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.bgSurface.withOpacity(0.9),
                AppColors.bgSurface,
              ],
            ),
            border: Border.all(color: accentColor.withOpacity(isFirst ? 0.6 : 0.25), width: 1),
            boxShadow: isFirst
                ? [
              BoxShadow(color: accentColor.withOpacity(0.25), blurRadius: 20, spreadRadius: -2),
              BoxShadow(color: accentColor.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2)),
            ]
                : [
              BoxShadow(color: accentColor.withOpacity(0.1), blurRadius: 8),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top section: avatar
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: Column(children: [
                  // Avatar ring
                  Container(
                    width: isFirst ? 46 : 38,
                    height: isFirst ? 46 : 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [avatarColor, avatarColor.withOpacity(0.5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: accentColor, width: isFirst ? 2.5 : 1.5),
                      boxShadow: [
                        BoxShadow(color: accentColor.withOpacity(0.45), blurRadius: isFirst ? 14 : 8),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      player.name[0],
                      style: TextStyle(
                        fontSize: isFirst ? 18 : 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
              ),

              // Bottom section: name + score
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
                child: Column(children: [
                  Text(
                    player.short,
                    style: TextStyle(
                      fontSize: isFirst ? 10 : 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                      color: isFirst ? Colors.white : AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Score pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accentColor.withOpacity(0.4), width: 1),
                    ),
                    child: Text(
                      "${player.pts}",
                      style: TextStyle(
                        fontSize: isFirst ? 13 : 11,
                        fontWeight: FontWeight.w900,
                        color: accentColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text("pts",
                      style: TextStyle(fontSize: 7, color: Colors.white.withOpacity(0.3), letterSpacing: 1)),
                ]),
              ),
            ],
          ),
        ),

        // ── Rank badge (top-center, floating) ──
        Positioned(
          top: -12,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: isFirst ? 26 : 22,
              height: isFirst ? 26 : 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor,
                boxShadow: [
                  BoxShadow(color: accentColor.withOpacity(0.6), blurRadius: isFirst ? 12 : 6),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                rank,
                style: TextStyle(
                  fontSize: isFirst ? 11 : 9,
                  fontWeight: FontWeight.w900,
                  color: isFirst ? const Color(0xFF0A1640) : Colors.white,
                ),
              ),
            ),
          ),
        ),

        // ── Gold crown glow streak (1st only) ──
        if (isFirst)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.neonGold.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
      ],
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

