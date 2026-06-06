import 'package:e_sports/core/utils/dimensions.dart';
import '../../../core/controllers/app_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRankCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appData = Get.find<AppDataController>();
      if (appData.rankedPlayers.isEmpty) return const SizedBox.shrink();
      
      final me = appData.rankedPlayers.first; // Default authenticated player
      String wlabel = "${me.rank}";
      
      return Container(
      decoration: BoxDecoration(
        borderRadius: Dimensions.borderXl,
        gradient: AppColors.goldGradient,
        border: Border.all(color: AppColors.neonGold.withOpacity(0.28), width: Dimensions.borderThin),
        boxShadow: Dimensions.accentGlow(AppColors.neonGold, opacity: 0.16, blur: 22, offset: const Offset(0, 7)),
      ),
      child: ClipRRect(
        borderRadius: Dimensions.borderXl,
        child: Stack(
          children: [
            // Shimmer top bar
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: Dimensions.shimmerHeight,
                decoration: BoxDecoration(
                  gradient: AppColors.shimmerGradient(color: AppColors.goldLight),
                ),
              ),
            ),

            // Giant ghost rank number
            Positioned(
              right: 0, top: 10,
              child: SizedBox(
                width: 300,
                child: Text(
                  "#$wlabel",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: wlabel.length > 5 ? 60 : 80,
                    fontWeight: Dimensions.black,
                    color: AppColors.neonGold.withOpacity(AppColors.opacity7),
                    height: Dimensions.lineHeightCompact,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(Dimensions.xxxl),
              child: Column(
                children: [
                  // Top row: avatar left, rank center, tier right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Network Avatar
                      Container(
                        width: Dimensions.avatarLg,
                        height: Dimensions.avatarLg,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.neonGold, width: Dimensions.borderAvatar),
                          boxShadow: Dimensions.ringGlow(AppColors.neonGold, opacity: AppColors.opacity40),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            me.image,
                            width: Dimensions.avatarLg,
                            height: Dimensions.avatarLg,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.goldDeep,
                              alignment: Alignment.center,
                              child: Text(me.name.isNotEmpty ? me.name[0] : 'I',
                                  style: TextStyle(
                                    fontSize: Dimensions.sizeDisplay - 2,
                                    fontWeight: Dimensions.black,
                                    color: AppColors.neonGold,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.xxl),

                      // Name + handle + badges
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              me.name,
                              style: TextStyle(
                                fontSize: Dimensions.sizeTitleLarge,
                                fontWeight: Dimensions.black,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              "@${me.short.toLowerCase()}",
                              style: TextStyle(
                                fontSize: Dimensions.sizeSmall,
                                color: AppColors.white.withOpacity(AppColors.opacity40),
                                letterSpacing: Dimensions.trackingTight,
                              ),
                            ),
                            SizedBox(height: Dimensions.dotLg),
                            if (me.tags.isNotEmpty)
                              Wrap(
                                spacing: Dimensions.iconGap,
                                runSpacing: Dimensions.xs,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  for (int i = 0; i < me.tags.length; i++)
                                    (i == 0) ? ClipRRect(
                                      borderRadius: Dimensions.ribbonLeft,
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                          Dimensions.md, Dimensions.xs,
                                          Dimensions.md, Dimensions.xs + 1,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: AppColors.goldRibbonGradient,
                                        ),
                                        child: Text(
                                          me.tags[i],
                                          style: TextStyle(
                                            fontSize: Dimensions.sizeTiny,
                                            fontWeight: Dimensions.black,
                                            letterSpacing: 1.4,
                                            color: AppColors.goldDeep,
                                          ),
                                        ),
                                      ),
                                    ) : Container(
                                      padding: Dimensions.pillPadding,
                                      decoration: BoxDecoration(
                                        color: AppColors.neonGold.withOpacity(AppColors.opacity10),
                                        borderRadius: Dimensions.borderSm,
                                        border: Border.all(
                                          color: AppColors.neonGold.withOpacity(AppColors.opacity35),
                                          width: Dimensions.borderThin,
                                        ),
                                      ),
                                      child: Text(
                                        me.tags[i],
                                        style: Dimensions.pillLabel(context,
                                          color: AppColors.goldLight.withOpacity(AppColors.opacity90),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.xxl),

                  // Gold divider
                  Container(
                    height: Dimensions.dividerHeight,
                    decoration: BoxDecoration(
                      gradient: AppColors.dividerGradient(color: AppColors.neonGold, opacity: AppColors.opacity25),
                    ),
                  ),

                  SizedBox(height: Dimensions.xxl),

                  // Stat chips row
                  Row(
                    children: [
                      _StatChip(label: "PTS", value: "${me.pts}"),
                      SizedBox(width: Dimensions.md),
                      _StatChip(label: "GOALS", value: "${me.goals}"),
                      SizedBox(width: Dimensions.md),
                      _StatChip(label: "WINS", value: "${me.wins}"),
                      SizedBox(width: Dimensions.md),
                      _StatChip(label: "MATCHES", value: "${me.matches}"),
                    ],
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
    });
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.md),
        decoration: BoxDecoration(
          color: AppColors.neonGold.withOpacity(AppColors.opacity7),
          borderRadius: Dimensions.borderDef,
          border: Border.all(
            color: AppColors.neonGold.withOpacity(0.22),
            width: Dimensions.borderThin,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Dimensions.statValue(context),
            ),
            SizedBox(height: Dimensions.xs),
            Text(
              label,
              style: Dimensions.labelUppercase(context),
            ),
          ],
        ),
      ),
    );
  }
}
