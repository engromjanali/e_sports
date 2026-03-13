import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

// class Scorer3ListWidget extends StatelessWidget {
//   final List<PlayerModel> players;
//   const Scorer3ListWidget({required this.players});
//
//   @override
//   Widget build(BuildContext context) {
//     final medals = ["🥇", "🥈", "🥉"];
//     final colors = [AppColors.gold, AppColors.silver, AppColors.bronze];
//
//     return GlassCardWidget(
//       padding: const EdgeInsets.all(12),
//       child: Column(children: List.generate(players.length, (i) {
//         final p = players[i];
//         final c = playerColor(p.name);
//         return Container(
//           padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
//           margin: const EdgeInsets.only(bottom: 6),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             gradient: i == 0 ? LinearGradient(
//               colors: [AppColors.neonGold.withOpacity(0.08), Colors.transparent],
//             ) : null,
//           ),
//           child: Row(children: [
//             Text(medals[i], style: const TextStyle(fontSize: 18)),
//             const SizedBox(width: 8),
//             Container(
//               width: 34, height: 34,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 gradient: LinearGradient(colors: [c, c.withOpacity(0.6)]),
//               ),
//               alignment: Alignment.center,
//               child: Text(p.name[0],
//                   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
//             ),
//             const SizedBox(width: 8),
//             Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(p.name, style: const TextStyle(
//                   fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
//               Text("${p.matches}PL · ${p.wins}W",
//                   style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
//             ])),
//             Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//               Text("${p.goals}", style: TextStyle(
//                   fontSize: 16, fontWeight: FontWeight.w900, color: colors[i])),
//               const Text("goals", style: TextStyle(fontSize: 7, color: AppColors.textMuted)),
//             ]),
//           ]),
//         );
//       })),
//     );
//   }
// }

class Scorer3ListWidget extends StatelessWidget {
  final List<PlayerModel> players;
  const Scorer3ListWidget({required this.players});

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
        borderRadius: BorderRadius.circular(20),
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
        borderRadius: BorderRadius.circular(20),
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
                          : Colors.white.withOpacity(0.03),
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
                                  p.name.isNotEmpty
                                      ? p.name[0].toUpperCase()
                                      : "?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: accent,
                                  ),
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
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${p.matches}PL · ${p.wins}W",
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.white.withOpacity(0.38),
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
                            borderRadius: BorderRadius.circular(10),
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
                                  color: Colors.white.withOpacity(0.35),
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