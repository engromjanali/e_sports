import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:flutter/material.dart';


class SpotlightCardWidget extends StatelessWidget {
  final PlayerModel player;
  final String label;
  final String badge;
  final Gradient gradient;

  const SpotlightCardWidget({
    required this.player,
    required this.label,
    required this.badge,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    // Demo image fallback
    final imageUrl = "https://i.pravatar.cc/150?img=15";

    // Gold accent consistent with PodiumCardTwo
    const accentColor  = Color(0xFFFFD700);
    const accentDark   = Color(0xFF3D2400);
    const accentLight  = Color(0xFFFFF4C2);

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withOpacity(0.32), width: 1),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.14),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
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
                    accentLight,
                    Colors.transparent,
                  ]),
                ),
              ),
            ),

            // ── Watermark label ──────────────────────────────────────────────
            Positioned(
              right: 2, bottom: 0, top: 2,
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: accentColor.withOpacity(0.08),
                  height: 1,
                  letterSpacing: 2,
                ),
              ),
            ),

            // ── Main content ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 14, 13, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Left: avatar + name + matches ──
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: accentColor.withOpacity(0.35), width: 1),
                        ),
                        child: Text(
                          label.toUpperCase(),
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.6,
                            color: accentColor.withOpacity(0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Avatar with badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Outer glow ring
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: accentColor, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.45),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                imageUrl,
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                                loadingBuilder: (ctx, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    color: accentDark.withOpacity(0.5),
                                    child: Center(
                                      child: SizedBox(
                                        width: 20, height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: accentColor,
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
                                  color: accentDark.withOpacity(0.5),
                                  alignment: Alignment.center,
                                  child: Text(
                                    player.name.isNotEmpty
                                        ? player.name[0].toUpperCase()
                                        : "?",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: accentColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Badge — corner ribbon style
                          Positioned(
                            top: -2,
                            right: -2,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(6),
                              ),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(5, 2, 5, 3),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFB8860B),
                                      accentColor,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Text(
                                  badge,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Name
                      Text(
                        player.short,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${player.matches} matches",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.white.withOpacity(0.45),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  // ── Right: vertical stats ──────────────────────────────────
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32), // align with avatar top
                        _StatRow(
                          label: "Goals",
                          value: "${player.goals}",
                          accentColor: accentColor,
                          fillFraction: (player.goals / 20).clamp(0.0, 1.0),
                        ),
                        const SizedBox(height: 8),
                        _StatRow(
                          label: "Points",
                          value: "${player.pts}",
                          accentColor: accentColor,
                          fillFraction: (player.pts / 100).clamp(0.0, 1.0),
                        ),
                        const SizedBox(height: 8),
                        _StatRow(
                          label: "Win",
                          value: "${player.wins}",
                          accentColor: accentColor,
                          fillFraction: (player.wins / 10).clamp(0.0, 1.0),
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


class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;
  final double fillFraction; // 0.0 – 1.0

  const _StatRow({
    required this.label,
    required this.value,
    required this.accentColor,
    required this.fillFraction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 7, 9, 7),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: accentColor.withOpacity(0.18), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                  color: AppColors.white.withOpacity(0.45),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                // Track
                Container(
                  height: 3,
                  color: AppColors.white.withOpacity(0.08),
                ),
                // Fill
                FractionallySizedBox(
                  widthFactor: fillFraction,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(0.6),
                          accentColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}