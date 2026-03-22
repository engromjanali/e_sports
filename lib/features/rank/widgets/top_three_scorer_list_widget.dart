import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/utils/styles.dart';
import 'package:flutter/material.dart';

class TopThreeScorersWidget extends StatelessWidget {
  final List<PlayerModel> players;
  const TopThreeScorersWidget({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    const gold      = Color(0xFFFFD700);
    const goldDark  = Color(0xFFB8860B);
    const goldDeep  = Color(0xFF3D2400);
    const goldLight = Color(0xFFFFF4C2);
    const bgDark    = Color(0xFF1A0F00);

    const rankLabels = ["1ST", "2ND", "3RD"];
    const rankEmoji  = ["🥇", "🥈", "🥉"];
    const medalColors = [gold, Color(0xFFB8B8B8), Color(0xFFCD7F32)];

    final demoImages = [
      "https://i.pravatar.cc/150?img=11",
      "https://i.pravatar.cc/150?img=32",
      "https://i.pravatar.cc/150?img=57",
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [goldDeep, bgDark, Color(0xFF2A1800)],
        ),
        border: Border.all(color: gold.withOpacity(0.28), width: 1),
        boxShadow: [
          BoxShadow(
            color: gold.withOpacity(0.14),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        child: Stack(
          children: [
            // ── Shimmer top bar ──────────────────────────────────────────
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


            // ── List ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Column(
                children: List.generate(players.length, (i) {
                  final p = players[i];
                  final accent = medalColors[i];
                  final imageUrl = demoImages[i];
                  final isFirst = i == 0;

                  return Container(
                    margin: EdgeInsets.only(bottom: i < players.length - 1 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isFirst
                          ? gold.withOpacity(0.08)
                          : AppColors.white.withOpacity(0.03),
                      border: Border.all(
                        color: accent.withOpacity(isFirst ? 0.38 : 0.18),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // ── Rank ribbon ──────────────────────────────────
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                            topRight: Radius.circular(3),
                            bottomRight: Radius.circular(3),
                          ),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(6, 3, 6, 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: i == 0
                                    ? [goldDark, gold]
                                    : [
                                  accent.withOpacity(0.7),
                                  accent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Text(
                              rankLabels[i],
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.3,
                                color: i == 0
                                    ? goldDeep
                                    : const Color(0xFF1A0F00),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // ── Network avatar ───────────────────────────────
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: accent,
                              width: isFirst ? 2.5 : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withOpacity(isFirst ? 0.4 : 0.2),
                                blurRadius: isFirst ? 10 : 6,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              imageUrl,
                              width: 42,
                              height: 42,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: goldDeep,
                                alignment: Alignment.center,
                                child: Text(
                                  p.name.isNotEmpty ? p.name[0].toUpperCase() : "?",
                                  style: robotoBold.copyWith(color: accent, fontSize: Dimensions.fontSizeLarge),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // ── Name + meta ──────────────────────────────────
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${p.matches}PL · ${p.wins}W",
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.white.withOpacity(0.38),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Goals chip ───────────────────────────────────
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            border: Border.all(
                              color: accent.withOpacity(0.30),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "${p.goals}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: accent,
                                  height: 1,
                                ),
                              ),
                              Text(
                                "GOALS",
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
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}