import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

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
              width: 3,
              height: 14,
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
    const double avatarSize = 80;
    const double overflowAmt = 10.0;

    final demoImages = [
      "https://i.pravatar.cc/150?img=11",
      "https://i.pravatar.cc/150?img=32",
      "https://i.pravatar.cc/150?img=57",
    ];
    final imageUrl = demoImages[rank - 1];

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
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
            border: Border.all(color: gradientColors[1].withOpacity(0.42), width: 1),
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
                Positioned(
                  right: -4, bottom: -14,
                  child: Text(
                    rank.toString(),
                    style: TextStyle(
                      fontSize: 90,
                      fontWeight: FontWeight.w900,
                      color: gradientColors[1].withOpacity(0.06),
                      height: 1,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: overflowAmt + (avatarSize / 2) + 20),
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
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: gradientColors[1],
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              "PTS",
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
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
                  colors: [badgeColor.withOpacity(0.85), badgeColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(medal, style: const TextStyle(fontSize: 10)),
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
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: gradientColors[1],
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
                    player.name.isNotEmpty ? player.name[0].toUpperCase() : "?",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
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
