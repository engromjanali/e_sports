// import 'package:flutter/material.dart';
// import '../../../core/theme/app_theme.dart';
// import '../../../core/widgets/glass_card_widget.dart';
// import '../../../core/widgets/player_avater.dart';
// import '../../../core/widgets/player_tags_widget.dart';
// import '../../../core/data/models/computed_player_stats.dart';

// enum MvpType { week, month, season }

// class PremiumHeroCard extends StatelessWidget {
//   final MvpType type;
//   final ComputedPlayerStats player;
//   final Widget? action;
//   final bool isScorer;

//   const PremiumHeroCard({
//     super.key,
//     required this.type,
//     required this.player,
//     this.action,
//     this.isScorer = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final gradient = _getGradient();
//     final accentColor = _getAccentColor();
//     final badgeLabel = _getBadgeLabel();

//     return GlassCardWidget(
//       radius: AppRadius.hero,
//       gradient: gradient,
//       borderColor: accentColor.withOpacity(AppColors.opacity20),
//       shadows: [
//         BoxShadow(
//           color: accentColor.withOpacity(AppColors.opacity15),
//           blurRadius: 30,
//           spreadRadius: -10,
//         )
//       ],
//       child: Container(
//         padding: EdgeInsets.all(AppSpacing.xl),
//         child: Stack(
//           children: [
//             // Decorative Background Glow
//             Positioned(
//               right: -50,
//               top: -50,
//               child: Container(
//                 width: 150,
//                 height: 150,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: accentColor.withOpacity(AppColors.opacity10),
//                 ),
//               ),
//             ),
            
//             // Watermark Background Label
//             Positioned(
//               bottom: -20,
//               right: -10,
//               child: Text(
//                 badgeLabel.split(' ')[0], // WEEK, MONTH, or SEASON
//                 style: TextStyle(
//                   fontSize: 80,
//                   fontWeight: AppTypography.black,
//                   color: AppColors.white.withOpacity(0.03),
//                   letterSpacing: -5,
//                 ),
//               ),
//             ),

//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _Badge(label: badgeLabel, color: accentColor),
//                     if (action != null) action! else Text(
//                       "#${player.rank}",
//                       style: TextStyle(
//                         fontSize: AppTypography.sizeBody,
//                         fontWeight: AppTypography.black,
//                         color: AppColors.white.withOpacity(AppColors.opacity50),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: AppSpacing.xl),
//                 Row(
//                   children: [
//                     PlayerAvatarWidget(
//                       name: player.name,
//                       size: AppSizing.avatarGiant,
//                       borderColor: accentColor.withOpacity(AppColors.opacity40),
//                     ),
//                     SizedBox(width: AppSpacing.xl),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                             Text(
//                               player.name.toUpperCase(),
//                               style: TextStyle(
//                                 fontSize: AppTypography.sizeHeadingLg,
//                                 fontWeight: AppTypography.black,
//                                 color: AppColors.white,
//                                 letterSpacing: -0.5,
//                                 height: 1.1,
//                               ),
//                             ),
//                             SizedBox(height: AppSpacing.md),
//                             PlayerTagsWidget(
//                               tags: player.tags,
//                               accentColor: accentColor,
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: AppSpacing.xxxl),
//                 _StatsGrid(player: player, accentColor: accentColor),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Gradient _getGradient() {
//     switch (type) {
//       case MvpType.season: return AppColors.blueDeepHeroGradient;
//       case MvpType.month: return AppColors.blueHeroGradient;
//       case MvpType.week: return AppColors.purpleGradient;
//     }
//   }

//   Color _getAccentColor() {
//     switch (type) {
//       case MvpType.season: return AppColors.neonCyan;
//       case MvpType.month: return AppColors.neonBlue;
//       case MvpType.week: return AppColors.neonPurple;
//     }
//   }

//   String _getBadgeLabel() {
//     if (isScorer) {
//       switch (type) {
//         case MvpType.season: return "SEASON SCORER";
//         case MvpType.month: return "MONTH SCORER";
//         case MvpType.week: return "WEEK SCORER";
//       }
//     }
//     switch (type) {
//       case MvpType.season: return "SEASON MVP";
//       case MvpType.month: return "MONTH MVP";
//       case MvpType.week: return "WEEK MVP";
//     }
//   }
// }

// class _Badge extends StatelessWidget {
//   final String label;
//   final Color color;
//   const _Badge({required this.label, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
//       decoration: BoxDecoration(
//         color: color.withOpacity(AppColors.opacity15),
//         borderRadius: AppRadius.borderSm,
//         border: Border.all(color: color.withOpacity(AppColors.opacity30)),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: AppTypography.sizeMicro,
//           fontWeight: AppTypography.black,
//           color: color,
//           letterSpacing: 2.0,
//         ),
//       ),
//     );
//   }
// }

// class _StatsGrid extends StatelessWidget {
//   final ComputedPlayerStats player;
//   final Color accentColor;
//   const _StatsGrid({required this.player, required this.accentColor});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _StatItem(label: "MATCHES", value: "24"),
//         _StatItem(label: "GOALS", value: "${player.goals}"),
//         _StatItem(label: "WINS", value: "${player.wins}"),
//         _StatItem(label: "RATING", value: "8.9", isHighlight: true, accentColor: accentColor),
//       ],
//     );
//   }
// }

