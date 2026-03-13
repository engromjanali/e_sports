import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/app_header_widget.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:e_sports/core/widgets/neon_pill_widget.dart';
import 'package:e_sports/core/widgets/neon_pregress_bar_widget.dart';
import 'package:e_sports/core/widgets/section_heading_widget.dart';
import 'package:flutter/material.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'main.dart';


class QuickNavItem extends StatelessWidget {
  final String icon, label, sub;
  final Color color;
  final VoidCallback onTap;
  const QuickNavItem({required this.icon, required this.label, required this.sub, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: GestureDetector(
      onTap: onTap,
      child: GlassCardWidget(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
        borderColor: color.withOpacity(0.2),
        child: Column(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: color.withOpacity(0.12),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text(sub, style: const TextStyle(fontSize: 8, color: AppColors.textMuted)),
        ]),
      ),
    ));
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
              child: CustomPaint(painter: _DiagonalSlashPainter(color: c)),
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
                      _StatChip(
                        label: "MTH",
                        value: "${player.matches}",
                        color: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(width: 6),
                      _StatChip(
                        label: "FA",
                        value: "${player.fa}",
                        color: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(width: 6),
                      _StatChip(
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

// ── Compact stat chip ──────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label, value;
  final Color color;
  final bool highlight;

  const _StatChip({
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

// ── Diagonal slash background painter ─────────────────────────────────────────
class _DiagonalSlashPainter extends CustomPainter {
  final Color color;
  const _DiagonalSlashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color.withOpacity(0.12), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.55)
      ..lineTo(size.width * 0.75, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.45)
      ..lineTo(size.width * 0.25, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Thin accent line
    final linePaint = Paint()
      ..color = color.withOpacity(0.25)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.55),
      Offset(size.width * 0.75, 0),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(_DiagonalSlashPainter old) => old.color != color;
}


class Scorer3List extends StatelessWidget {
  final List<PlayerModel> players;
  const Scorer3List({required this.players});

  @override
  Widget build(BuildContext context) {
    final medals = ["🥇", "🥈", "🥉"];
    final colors = [AppColors.gold, AppColors.silver, AppColors.bronze];

    return GlassCard(
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





// ══════════════════════════════════════════════════════════════════════════════
// PROFILE SCREEN
// ══════════════════════════════════════════════════════════════════════════════
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppData.players[0];
    final last15 = AppData.last15;

    return Column(children: [
      const AppHeader(sub: "My Profile"),
      Expanded(child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [

          // ── Hero card ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF0D1B4E), Color(0xFF1B4FD8), Color(0xFF1440B8)],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(color: AppColors.neonBlue.withOpacity(0.25), blurRadius: 20)],
            ),
            child: Column(children: [
              Row(children: [
                Stack(clipBehavior: Clip.none, children: [
                  PlayerAvatar(name: p.name, size: 70, borderColor: AppColors.neonGold),
                  Positioned(top: -10, right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.neonGold,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.5), blurRadius: 8)],
                      ),
                      child: const Text("👑", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ]),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.name, style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                  Text("@${p.short.toLowerCase()}",
                    style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5))),
                  const SizedBox(height: 8),
                  Row(children: [
                    NeonPillWidget(label: "RANK #1", color: AppColors.neonGold),
                    const SizedBox(width: 6),
                    NeonPillWidget(label: "VIP", color: AppColors.neonCyan),
                  ]),
                ])),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                for (final stat in [
                  ("${p.pts}", "POINTS"),
                  ("${p.goals}", "GOALS"),
                  ("${p.wins}", "WINS"),
                  ("${p.matches}", "MATCHES"),
                ]) Expanded(child: Column(children: [
                  Text(stat.$1, style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.neonGold)),
                  Text(stat.$2,
                    style: TextStyle(fontSize: 8, color: Colors.white.withOpacity(0.4), letterSpacing: 1)),
                ])),
              ]),
            ]),
          ),
          const SizedBox(height: 16),

          // ── Last 15 Results ──────────────────────────────────────────
          SectionHeadingWidget(title: "📋 Last 15 Results"),
          GlassCardWidget(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 6, runSpacing: 6,
              children: List.generate(last15.length, (i) {
                final r = last15[i];
                final color = r == "win" ? AppColors.neonGreen :
                              r == "loss" ? AppColors.neonRed : AppColors.neonGold;
                return Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.4)),
                    boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 6)],
                  ),
                  alignment: Alignment.center,
                  child: Text(r[0].toUpperCase(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color)),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // ── Achievements ─────────────────────────────────────────────
          SectionHeadingWidget(title: "🏅 Achievements"),
          GlassCardWidget(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 10, runSpacing: 10,
              children: AppData.achievements.map((a) {
                final unlocked = a['unlocked'] as bool;
                return Container(
                  width: 74,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: unlocked ? AppColors.neonGold.withOpacity(0.08) : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: unlocked ? AppColors.neonGold.withOpacity(0.3) : AppColors.glassBorder),
                    boxShadow: unlocked ? [BoxShadow(color: AppColors.neonGold.withOpacity(0.1), blurRadius: 8)] : [],
                  ),
                  child: Column(children: [
                    Text(a['icon'] as String,
                      style: TextStyle(fontSize: 24, color: unlocked ? null : null),
                    ).withOpacity(unlocked ? 1.0 : 0.3),
                    const SizedBox(height: 6),
                    Text(a['label'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9, fontWeight: FontWeight.w700,
                        color: unlocked ? AppColors.textPrimary : AppColors.textMuted,
                      )),
                  ]),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // ── Stats grid ───────────────────────────────────────────────
          SectionHeadingWidget(title: "📊 Detailed Stats"),
          GlassCardWidget(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              for (final stat in [
                ("⚽", "Goals", p.goals, 200),
                ("🏆", "Wins",  p.wins,  400),
                ("🎮", "Matches", p.matches, 500),
                ("🎩", "Hat-tricks", p.hattricks, 20),
                ("🧤", "Clean Sheets", p.cleansheets, 50),
              ]) Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      Text(stat.$1, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(stat.$2, style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ]),
                    Text("${stat.$3}", style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.neonGold)),
                  ]),
                  const SizedBox(height: 5),
                  NeonProgressBarWidget(value: stat.$3.toDouble(), max: stat.$4.toDouble(), color: AppColors.neonCyan),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 24),
        ]),
      )),
    ]);
  }
}

extension WidgetOpacity on Widget {
  Widget withOpacity(double opacity) => Opacity(opacity: opacity, child: this);
}
