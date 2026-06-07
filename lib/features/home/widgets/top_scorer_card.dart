import 'package:e_sports/core/utils/dimensions.dart';
import "package:get/get.dart";
import 'diagonal_slash_printer_widget.dart';
import 'stat_chip_widget.dart';
import '../../../core/widgets/player_tags_widget.dart';
import 'package:flutter/material.dart';
import '../../../core/data/models/computed_player_stats.dart';

class TopScorerCard extends StatelessWidget {
  final ComputedPlayerStats player;
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
      width: Dimensions.scorerCardWidth,
      decoration: BoxDecoration(
        borderRadius: Dimensions.borderXl,
        gradient: gradient,
        border: Border.all(
          color: AppColors.white.withOpacity(AppColors.opacity8),
          width: Dimensions.borderThin,
        ),
        boxShadow: [
          BoxShadow(
            color: c.withOpacity(AppColors.opacity35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(AppColors.opacity40),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: Dimensions.borderXl,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: DiagonalSlashPainterWidget(color: c)),
            ),
            Positioned(
              top: -30, right: -30,
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [c.withOpacity(AppColors.opacity25), Colors.transparent],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                Dimensions.cardInnerPadding,
                Dimensions.cardInnerPadding,
                Dimensions.cardInnerPadding,
                Dimensions.xxxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: Dimensions.pillPadding,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(AppColors.opacity12),
                          borderRadius: Dimensions.borderPill,
                          border: Border.all(
                            color: AppColors.white.withOpacity(AppColors.opacity15),
                            width: Dimensions.borderThin,
                          ),
                        ),
                        child: Text(
                          label.toUpperCase(),
                          style: Dimensions.pillLabel(context,
                            color: AppColors.white.withOpacity(0.75),
                          ),
                        ),
                      ),
                      Text(badge, style: TextStyle(fontSize: Dimensions.sizeHeading)),
                    ],
                  ),
                  SizedBox(height: Dimensions.xxl),
                  Row(
                    children: [
                      Container(
                        width: Dimensions.avatarMdLg,
                        height: Dimensions.avatarMdLg,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white.withOpacity(AppColors.opacity30),
                            width: Dimensions.borderThick,
                          ),
                          boxShadow: Dimensions.subtleGlow(c, opacity: 0.5, blur: 10),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            player.image,
                            width: Dimensions.avatarMdLg,
                            height: Dimensions.avatarMdLg,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [c, c.withOpacity(0.5)],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                player.name[0],
                                style: TextStyle(
                                  fontSize: Dimensions.sizeHeadingLg,
                                  fontWeight: Dimensions.black,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.short.toUpperCase(),
                              style: TextStyle(
                                fontSize: Dimensions.sizeBody2,
                                fontWeight: Dimensions.black,
                                color: AppColors.white,
                                letterSpacing: Dimensions.trackingNormal,
                                height: 1.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: Dimensions.xs),
                            Row(
                              children: [
                                Container(
                                  width: Dimensions.dotSm,
                                  height: Dimensions.dotSm,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.neonGold,
                                  ),
                                ),
                                SizedBox(width: Dimensions.xs + 1),
                                Text(
                                  "${player.matches} matches",
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    color: AppColors.white.withOpacity(AppColors.opacity55),
                                    fontWeight: Dimensions.semiBold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.xs),
                            PlayerTagsWidget(
                              tags: player.tags,
                              accentColor: AppColors.neonGold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.xxl),
                  Container(
                    height: Dimensions.dividerHeight,
                    decoration: BoxDecoration(
                      gradient: AppColors.dividerGradient(color: AppColors.white, opacity: AppColors.opacity15),
                    ),
                  ),
                  SizedBox(height: Dimensions.xl),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${player.goals}",
                        style: TextStyle(
                          fontSize: Dimensions.sizeHero,
                          fontWeight: Dimensions.black,
                          color: AppColors.white,
                          height: Dimensions.lineHeightTight,
                          shadows: [
                            Shadow(
                              color: c.withOpacity(AppColors.opacity60),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: Dimensions.iconGap),
                      Padding(
                        padding: EdgeInsets.only(bottom: Dimensions.iconGap),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GOALS",
                              style: TextStyle(
                                fontSize: Dimensions.sizeTiny,
                                fontWeight: Dimensions.extraBold,
                                color: AppColors.neonGold,
                                letterSpacing: Dimensions.trackingWidest,
                              ),
                            ),
                            Text(
                              "scored",
                              style: TextStyle(
                                fontSize: Dimensions.sizeTiny,
                                color: AppColors.white.withOpacity(AppColors.opacity40),
                                fontWeight: Dimensions.medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.lg),
                  Row(
                    children: [
                      StatChipWidget(
                        label: "MTH",
                        value: "${player.matches}",
                        color: AppColors.white.withOpacity(0.7),
                      ),
                      SizedBox(width: Dimensions.iconGap),
                      StatChipWidget(
                        label: "Win",
                        value: "${player.wins}",
                        color: AppColors.white.withOpacity(0.7),
                      ),
                      SizedBox(width: Dimensions.iconGap),
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
