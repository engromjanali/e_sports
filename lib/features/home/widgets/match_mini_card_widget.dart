import 'package:e_sports/core/utils/dimensions.dart';
import "../../../core/controllers/app_data_controller.dart";
import "../../matches/domain/model/match_model.dart";
import "package:get/get.dart";
import '../../../core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

class MatchMiniCard extends StatelessWidget {
  final MatchModel match;
  const MatchMiniCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final isLive = match.status == "live";
    return GlassCardWidget(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.cardInnerPadding,
        vertical: Dimensions.body2,
      ),
      borderColor: isLive
          ? AppColors.neonRed.withOpacity(AppColors.opacity30)
          : AppColors.glassBorder,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Text("⚽", style: TextStyle(fontSize: Dimensions.sizeHeadingLg + 2)), // Default emoji
            SizedBox(width: Dimensions.md),
            Text(match.team1,
                style: TextStyle(
                    fontSize: Dimensions.sizeBody,
                    fontWeight: Dimensions.bold,
                    color: AppColors.textPrimary)),
          ]),
          Column(children: [
            Text(match.date, style: TextStyle(
              fontSize: Dimensions.sizeCaption,
              color: AppColors.textMuted,
            )),
            Text(match.time,
                style: TextStyle(
                    fontSize: Dimensions.sizeBody2,
                    fontWeight: Dimensions.extraBold,
                    color: AppColors.textPrimary)),
            if (isLive)
              Row(children: [
                Container(
                    width: Dimensions.dotMd,
                    height: Dimensions.dotMd,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.neonRed)),
                SizedBox(width: Dimensions.xs),
                Text("LIVE",
                    style: TextStyle(
                        fontSize: Dimensions.sizeCaption,
                        color: AppColors.neonRed,
                        fontWeight: Dimensions.extraBold)),
              ]),
          ]),
          Row(children: [
            Text(match.team2,
                style: TextStyle(
                    fontSize: Dimensions.sizeBody,
                    fontWeight: Dimensions.bold,
                    color: AppColors.textPrimary)),
            SizedBox(width: Dimensions.md),
            Text("⚽", style: TextStyle(fontSize: Dimensions.sizeHeadingLg + 2)),
          ]),
        ],
      ),
    );
  }
}
