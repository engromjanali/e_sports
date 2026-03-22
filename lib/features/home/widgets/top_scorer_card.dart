import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/features/home/widgets/diagonal_slash_printer_widget.dart';
import 'package:e_sports/features/home/widgets/stat_chip_widget.dart';
import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        gradient: gradient,
        border: Border.all(color: AppColors.white.withOpacity(0.08), width: 1),
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
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
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
                          color: AppColors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: AppColors.white.withOpacity(0.15), width: 1),
                        ),
                        child: Text(
                          label.toUpperCase(),
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.w900,
                            color: AppColors.white.withOpacity(0.75),
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
                              color: AppColors.white.withOpacity(0.3), width: 2),
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
                            color: AppColors.white,
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
                                color: AppColors.white,
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
                                    color: AppColors.white.withOpacity(0.55),
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
                          AppColors.white.withOpacity(0.0),
                          AppColors.white.withOpacity(0.15),
                          AppColors.white.withOpacity(0.0),
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
                          color: AppColors.white,
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
                                color: AppColors.white.withOpacity(0.4),
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
                        color: AppColors.white.withOpacity(0.7),
                      ),
                      const SizedBox(width: 6),
                      StatChipWidget(
                        label: "Win",
                        value: "${player.wins}",
                        color: AppColors.white.withOpacity(0.7),
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
