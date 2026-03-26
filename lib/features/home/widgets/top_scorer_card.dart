import 'package:e_sports/core/theme/app_theme.dart';
import "package:e_sports/core/controllers/app_data_controller.dart";
import "package:get/get.dart";
import 'package:e_sports/features/home/widgets/diagonal_slash_printer_widget.dart';
import 'package:e_sports/features/home/widgets/stat_chip_widget.dart';
import 'package:e_sports/core/widgets/player_tags_widget.dart';
import 'package:flutter/material.dart';
import 'package:e_sports/core/data/models/computed_player_stats.dart';

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
      width: AppSizing.scorerCardWidth,
      decoration: BoxDecoration(
        borderRadius: AppRadius.borderXl,
        gradient: gradient,
        border: Border.all(
          color: AppColors.white.withOpacity(AppColors.opacity8),
          width: AppSizing.borderThin,
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
        borderRadius: AppRadius.borderXl,
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
                AppSpacing.cardInnerPadding,
                AppSpacing.cardInnerPadding,
                AppSpacing.cardInnerPadding,
                AppSpacing.xxxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: AppSpacing.pillPadding,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(AppColors.opacity12),
                          borderRadius: AppRadius.borderPill,
                          border: Border.all(
                            color: AppColors.white.withOpacity(AppColors.opacity15),
                            width: AppSizing.borderThin,
                          ),
                        ),
                        child: Text(
                          label.toUpperCase(),
                          style: AppTypography.pillLabel(context,
                            color: AppColors.white.withOpacity(0.75),
                          ),
                        ),
                      ),
                      Text(badge, style: TextStyle(fontSize: AppTypography.sizeHeading)),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  Row(
                    children: [
                      Container(
                        width: AppSizing.avatarMdLg,
                        height: AppSizing.avatarMdLg,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [c, c.withOpacity(0.5)],
                          ),
                          border: Border.all(
                            color: AppColors.white.withOpacity(AppColors.opacity30),
                            width: AppSizing.borderThick,
                          ),
                          boxShadow: AppElevation.subtleGlow(c, opacity: 0.5, blur: 10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          player.name[0],
                          style: TextStyle(
                            fontSize: AppTypography.sizeHeadingLg,
                            fontWeight: AppTypography.black,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.short.toUpperCase(),
                              style: TextStyle(
                                fontSize: AppTypography.sizeBody2,
                                fontWeight: AppTypography.black,
                                color: AppColors.white,
                                letterSpacing: AppTypography.trackingNormal,
                                height: 1.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppSpacing.xs),
                            Row(
                              children: [
                                Container(
                                  width: AppSizing.dotSm,
                                  height: AppSizing.dotSm,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.neonGold,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.xs + 1),
                                Text(
                                  "${player.matches} matches",
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    color: AppColors.white.withOpacity(AppColors.opacity55),
                                    fontWeight: AppTypography.semiBold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.xs),
                            PlayerTagsWidget(
                              tags: player.tags,
                              accentColor: AppColors.neonGold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  Container(
                    height: AppSizing.dividerHeight,
                    decoration: BoxDecoration(
                      gradient: AppColors.dividerGradient(color: AppColors.white, opacity: AppColors.opacity15),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${player.goals}",
                        style: TextStyle(
                          fontSize: AppTypography.sizeHero,
                          fontWeight: AppTypography.black,
                          color: AppColors.white,
                          height: AppTypography.lineHeightTight,
                          shadows: [
                            Shadow(
                              color: c.withOpacity(AppColors.opacity60),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppSpacing.iconGap),
                      Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.iconGap),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GOALS",
                              style: TextStyle(
                                fontSize: AppTypography.sizeTiny,
                                fontWeight: AppTypography.extraBold,
                                color: AppColors.neonGold,
                                letterSpacing: AppTypography.trackingWidest,
                              ),
                            ),
                            Text(
                              "scored",
                              style: TextStyle(
                                fontSize: AppTypography.sizeTiny,
                                color: AppColors.white.withOpacity(AppColors.opacity40),
                                fontWeight: AppTypography.medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      StatChipWidget(
                        label: "MTH",
                        value: "${player.matches}",
                        color: AppColors.white.withOpacity(0.7),
                      ),
                      SizedBox(width: AppSpacing.iconGap),
                      StatChipWidget(
                        label: "Win",
                        value: "${player.wins}",
                        color: AppColors.white.withOpacity(0.7),
                      ),
                      SizedBox(width: AppSpacing.iconGap),
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
