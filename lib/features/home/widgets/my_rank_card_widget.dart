import 'package:e_sports/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MyRankCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const gold       = Color(0xFFFFD700);
    const goldDark   = Color(0xFFB8860B);
    const goldDeep   = Color(0xFF3D2400);
    const goldLight  = Color(0xFFFFF4C2);
    const bgDark     = Color(0xFF1A0F00);

    String wlabel = "300075";
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
            color: gold.withOpacity(0.16),
            blurRadius: 22,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // ── Shimmer top bar ──────────────────────────────────────────────
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

            // ── Giant ghost rank number ──────────────────────────────────────
            Positioned(
              right: 0, top: 10,
              child: SizedBox(
                width: 300,
                child: Text(
                  "#$wlabel",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: wlabel.length > 5 ? 60 : 80,
                    fontWeight: FontWeight.w900,
                    color: gold.withOpacity(0.07),
                    height: 1,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
              ),
            ),

            // ── Content ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── Top row: avatar left, rank center, tier right ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Network Avatar
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: gold, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: gold.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            "https://i.pravatar.cc/150?img=8",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: goldDeep,
                              alignment: Alignment.center,
                              child: const Text("A",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: gold,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Name + handle + badges
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Aryan Bhuiyan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              "@yourhandle",
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.white.withOpacity(0.4),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Row(
                              children: [
                                // Ribbon rank badge
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    bottomLeft: Radius.circular(6),
                                    topRight: Radius.circular(3),
                                    bottomRight: Radius.circular(3),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        8, 3, 8, 4),
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [goldDark, gold],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: const Text(
                                      "RANK #1",
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.4,
                                        color: goldDeep,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // Elite ghost pill
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: gold.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: gold.withOpacity(0.35),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    "ELITE GAMER",
                                    style: TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                      color: goldLight.withOpacity(0.9),
                                    ),
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

                  // ── Gold divider ─────────────────────────────────────────
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.transparent,
                        gold.withOpacity(0.25),
                        Colors.transparent,
                      ]),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Stat chips row ───────────────────────────────────────
                  Row(
                    children: [
                      _StatChip(label: "PTS",     value: "946",  gold: gold, goldDeep: goldDeep),
                      const SizedBox(width: 8),
                      _StatChip(label: "GOALS",   value: "34",   gold: gold, goldDeep: goldDeep),
                      const SizedBox(width: 8),
                      _StatChip(label: "WINS",    value: "21",   gold: gold, goldDeep: goldDeep),
                      const SizedBox(width: 8),
                      _StatChip(label: "MATCHES", value: "38",   gold: gold, goldDeep: goldDeep),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Progress row ─────────────────────────────────────────
                  Row(
                    children: [
                      Text(
                        "SEASON XP",
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.3,
                          color: AppColors.white.withOpacity(0.35),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "82 / 100",
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white.withOpacity(0.35),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      children: [
                        Container(
                          height: 6,
                          color: AppColors.white.withOpacity(0.07),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.82,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: const LinearGradient(
                                colors: [goldDark, gold, goldLight],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color gold;
  final Color goldDeep;

  const _StatChip({
    required this.label,
    required this.value,
    required this.gold,
    required this.goldDeep,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: gold.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: gold.withOpacity(0.22),
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
                color: gold,
                height: 1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
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

