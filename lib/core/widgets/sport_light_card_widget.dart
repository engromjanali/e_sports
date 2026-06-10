import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'player_tags_widget.dart';
import 'package:flutter/material.dart';


class SpotlightCardWidget extends StatelessWidget {
  final PlayerOfTheWeeKModel? player;
  final String label;
  final String badge;
  final Gradient gradient;

  const SpotlightCardWidget({super.key,  required this.player, required this.label, required this.badge, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: Dimensions.borderXl,
        border: Border.all(
          color: AppColors.neonGold.withOpacity(0.32),
          width: Dimensions.borderThin,
        ),
        boxShadow: Dimensions.accentGlow(AppColors.neonGold, opacity: 0.14),
      ),
      child: ClipRRect(
        borderRadius: Dimensions.borderXl,
        child: Stack(
          children: [
            // ── Shimmer top bar
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: Dimensions.shimmerHeight,
                decoration: BoxDecoration(
                  gradient: AppColors.shimmerGradient(color: AppColors.goldLight),
                ),
              ),
            ),

            // ── Watermark label
            Positioned(
              right: 2, bottom: 0, top: 2,
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: Dimensions.black,
                  color: AppColors.neonGold.withOpacity(AppColors.opacity8),
                  height: Dimensions.lineHeightCompact,
                  letterSpacing: Dimensions.trackingUltra,
                ),
              ),
            ),

            // ── Main content
            Padding(
              padding: EdgeInsets.fromLTRB(
                Dimensions.cardInnerPadding - 1,
                Dimensions.cardInnerPadding,
                Dimensions.cardInnerPadding - 1,
                Dimensions.cardInnerPadding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Left: avatar + name + matches
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label pill
                      Container(
                        padding: Dimensions.pillPadding,
                        decoration: BoxDecoration(
                          color: AppColors.neonGold.withOpacity(AppColors.opacity12),
                          borderRadius: Dimensions.borderSm,
                          border: Border.all(
                            color: AppColors.neonGold.withOpacity(AppColors.opacity35),
                            width: Dimensions.borderThin,
                          ),
                        ),
                        child: Text(
                          label.toUpperCase(),
                          style: Dimensions.pillLabel(context),
                        ),
                      ),
                      SizedBox(height: Dimensions.xl),

                      // Avatar with badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: Dimensions.avatarXxl,
                            height: Dimensions.avatarXxl,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.neonGold,
                                width: Dimensions.borderAvatar,
                              ),
                              boxShadow: Dimensions.ringGlow(AppColors.neonGold),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                player?.image ?? '',
                                width: Dimensions.avatarXxl,
                                height: Dimensions.avatarXxl,
                                fit: BoxFit.cover,
                                loadingBuilder: (ctx, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    color: AppColors.goldDeep.withOpacity(0.5),
                                    child: Center(
                                      child: SizedBox(
                                        width: Dimensions.massive,
                                        height: Dimensions.massive,
                                        child: CircularProgressIndicator(
                                          strokeWidth: Dimensions.borderThick,
                                          color: AppColors.neonGold,
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
                                  color: AppColors.goldDeep.withOpacity(0.5),
                                  alignment: Alignment.center,
                                  child: Text(
                                    (player?.name ?? '').isNotEmpty ? player!.name[0].toUpperCase(): "?",
                                    style: TextStyle(
                                      fontSize: Dimensions.sizeDisplay - 2,
                                      fontWeight: Dimensions.black,
                                      color: AppColors.neonGold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Badge — corner ribbon style
                          Positioned(
                            top: -2, right: -2,
                            child: ClipRRect(
                              borderRadius: Dimensions.ribbonTopRight,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                  Dimensions.sm, Dimensions.xxs, Dimensions.sm, Dimensions.xs,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldRibbonGradient,
                                ),
                                child: Text(
                                  badge,
                                  style: TextStyle(fontSize: Dimensions.sizeSmall),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.lg),

                      // Name
                      Text(
                        player?.short ?? "xxxxxxx",
                        style: TextStyle(
                          fontSize: Dimensions.sizeSubtitle,
                          fontWeight: Dimensions.black,
                          color: AppColors.white,
                          height: Dimensions.lineHeightNormal,
                        ),
                      ),
                      SizedBox(height: Dimensions.xs),
                      
                      // Dynamic Tags
                      PlayerTagsWidget(
                        tags: player?.tags ?? [],
                        accentColor: AppColors.neonGold,
                      ),
                      
                      SizedBox(height: Dimensions.sm),
                      Text(
                        "${player?.matches} matches",
                        style: TextStyle(
                          fontSize: Dimensions.sizeBody,
                          color: AppColors.white.withOpacity(AppColors.opacity45),
                          letterSpacing: Dimensions.trackingTight + 0.1,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: Dimensions.xxl),

                  // ── Right: vertical stats
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimensions.xxxl * 2),
                        _StatRow(
                          label: "Goals",
                          value: "${player?.goals}",
                          accentColor: AppColors.neonGold,
                          fillFraction: player?.goals == null ? 0.0 : (player!.goals / 20).clamp(0.0, 1.0),
                        ),
                        SizedBox(height: Dimensions.md),
                        _StatRow(
                          label: "Points",
                          value: "${player?.pts}",
                          accentColor: AppColors.neonGold,
                          fillFraction: player?.pts == null ? 0.0 : (player!.pts / 100).clamp(0.0, 1.0),
                        ),
                        SizedBox(height: Dimensions.md),
                        _StatRow(
                          label: "Win",
                          value: "${player?.wins}",
                          accentColor: AppColors.neonGold,
                          fillFraction: player?.wins == null ? 0.0 : (player!.wins / 10).clamp(0.0, 1.0),
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
  final double fillFraction;

  const _StatRow({
    required this.label,
    required this.value,
    required this.accentColor,
    required this.fillFraction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Dimensions.caption, Dimensions.micro, Dimensions.caption, Dimensions.micro,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(AppColors.opacity4),
        borderRadius: Dimensions.borderDef,
        border: Border.all(
          color: accentColor.withOpacity(AppColors.opacity18),
          width: Dimensions.borderThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: Dimensions.labelUppercase(context, color: AppColors.white.withOpacity(AppColors.opacity45)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: Dimensions.xs),
              Text(
                value,
                style: TextStyle(
                  fontSize: Dimensions.sizeBodyLarge,
                  fontWeight: Dimensions.black,
                  color: accentColor,
                  height: Dimensions.lineHeightCompact,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.sm),
          // Progress bar
          ClipRRect(
            borderRadius: Dimensions.borderXs,
            child: Stack(
              children: [
                Container(
                  height: Dimensions.progressBarSm,
                  color: AppColors.white.withOpacity(AppColors.opacity8),
                ),
                FractionallySizedBox(
                  widthFactor: fillFraction,
                  child: Container(
                    height: Dimensions.progressBarSm,
                    decoration: BoxDecoration(
                      borderRadius: Dimensions.borderXs,
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(AppColors.opacity60),
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