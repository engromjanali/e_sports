import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _RankBoxTwo(
                  player: players[0],
                  rank: 1,
                  rankLabel: "1ST",
                  gradientColors: [
                    const Color(0xFFB8860B),
                    const Color(0xFFFFD700),
                    const Color(0xFFFFF0A0)
                  ],
                  glowColor: const Color(0xFFFFD700),
                  badgeColor: const Color(0xFFFFD700),
                  badgeIcon: Icons.emoji_events_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _RankBoxTwo(
                  player: players[1],
                  rank: 2,
                  rankLabel: "2ND",
                  gradientColors: [
                    const Color(0xFF6B6B6B),
                    const Color(0xFFB0B0B0),
                    const Color(0xFFE8E8E8)
                  ],
                  glowColor: const Color(0xFFB0B0B0),
                  badgeColor: const Color(0xFFC0C0C0),
                  badgeIcon: Icons.military_tech_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _RankBoxTwo(
                  player: players[2],
                  rank: 3,
                  rankLabel: "3RD",
                  gradientColors: [
                    const Color(0xFF6B3A1F),
                    const Color(0xFFCD7F32),
                    const Color(0xFFEDA96A)
                  ],
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
        border: Border.all(color: gradientColors[1].withOpacity(0.45), width: 1),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                            color: badgeColor.withOpacity(0.45), width: 1,
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
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: avatarColor.withOpacity(0.2),
                      border: Border.all(
                        color: gradientColors[1].withOpacity(0.6), width: 1.5,
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
                        "player.score pts",
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
