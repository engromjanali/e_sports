import 'package:e_sports/core/utils/dimensions.dart';
import '../../../core/data/models/computed_player_stats.dart';
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
        borderRadius: Dimensions.borderXl,
        gradient: AppColors.goldGradient,
        border: Border.all(color: AppColors.neonGold.withOpacity(0.28), width: Dimensions.borderThin),
        boxShadow: Dimensions.accentGlow(AppColors.neonGold, opacity: 0.14, blur: 20, offset: const Offset(0, 6)),
      ),
      child: ClipRRect(
        borderRadius: Dimensions.borderXl,
        child: Stack(
          children: [
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: Dimensions.shimmerHeight,
                decoration: BoxDecoration(gradient: AppColors.shimmerGradient(color: AppColors.goldLight)),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(Dimensions.cardInnerPadding, Dimensions.cardInnerPadding, Dimensions.cardInnerPadding, Dimensions.lg),
              child: Column(
                children: List.generate(players.length, (i) {
                  final p = players[i];
                  final accent = medalColors[i];
                  final imageUrl = p.player.imageUrl;
                  final isFirst = i == 0;

                  return Container(
                    margin: EdgeInsets.only(bottom: i < players.length - 1 ? Dimensions.md : 0),
                    padding: EdgeInsets.symmetric(vertical: Dimensions.lg, horizontal: Dimensions.lg),
                    decoration: BoxDecoration(
                      borderRadius: Dimensions.borderLg,
                      color: isFirst ? AppColors.neonGold.withOpacity(AppColors.opacity8) : AppColors.white.withOpacity(0.03),
                      border: Border.all(color: accent.withOpacity(isFirst ? 0.38 : AppColors.opacity18), width: Dimensions.borderThin),
                    ),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: Dimensions.ribbonLeft,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(Dimensions.iconGap, Dimensions.xs, Dimensions.iconGap, Dimensions.xs + 1),
                          decoration: BoxDecoration(
                            gradient: i == 0 ? AppColors.goldRibbonGradient : LinearGradient(colors: [accent.withOpacity(0.7), accent], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          ),
                          child: Text(rankLabels[i], style: TextStyle(fontSize: Dimensions.sizeTiny, fontWeight: Dimensions.black, letterSpacing: 1.3, color: i == 0 ? AppColors.goldDeep : AppColors.goldBgDark)),
                        ),
                      ),
                      SizedBox(width: Dimensions.lg),
                      Container(
                        width: Dimensions.avatarMd + 2, height: Dimensions.avatarMd + 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: accent, width: isFirst ? Dimensions.borderAvatar : Dimensions.borderThick),
                          boxShadow: Dimensions.subtleGlow(accent, opacity: isFirst ? 0.4 : 0.2, blur: isFirst ? 10 : 6),
                        ),
                        child: ClipOval(
                          child: imageUrl.isNotEmpty
                            ? Image.network(imageUrl, width: Dimensions.avatarMd + 2, height: Dimensions.avatarMd + 2, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: AppColors.goldDeep, alignment: Alignment.center,
                                  child: Text(p.name.isNotEmpty ? p.name[0].toUpperCase() : "?", style: TextStyle(fontWeight: Dimensions.bold, color: accent, fontSize: Dimensions.sizeTitleLarge))))
                            : Container(color: AppColors.goldDeep, alignment: Alignment.center,
                                child: Text(p.name.isNotEmpty ? p.name[0].toUpperCase() : "?", style: TextStyle(fontWeight: Dimensions.bold, color: accent, fontSize: Dimensions.sizeTitleLarge))),
                        ),
                      ),
                      SizedBox(width: Dimensions.lg),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(p.name, style: TextStyle(fontSize: Dimensions.sizeBody, fontWeight: Dimensions.black, color: AppColors.white)),
                          SizedBox(height: Dimensions.xxs),
                          Text("${p.matches}PL · ${p.wins}W", style: TextStyle(fontSize: Dimensions.sizeCaption, color: AppColors.white.withOpacity(0.38), letterSpacing: Dimensions.trackingTight)),
                        ]),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.lg, vertical: Dimensions.iconGap),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(AppColors.opacity10),
                          borderRadius: Dimensions.borderDef,
                          border: Border.all(color: accent.withOpacity(AppColors.opacity30), width: Dimensions.borderThin),
                        ),
                        child: Column(children: [
                          Text("${p.goals}", style: Dimensions.statValue(context, color: accent)),
                          Text("GOALS", style: Dimensions.labelUppercase(context)),
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