import 'package:e_sports/core/theme/app_theme.dart';
import "package:e_sports/core/controllers/app_data_controller.dart";
import "package:e_sports/core/data/models/match_model.dart";
import "package:get/get.dart";
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

class MatchMiniCard extends StatelessWidget {
  final MatchModel match;
  const MatchMiniCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final isLive = match.status == "live";
    return GlassCardWidget(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.cardInnerPadding,
        vertical: AppSpacing.body2,
      ),
      borderColor: isLive
          ? AppColors.neonRed.withOpacity(AppColors.opacity30)
          : AppColors.glassBorder,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Text("⚽", style: TextStyle(fontSize: AppTypography.sizeHeadingLg + 2)), // Default emoji
            SizedBox(width: AppSpacing.md),
            Text(match.team1,
                style: TextStyle(
                    fontSize: AppTypography.sizeBody,
                    fontWeight: AppTypography.bold,
                    color: AppColors.textPrimary)),
          ]),
          Column(children: [
            Text(match.date, style: TextStyle(
              fontSize: AppTypography.sizeCaption,
              color: AppColors.textMuted,
            )),
            Text(match.time,
                style: TextStyle(
                    fontSize: AppTypography.sizeBody2,
                    fontWeight: AppTypography.extraBold,
                    color: AppColors.textPrimary)),
            if (isLive)
              Row(children: [
                Container(
                    width: AppSizing.dotMd,
                    height: AppSizing.dotMd,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.neonRed)),
                SizedBox(width: AppSpacing.xs),
                Text("LIVE",
                    style: TextStyle(
                        fontSize: AppTypography.sizeCaption,
                        color: AppColors.neonRed,
                        fontWeight: AppTypography.extraBold)),
              ]),
          ]),
          Row(children: [
            Text(match.team2,
                style: TextStyle(
                    fontSize: AppTypography.sizeBody,
                    fontWeight: AppTypography.bold,
                    color: AppColors.textPrimary)),
            SizedBox(width: AppSpacing.md),
            Text("⚽", style: TextStyle(fontSize: AppTypography.sizeHeadingLg + 2)),
          ]),
        ],
      ),
    );
  }
}
