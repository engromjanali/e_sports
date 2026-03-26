import 'package:e_sports/core/theme/app_theme.dart';
import "package:e_sports/core/controllers/app_data_controller.dart";
import "package:e_sports/core/data/models/match_model.dart";
import "package:get/get.dart";
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

class FullMatchCard extends StatelessWidget {
  final MatchModel match;
  const FullMatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final isLive = match.status == "live";
    final isCompleted = match.status == "completed" || match.status == "finished";
    Color statusColor = isLive
        ? AppColors.neonRed
        : isCompleted
        ? AppColors.neonGreen
        : AppColors.neonBlue;

    return GlassCardWidget(
      padding: EdgeInsets.all(AppSpacing.cardInnerPadding),
      borderColor: isLive ? AppColors.neonRed.withOpacity(AppColors.opacity30) : AppColors.glassBorder,
      shadows: AppElevation.accentGlow(
        isLive ? AppColors.neonRed : Colors.black,
        opacity: AppColors.opacity20,
        blur: 16,
        offset: const Offset(0, 4),
      ),
      child: Column(children: [
        // Status row
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("${match.date} · ${match.time}",
              style: TextStyle(fontSize: AppTypography.sizeSmall, color: AppColors.textMuted)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(AppColors.opacity12),
              borderRadius: AppRadius.borderPill,
              border: Border.all(color: statusColor.withOpacity(AppColors.opacity30)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (isLive)
                Container(
                  width: AppSizing.dotMd,
                  height: AppSizing.dotMd,
                  margin: EdgeInsets.only(right: AppSpacing.xs + 1),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
                ),
              Text(match.status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: AppTypography.sizeCaption,
                    fontWeight: AppTypography.extraBold,
                  )),
            ]),
          ),
        ]),
        SizedBox(height: AppSpacing.xl),

        // Teams row
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("⚽", style: TextStyle(fontSize: 28)),
                Text(match.team1,
                    style: TextStyle(
                        fontSize: AppTypography.sizeSubtitle,
                        fontWeight: AppTypography.extraBold,
                        color: AppColors.textPrimary)),
              ])),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xxxl,
              vertical: AppSpacing.iconGap,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: AppRadius.borderMd + const BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Text(isCompleted ? ("${match.score1} - ${match.score2}") : "VS",
                style: TextStyle(
                    fontSize: AppTypography.sizeTitleLarge,
                    fontWeight: AppTypography.black,
                    color: AppColors.textPrimary)),
          ),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text("⚽", style: TextStyle(fontSize: 28)),
                Text(match.team2,
                    style: TextStyle(
                        fontSize: AppTypography.sizeSubtitle,
                        fontWeight: AppTypography.extraBold,
                        color: AppColors.textPrimary)),
              ])),
        ]),

        if (isCompleted && match.resultLabel != null) ...[
          SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: AppSizing.dotLg),
            decoration: BoxDecoration(
              color: match.resultType == "win"
                  ? AppColors.neonGreen.withOpacity(AppColors.opacity10)
                  : match.resultType == "loss"
                  ? AppColors.neonRed.withOpacity(AppColors.opacity10)
                  : AppColors.neonGold.withOpacity(AppColors.opacity10),
              borderRadius: AppRadius.borderDef,
            ),
            child: Text(match.resultLabel!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppTypography.sizeBody,
                  fontWeight: AppTypography.extraBold,
                  color: match.resultType == "win"
                      ? AppColors.neonGreen
                      : match.resultType == "loss"
                      ? AppColors.neonRed
                      : AppColors.neonGold,
                )),
          ),
        ],

        if (!isCompleted && match.slots != null) ...[
          SizedBox(height: AppSpacing.md),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("👥 ${match.slots} players joined",
                style: TextStyle(fontSize: AppTypography.sizeSmall, color: AppColors.textMuted)),
          ]),
        ],
      ]),
    );
  }
}
