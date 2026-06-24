import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/features/rank/domain/model/player_of_the_week_and_month_model.dart';
import 'player_tags_widget.dart';
import 'package:flutter/material.dart';

class SpotlightCardWidget extends StatelessWidget {
  final PlayerOfTheWeeKModel? player;
  final String label;
  final String badge;
  final Gradient gradient;

  const SpotlightCardWidget({
    super.key,
    required this.player,
    required this.label,
    required this.badge,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;
        // Scale to the card's own width (works inside Expanded / two-up rows).
        final bool compact = w < 200;
        final bool roomy = w >= 340;

        final double avatar = compact ? 64 : (roomy ? 96 : 78);
        final double pad =
            compact ? Dimensions.cardInnerPadding : Dimensions.massive;
        final double nameSize = compact
            ? Dimensions.sizeBodyLarge
            : (roomy ? Dimensions.sizeHeading : Dimensions.sizeSubtitle + 1);
        final double statSize = compact
            ? Dimensions.sizeSubtitle
            : (roomy ? Dimensions.sizeDisplay - 4 : Dimensions.sizeHeadingLg);

        return Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: Dimensions.borderXl,
            border: Border.all(
              color: AppColors.neonGold.withOpacity(0.30),
              width: Dimensions.borderThin,
            ),
            boxShadow: Dimensions.accentGlow(AppColors.neonGold, opacity: 0.16),
          ),
          child: ClipRRect(
            borderRadius: Dimensions.borderXl,
            child: Stack(
              children: [
                // ── Shimmer top bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: Dimensions.shimmerHeight,
                    decoration: BoxDecoration(
                      gradient:
                          AppColors.shimmerGradient(color: AppColors.goldLight),
                    ),
                  ),
                ),

                // ── Soft radial glow behind the avatar
                Positioned(
                  top: -avatar * 0.5,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: avatar * 2.2,
                      height: avatar * 2.2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.neonGold.withOpacity(AppColors.opacity18),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Faint watermark badge in the corner
                Positioned(
                  right: -2,
                  bottom: -6,
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: compact ? 40 : 60,
                      fontWeight: Dimensions.black,
                      color: AppColors.neonGold.withOpacity(AppColors.opacity8),
                      height: Dimensions.lineHeightCompact,
                      letterSpacing: Dimensions.trackingTight,
                    ),
                  ),
                ),

                // ── Content
                Padding(
                  padding: EdgeInsets.all(pad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top: label pill
                      _LabelPill(label: label, badge: badge, compact: compact),
                      SizedBox(height: compact ? Dimensions.xl : Dimensions.xxl),

                      // Hero avatar
                      _Avatar(
                        size: avatar,
                        image: player?.image ?? '',
                        name: player?.name ?? '',
                      ),
                      SizedBox(height: compact ? Dimensions.lg : Dimensions.xl),

                      // Name
                      Text(
                        player?.short ?? "—",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: nameSize,
                          fontWeight: Dimensions.black,
                          color: AppColors.white,
                          height: Dimensions.lineHeightNormal,
                          letterSpacing: Dimensions.trackingTight,
                        ),
                      ),
                      SizedBox(height: Dimensions.sm),

                      // Tags
                      if ((player?.tags ?? []).isNotEmpty)
                        Align(
                          alignment: Alignment.center,
                          child: PlayerTagsWidget(
                            tags: player?.tags ?? [],
                            accentColor: AppColors.neonGold,
                          ),
                        ),
                      SizedBox(height: compact ? Dimensions.md : Dimensions.sm),

                      // Matches
                      Text(
                        "${player?.matches ?? 0} matches played",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Dimensions.sizeCaption,
                          color:
                              AppColors.white.withOpacity(AppColors.opacity45),
                          letterSpacing: Dimensions.trackingTight,
                        ),
                      ),
                      SizedBox(height: compact ? Dimensions.lg : Dimensions.xl),

                      // Stat strip — number over label, thin dividers
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: compact ? Dimensions.md : Dimensions.lg,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(AppColors.opacity20),
                          borderRadius: Dimensions.borderDef,
                          border: Border.all(
                            color: AppColors.neonGold
                                .withOpacity(AppColors.opacity15),
                            width: Dimensions.borderThin,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _Stat(
                              value: "${player?.goals ?? 0}",
                              label: "Goals",
                              valueSize: statSize,
                            ),
                            _StatDivider(),
                            _Stat(
                              value: "${player?.pts ?? 0}",
                              label: "Points",
                              valueSize: statSize,
                            ),
                            _StatDivider(),
                            _Stat(
                              value: "${player?.wins ?? 0}",
                              label: "Wins",
                              valueSize: statSize,
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
      },
    );
  }
}

class _LabelPill extends StatelessWidget {
  final String label;
  final String badge;
  final bool compact;

  const _LabelPill({
    required this.label,
    required this.badge,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.lg,
        vertical: Dimensions.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.neonGold.withOpacity(AppColors.opacity12),
        borderRadius: Dimensions.borderPill,
        border: Border.all(
          color: AppColors.neonGold.withOpacity(AppColors.opacity35),
          width: Dimensions.borderThin,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(badge, style: const TextStyle(fontSize: Dimensions.sizeSmall)),
          SizedBox(width: Dimensions.xs),
          Flexible(
            child: Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Dimensions.pillLabel(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final double size;
  final String image;
  final String name;

  const _Avatar({
    required this.size,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
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
          image,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (ctx, child, progress) {
            if (progress == null) return child;
            return Container(
              color: AppColors.goldDeep.withOpacity(0.5),
              alignment: Alignment.center,
              child: SizedBox(
                width: size * 0.3,
                height: size * 0.3,
                child: CircularProgressIndicator(
                  strokeWidth: Dimensions.borderThick,
                  color: AppColors.neonGold,
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (_, _, _) => Container(
            color: AppColors.goldDeep.withOpacity(0.5),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              style: TextStyle(
                fontSize: size * 0.4,
                fontWeight: Dimensions.black,
                color: AppColors.neonGold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final double valueSize;

  const _Stat({
    required this.value,
    required this.label,
    required this.valueSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              fontSize: valueSize,
              fontWeight: Dimensions.black,
              color: AppColors.white,
              height: Dimensions.lineHeightCompact,
            ),
          ),
        ),
        SizedBox(height: Dimensions.xxs),
        Text(
          label.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: Dimensions.sizeMicro,
            fontWeight: Dimensions.extraBold,
            color: AppColors.neonGold.withOpacity(0.85),
            letterSpacing: Dimensions.trackingWide,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.borderThin,
      height: 26,
      color: AppColors.white.withOpacity(AppColors.opacity12),
    );
  }
}
