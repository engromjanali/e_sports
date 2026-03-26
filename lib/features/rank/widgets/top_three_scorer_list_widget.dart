import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/core/data/models/computed_player_stats.dart';
import 'package:flutter/material.dart';

class TopThreeScorersWidget extends StatelessWidget {
  final List<ComputedPlayerStats> players;
  const TopThreeScorersWidget({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    const rankLabels = ["1ST", "2ND", "3RD"];
    const medalColors = [AppColors.neonGold, AppColors.silver, AppColors.bronze];

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.borderXl,
        gradient: AppColors.goldGradient,
        border: Border.all(color: AppColors.neonGold.withOpacity(0.28), width: AppSizing.borderThin),
        boxShadow: AppElevation.accentGlow(AppColors.neonGold, opacity: 0.14, blur: 20, offset: const Offset(0, 6)),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.borderXl,
        child: Stack(
          children: [
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: AppSizing.shimmerHeight,
                decoration: BoxDecoration(gradient: AppColors.shimmerGradient(color: AppColors.goldLight)),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.cardInnerPadding, AppSpacing.cardInnerPadding, AppSpacing.cardInnerPadding, AppSpacing.lg),
              child: Column(
                children: List.generate(players.length, (i) {
                  final p = players[i];
                  final accent = medalColors[i];
                  final imageUrl = p.player.imageUrl;
                  final isFirst = i == 0;

                  return Container(
                    margin: EdgeInsets.only(bottom: i < players.length - 1 ? AppSpacing.md : 0),
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.lg),
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.borderLg,
                      color: isFirst ? AppColors.neonGold.withOpacity(AppColors.opacity8) : AppColors.white.withOpacity(0.03),
                      border: Border.all(color: accent.withOpacity(isFirst ? 0.38 : AppColors.opacity18), width: AppSizing.borderThin),
                    ),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: AppRadius.ribbonLeft,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(AppSpacing.iconGap, AppSpacing.xs, AppSpacing.iconGap, AppSpacing.xs + 1),
                          decoration: BoxDecoration(
                            gradient: i == 0 ? AppColors.goldRibbonGradient : LinearGradient(colors: [accent.withOpacity(0.7), accent], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          ),
                          child: Text(rankLabels[i], style: TextStyle(fontSize: AppTypography.sizeTiny, fontWeight: AppTypography.black, letterSpacing: 1.3, color: i == 0 ? AppColors.goldDeep : AppColors.goldBgDark)),
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      Container(
                        width: AppSizing.avatarMd + 2, height: AppSizing.avatarMd + 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: accent, width: isFirst ? AppSizing.borderAvatar : AppSizing.borderThick),
                          boxShadow: AppElevation.subtleGlow(accent, opacity: isFirst ? 0.4 : 0.2, blur: isFirst ? 10 : 6),
                        ),
                        child: ClipOval(
                          child: imageUrl.isNotEmpty
                            ? Image.network(imageUrl, width: AppSizing.avatarMd + 2, height: AppSizing.avatarMd + 2, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: AppColors.goldDeep, alignment: Alignment.center,
                                  child: Text(p.name.isNotEmpty ? p.name[0].toUpperCase() : "?", style: TextStyle(fontWeight: AppTypography.bold, color: accent, fontSize: AppTypography.sizeTitleLarge))))
                            : Container(color: AppColors.goldDeep, alignment: Alignment.center,
                                child: Text(p.name.isNotEmpty ? p.name[0].toUpperCase() : "?", style: TextStyle(fontWeight: AppTypography.bold, color: accent, fontSize: AppTypography.sizeTitleLarge))),
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(p.name, style: TextStyle(fontSize: AppTypography.sizeBody, fontWeight: AppTypography.black, color: AppColors.white)),
                          SizedBox(height: AppSpacing.xxs),
                          Text("${p.matches}PL · ${p.wins}W", style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.white.withOpacity(0.38), letterSpacing: AppTypography.trackingTight)),
                        ]),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.iconGap),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(AppColors.opacity10),
                          borderRadius: AppRadius.borderDef,
                          border: Border.all(color: accent.withOpacity(AppColors.opacity30), width: AppSizing.borderThin),
                        ),
                        child: Column(children: [
                          Text("${p.goals}", style: AppTypography.statValue(context, color: accent)),
                          Text("GOALS", style: AppTypography.labelUppercase(context)),
                        ]),
                      ),
                    ]),
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