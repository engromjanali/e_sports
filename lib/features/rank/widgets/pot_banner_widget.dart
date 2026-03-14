import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/main.dart';
import 'package:flutter/material.dart';

class PotBannerWidget extends StatelessWidget {
  final PlayerModel player;
  final String label;
  final String badge;
  final Gradient gradient;

  const PotBannerWidget({
    required this.player,
    required this.label,
    required this.gradient,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    const gold      = Color(0xFFFFD700);
    const goldDark  = Color(0xFFB8860B);
    const goldDeep  = Color(0xFF3D2400);
    const goldLight = Color(0xFFFFF4C2);
    const bgDark    = Color(0xFF1A0F00);

    final imageUrl = "https://i.pravatar.cc/150?img=20";

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [goldDeep, bgDark, Color(0xFF2A1800)],
        ),
        border: Border.all(color: gold.withOpacity(0.28), width: 1),
        boxShadow: [
          BoxShadow(
            color: gold.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // ── Shimmer top bar ────────────────────────────────────────────
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    goldLight,
                    Colors.transparent,
                  ]),
                ),
              ),
            ),

            // ── Ghost watermark ────────────────────────────────────────────
            Positioned(
              right: 2, top: 2,
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 75,
                  color: gold.withOpacity(0.05),
                  height: 1,
                ),
              ),
            ),

            // ── Content ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Top: avatar + info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── Avatar with 10pt overflow badge ──
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: gold, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: gold.withOpacity(0.42),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                imageUrl,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: goldDeep,
                                  alignment: Alignment.center,
                                  child: Text(
                                    player.name.isNotEmpty
                                        ? player.name[0].toUpperCase()
                                        : "?",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: gold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Corner ribbon badge
                          // Positioned(
                          //   top: -2, right: -2,
                          //   child: ClipRRect(
                          //     borderRadius: const BorderRadius.only(
                          //       topRight: Radius.circular(10),
                          //       bottomLeft: Radius.circular(6),
                          //     ),
                          //     child: Container(
                          //       padding: const EdgeInsets.fromLTRB(5, 2, 5, 3),
                          //       decoration: const BoxDecoration(
                          //         gradient: LinearGradient(
                          //           colors: [goldDark, gold],
                          //           begin: Alignment.topLeft,
                          //           end: Alignment.bottomRight,
                          //         ),
                          //       ),
                          //       child: Text(
                          //         badge,
                          //         style: const TextStyle(fontSize: 11),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),

                      const SizedBox(width: 14),

                      // ── Name + label + badges ──
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Label pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: gold.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: gold.withOpacity(0.35),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                label.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  color: gold.withOpacity(0.9),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),

                            // Player name
                            Text(
                              player.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.white,
                              ),
                            ),

                            // Matches
                            Text(
                              "${player.matches} matches",
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.white.withOpacity(0.4),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Gold divider ──────────────────────────────────────────
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.transparent,
                        gold.withOpacity(0.22),
                        Colors.transparent,
                      ]),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Stat chips ────────────────────────────────────────────
                  Row(
                    children: [
                      StatMiniWidget(
                          label: "Goals",
                          value: "${player.goals}",
                          color: gold),
                      const SizedBox(width: 8),
                      StatMiniWidget(
                          label: "Points",
                          value: "${player.pts}",
                          color: gold),
                      const SizedBox(width: 8),
                      StatMiniWidget(
                          label: "FA",
                          value: "${player.fa}",
                          color: gold),
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

// ─────────────────────────────────────────────────────────────────────────────

class StatMiniWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatMiniWidget({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    const gold      = Color(0xFFFFD700);
    const goldDeep  = Color(0xFF3D2400);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: gold.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: gold.withOpacity(0.20),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: color,
                height: 1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: AppColors.white.withOpacity(0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}