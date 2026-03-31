import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

class PodiumCard extends StatelessWidget {
  final List<ComputedPlayerStats> players;
  final String title;
  final Color? accentColor;
  final String statLabel;
  final AlignmentGeometry badgeAlignment;

  const PodiumCard({
    required this.players,
    required this.title,
    this.accentColor,
    this.statLabel = "PTS",
    this.badgeAlignment = Alignment.topRight,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = accentColor ?? AppColors.neonGold;

    return GlassCardWidget(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.cardInnerPadding,
        AppSpacing.xxxl,
        AppSpacing.cardInnerPadding,
        AppSpacing.cardInnerPadding,
      ),
      borderColor: themeColor.withOpacity(AppColors.opacity12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: AppSpacing.xs,
              height: AppSizing.dotLg * 2,
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: AppRadius.borderXxs,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Text(title.toUpperCase(),
                style: TextStyle(
                  fontSize: AppTypography.sizeSmall,
                  fontWeight: AppTypography.black,
                  letterSpacing: AppTypography.trackingMax,
                  color: AppColors.textPrimary,
                )),
          ]),
          SizedBox(height: AppSpacing.massive),
          Row(
            children: [
              Expanded(child: _RankBox(
                player: players[0],
                rank: 1,
                rankLabel: "1ST",
                gradientColors: AppColors.podiumGradientColors[0],
                glowColor: accentColor ?? AppColors.podiumGlowColors[0],
                badgeColor: AppColors.podiumBadgeColors[0],
                statLabel: statLabel,
                badgeAlignment: badgeAlignment,
              )),
              SizedBox(width: AppSpacing.md),
              Expanded(child: _RankBox(
                player: players[1],
                rank: 2,
                rankLabel: "2ND",
                gradientColors: AppColors.podiumGradientColors[1],
                glowColor: accentColor?.withOpacity(0.5) ?? AppColors.podiumGlowColors[1],
                badgeColor: AppColors.podiumBadgeColors[1],
                statLabel: statLabel,
                badgeAlignment: badgeAlignment,
              )),
              SizedBox(width: AppSpacing.md),
              Expanded(child: _RankBox(
                player: players[2],
                rank: 3,
                rankLabel: "3RD",
                gradientColors: AppColors.podiumGradientColors[2],
                glowColor: accentColor?.withOpacity(0.3) ?? AppColors.podiumGlowColors[2],
                badgeColor: AppColors.podiumBadgeColors[2],
                statLabel: statLabel,
                badgeAlignment: badgeAlignment,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankBox extends StatelessWidget {
  final ComputedPlayerStats player;
  final int rank;
  final String rankLabel;
  final List<Color> gradientColors;
  final Color glowColor;
  final Color badgeColor;
  final String statLabel;
  final AlignmentGeometry badgeAlignment;

  const _RankBox({
    required this.player,
    required this.rank,
    required this.rankLabel,
    required this.gradientColors,
    required this.glowColor,
    required this.badgeColor,
    required this.statLabel,
    required this.badgeAlignment,
  });

  @override
  Widget build(BuildContext context) {
    const double avatarSize = AppSizing.avatarPodium;
    const double overflowAmt = 10.0;

    final imageUrl = player.player.imageUrl;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderLg + const BorderRadius.all(Radius.circular(2)),
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
              color: gradientColors[1].withOpacity(AppColors.opacity45 - 0.03),
              width: AppSizing.borderThin,
            ),
            boxShadow: AppElevation.accentGlow(glowColor, opacity: AppColors.opacity18, blur: 14, offset: const Offset(0, 5)),
          ),
          child: ClipRRect(
            borderRadius: AppRadius.borderLg,
            child: Stack(
              children: [
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: Container(
                    height: AppSizing.shimmerHeight,
                    decoration: BoxDecoration(
                      gradient: AppColors.shimmerGradient(color: gradientColors[2].withOpacity(AppColors.opacity90)),
                    ),
                  ),
                ),
                Positioned(
                  right: -4, bottom: -14,
                  child: Text(
                    rank.toString(),
                    style: TextStyle(
                      fontSize: AppTypography.sizeGhostXl,
                      fontWeight: AppTypography.black,
                      color: gradientColors[1].withOpacity(0.06),
                      height: AppTypography.lineHeightCompact,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: overflowAmt + (avatarSize / 2) + 20),
                    Text(
                      player.short.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppTypography.sizeSubtitle,
                        fontWeight: AppTypography.bold,
                        letterSpacing: AppTypography.trackingWider,
                        color: gradientColors[2].withOpacity(0.95),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.iconGap),
                      decoration: BoxDecoration(
                        color: gradientColors[1].withOpacity(AppColors.opacity12),
                        borderRadius: AppRadius.borderDef,
                        border: Border.all(
                          color: gradientColors[1].withOpacity(AppColors.opacity35),
                          width: AppSizing.borderThin,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                statLabel == "GOALS" ? "${player.goals}" : "${player.pts}",
                                style: TextStyle(
                                  fontSize: AppTypography.sizeHeadingLg,
                                  fontWeight: AppTypography.black,
                                  color: gradientColors[1],
                                  height: AppTypography.lineHeightCompact,
                                ),
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Padding(
                                padding: EdgeInsets.only(bottom: AppSpacing.xxs),
                                child: Text(
                                  statLabel,
                                  style: TextStyle(
                                    fontSize: AppTypography.sizeTiny,
                                    fontWeight: AppTypography.extraBold,
                                    letterSpacing: AppTypography.trackingWider,
                                    color: gradientColors[1].withOpacity(AppColors.opacity60),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                            child: Divider(
                              height: 1, 
                              thickness: 0.5, 
                              color: gradientColors[1].withOpacity(AppColors.opacity12)
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildMiniStat("M", player.matches, gradientColors[1]),
                              _buildDivider(gradientColors[1]),
                              _buildMiniStat("W", player.wins, gradientColors[1]),
                              _buildDivider(gradientColors[1]),
                              _buildMiniStat("D", player.draws, gradientColors[1]),
                              _buildDivider(gradientColors[1]),
                              _buildMiniStat("L", player.losses, gradientColors[1]),
                              _buildDivider(gradientColors[1]),
                              _buildMiniStat("G", player.goals, gradientColors[1]),
                            ],
                          ),
                          SizedBox(height: AppSpacing.xxs),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ],
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
              border: Border.all(color: gradientColors[1], width: AppSizing.borderAvatar),
              boxShadow: AppElevation.ringGlow(glowColor, opacity: 0.5),
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
                          strokeWidth: AppSizing.borderThick,
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
                      fontSize: AppTypography.sizeDisplay,
                      fontWeight: AppTypography.black,
                      color: gradientColors[1],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -overflowAmt - 4,
          left: -4, right: -12, // More offset from the right side as requested
          child: Align(
            alignment: badgeAlignment,
            child: CustomPaint(
              painter: HexagonPainter(
                color: badgeColor,
                glowColor: badgeColor.withOpacity(0.5),
              ),
              child: ClipPath(
                clipper: HexagonClipper(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [badgeColor.withOpacity(0.9), badgeColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMedalIcon(rank),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        rankLabel,
                        style: TextStyle(
                          fontSize: AppTypography.sizeTiny,
                          fontWeight: AppTypography.black,
                          letterSpacing: 1.2,
                          color: gradientColors[0],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(String label, int value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(
            fontSize: 7, 
            fontWeight: AppTypography.black, 
            color: color.withOpacity(AppColors.opacity45)
          )),
          SizedBox(width: 2),
          Text("$value", style: TextStyle(
            fontSize: AppTypography.sizeTiny, 
            fontWeight: AppTypography.bold, 
            color: color.withOpacity(0.9)
          )),
        ],
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Container(
      width: 1,
      height: 8,
      color: color.withOpacity(AppColors.opacity12),
    );
  }

  Widget _buildMedalIcon(int rank) {
    final Color iconColor = rank == 1 
      ? const Color(0xFFFFD700) // Gold
      : rank == 2 
        ? const Color(0xFFE0E0E0) // Silver
        : const Color(0xFFCD7F32); // Bronze

    return Icon(
      Icons.emoji_events_rounded,
      color: iconColor,
      size: 14,
    );
  }
}

class HexagonPainter extends CustomPainter {
  final Color color;
  final Color glowColor;

  HexagonPainter({required this.color, required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = _getHexagonPath(size);

    // 1. Draw Glow
    final glowPaint = Paint()
      ..color = glowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    canvas.drawPath(path, glowPaint);

    // 2. Draw Solid Border
    final borderPaint = Paint()
      ..color = AppColors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(HexagonPainter oldDelegate) => 
    oldDelegate.color != color || oldDelegate.glowColor != glowColor;
}

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => _getHexagonPath(size);

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Path _getHexagonPath(Size size) {
  Path path = Path();
  double width = size.width;
  double height = size.height;
  double edge = width * 0.12;

  path.moveTo(edge, 0);
  path.lineTo(width - edge, 0);
  path.lineTo(width, height / 2);
  path.lineTo(width - edge, height);
  path.lineTo(edge, height);
  path.lineTo(0, height / 2);
  path.close();
  return path;
}