// class _StatItem extends StatelessWidget {
//   final String label, value;
//   final bool isHighlight;
//   final Color? accentColor;
//   const _StatItem({required this.label, required this.value, this.isHighlight = false, this.accentColor});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: AppTypography.sizeOverSmall,
//             fontWeight: AppTypography.bold,
//             color: AppColors.white.withOpacity(AppColors.opacity40),
//             letterSpacing: 1.2,
//           ),
//         ),
//         SizedBox(height: AppSpacing.xs),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: isHighlight ? AppTypography.sizeHeading : AppTypography.sizeBodyLarge,
//             fontWeight: AppTypography.black,
//             color: isHighlight ? (accentColor ?? AppColors.neonGold) : AppColors.white,
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card_widget.dart';
import '../../../core/widgets/player_avater.dart';
import '../../../core/widgets/player_tags_widget.dart';
import '../../../core/data/models/computed_player_stats.dart';

enum MvpType { week, month, season }

class PremiumHeroCard extends StatelessWidget {
  final MvpType type;
  final ComputedPlayerStats player;
  final Widget? action;
  final bool isScorer;

  const PremiumHeroCard({
    super.key,
    required this.type,
    required this.player,
    this.action,
    this.isScorer = false,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradient();
    final accentColor = _getAccentColor();
    final badgeLabel = _getBadgeLabel();

    return GlassCardWidget(
      radius: AppRadius.hero,
      gradient: gradient,
      borderColor: accentColor.withOpacity(AppColors.opacity20),
      shadows: [
        BoxShadow(
          color: accentColor.withOpacity(AppColors.opacity15),
          blurRadius: 30,
          spreadRadius: -10,
        )
      ],
      child: Container(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Stack(
          children: [
            // ── Decorative Background Glow ──
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withOpacity(AppColors.opacity10),
                ),
              ),
            ),

            // ── Watermark Background Label ──
            Positioned(
              bottom: -20,
              right: -10,
              child: Text(
                badgeLabel.split(' ')[0],
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: AppTypography.black,
                  color: AppColors.white.withOpacity(0.03),
                  letterSpacing: -5,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Row: Badge + Rank/Action ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Badge(label: badgeLabel, color: accentColor),
                    if (action != null)
                      action!
                    else
                      Text(
                        "#${player.rank}",
                        style: TextStyle(
                          fontSize: AppTypography.sizeBody,
                          fontWeight: AppTypography.black,
                          color: AppColors.white.withOpacity(AppColors.opacity50),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl),

                // ── Avatar + Name ──
                Row(
                  children: [
                    PlayerAvatarWidget(
                      name: player.name,
                      imageUrl: player.player.imageUrl,
                      size: AppSizing.avatarGiant,
                      borderColor: accentColor.withOpacity(AppColors.opacity40),
                    ),
                    SizedBox(width: AppSpacing.xl),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            player.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: AppTypography.sizeHeadingLg,
                              fontWeight: AppTypography.black,
                              color: AppColors.white,
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppSpacing.md),
                          PlayerTagsWidget(
                            tags: player.tags,
                            accentColor: accentColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xxxl),

                // ── Stats Row ──
                _StatsGrid(player: player, accentColor: accentColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Gradient _getGradient() {
    switch (type) {
      case MvpType.season: return AppColors.blueDeepHeroGradient;
      case MvpType.month:  return AppColors.blueHeroGradient;
      case MvpType.week:   return AppColors.purpleGradient;
    }
  }

  Color _getAccentColor() {
    switch (type) {
      case MvpType.season: return AppColors.neonCyan;
      case MvpType.month:  return AppColors.neonBlue;
      case MvpType.week:   return AppColors.neonPurple;
    }
  }

  String _getBadgeLabel() {
    if (isScorer) {
      switch (type) {
        case MvpType.season: return "SEASON SCORER";
        case MvpType.month:  return "MONTH SCORER";
        case MvpType.week:   return "WEEK SCORER";
      }
    }
    switch (type) {
      case MvpType.season: return "SEASON MVP";
      case MvpType.month:  return "MONTH MVP";
      case MvpType.week:   return "WEEK MVP";
    }
  }
}

// ── Badge Pill ────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(AppColors.opacity15),
        borderRadius: AppRadius.borderSm,
        border: Border.all(color: color.withOpacity(AppColors.opacity30)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppTypography.sizeMicro,
          fontWeight: AppTypography.black,
          color: color,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

// ── Stats Grid ────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final ComputedPlayerStats player;
  final Color accentColor;
  const _StatsGrid({required this.player, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(label: "MATCHES", value: "${player.matches}"),
        _StatDivider(),
        _StatItem(label: "GOALS", value: "${player.goals}"),
        _StatDivider(),
        _StatItem(label: "WINS", value: "${player.wins}"),
        _StatDivider(),
        _StatItem(
          label: "PTS",
          value: "${player.pts}",
          isHighlight: true,
          accentColor: accentColor,
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      color: AppColors.white.withOpacity(0.08),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  final bool isHighlight;
  final Color? accentColor;

  const _StatItem({
    required this.label,
    required this.value,
    this.isHighlight = false,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.sizeOverSmall,
              fontWeight: AppTypography.bold,
              color: AppColors.white.withOpacity(AppColors.opacity40),
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: isHighlight
                    ? AppTypography.sizeHeading
                    : AppTypography.sizeBodyLarge,
                fontWeight: AppTypography.black,
                color: isHighlight
                    ? (accentColor ?? AppColors.neonGold)
                    : AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}