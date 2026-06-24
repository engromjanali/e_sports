import 'package:e_sports/core/utils/dimensions.dart';
import "../domain/model/match_model.dart";
import "package:get/get.dart";
import '../../../core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

class FullMatchCard extends StatelessWidget {
  final MatchModel match;
  const FullMatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final isLive = match.status == "live";
    final isCompleted = match.status == "finished";
    final isCancelled = match.status == "cancelled";
    Color statusColor = isLive
        ? AppColors.neonRed
        : isCompleted
        ? AppColors.neonGreen
        : isCancelled
        ? AppColors.textMuted
        : AppColors.neonBlue;

    return GlassCardWidget(
      padding: EdgeInsets.all(Dimensions.cardInnerPadding),
      borderColor: isLive ? AppColors.neonRed.withOpacity(AppColors.opacity30) : AppColors.glassBorder,
      shadows: Dimensions.accentGlow(
        isLive ? AppColors.neonRed : Colors.black,
        opacity: AppColors.opacity20,
        blur: 16,
        offset: const Offset(0, 4),
      ),
      child: Column(children: [
        // Status row
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("${match.date} · ${match.time}",
              style: TextStyle(fontSize: Dimensions.sizeSmall, color: AppColors.textMuted)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.lg,
              vertical: Dimensions.xs,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(AppColors.opacity12),
              borderRadius: Dimensions.borderPill,
              border: Border.all(color: statusColor.withOpacity(AppColors.opacity30)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (isLive)
                Container(
                  width: Dimensions.dotMd,
                  height: Dimensions.dotMd,
                  margin: EdgeInsets.only(right: Dimensions.xs + 1),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
                ),
              Text(match.status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: Dimensions.sizeCaption,
                    fontWeight: Dimensions.extraBold,
                  )),
            ]),
          ),
        ]),
        SizedBox(height: Dimensions.xl),

        // Teams row
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("⚽", style: TextStyle(fontSize: 28)),
                Text(match.team1,
                    style: TextStyle(
                        fontSize: Dimensions.sizeSubtitle,
                        fontWeight: Dimensions.extraBold,
                        color: AppColors.textPrimary)),
              ])),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.xxxl,
              vertical: Dimensions.iconGap,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: Dimensions.borderMd + const BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Text(isCompleted ? ("${match.score1} - ${match.score2}") : isCancelled ? "–" : "VS",
                style: TextStyle(
                    fontSize: Dimensions.sizeTitleLarge,
                    fontWeight: Dimensions.black,
                    color: AppColors.textPrimary)),
          ),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text("⚽", style: TextStyle(fontSize: 28)),
                Text(match.team2,
                    style: TextStyle(
                        fontSize: Dimensions.sizeSubtitle,
                        fontWeight: Dimensions.extraBold,
                        color: AppColors.textPrimary)),
              ])),
        ]),

        if (isCompleted && match.resultLabel != null) ...[
          SizedBox(height: Dimensions.lg),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: Dimensions.dotLg),
            decoration: BoxDecoration(
              color: match.resultType == "win"
                  ? AppColors.neonGreen.withOpacity(AppColors.opacity10)
                  : match.resultType == "loss"
                  ? AppColors.neonRed.withOpacity(AppColors.opacity10)
                  : AppColors.neonGold.withOpacity(AppColors.opacity10),
              borderRadius: Dimensions.borderDef,
            ),
            child: Text(match.resultLabel!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.sizeBody,
                  fontWeight: Dimensions.extraBold,
                  color: match.resultType == "win"
                      ? AppColors.neonGreen
                      : match.resultType == "loss"
                      ? AppColors.neonRed
                      : AppColors.neonGold,
                )),
          ),
        ],

        if (isCancelled) ...[
          SizedBox(height: Dimensions.lg),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: Dimensions.dotLg),
            decoration: BoxDecoration(
              color: AppColors.textMuted.withOpacity(AppColors.opacity10),
              borderRadius: Dimensions.borderDef,
              border: Border.all(color: AppColors.textMuted.withOpacity(AppColors.opacity20)),
            ),
            child: Text("MATCH CANCELLED",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.sizeBody,
                  fontWeight: Dimensions.extraBold,
                  color: AppColors.textMuted,
                )),
          ),
        ],

        if (!isCompleted && !isCancelled && match.slots != null) ...[
          SizedBox(height: Dimensions.md),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("👥 ${match.slots} players joined",
                style: TextStyle(fontSize: Dimensions.sizeSmall, color: AppColors.textMuted)),
          ]),
        ],
      ]),
    );
  }
}
