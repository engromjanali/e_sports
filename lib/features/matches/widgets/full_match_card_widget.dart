import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

class FullMatchCard extends StatelessWidget {
  final MatchModel match;
  const FullMatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final isLive = match.status == "live";
    final isCompleted = match.status == "completed";
    Color statusColor = isLive
        ? AppColors.neonRed
        : isCompleted
        ? AppColors.neonGreen
        : AppColors.neonBlue;

    return GlassCardWidget(
      padding: const EdgeInsets.all(14),
      borderColor: isLive ? AppColors.neonRed.withOpacity(0.3) : AppColors.glassBorder,
      shadows: [
        BoxShadow(
            color: (isLive ? AppColors.neonRed : Colors.black).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4)),
      ],
      child: Column(children: [
        // Status row
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("${match.date} · ${match.time}",
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (isLive)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 4),
                  decoration:
                  BoxDecoration(shape: BoxShape.circle, color: statusColor),
                ),
              Text(match.status.toUpperCase(),
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w800)),
            ]),
          ),
        ]),
        const SizedBox(height: 12),

        // Teams row
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(match.i1, style: const TextStyle(fontSize: 28)),
                Text(match.t1,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
              ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Text(isCompleted ? (match.score ?? "VS") : "VS",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary)),
          ),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(match.i2, style: const TextStyle(fontSize: 28)),
                Text(match.t2,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
              ])),
        ]),

        if (isCompleted && match.resultLabel != null) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              color: match.resultType == "win"
                  ? AppColors.neonGreen.withOpacity(0.1)
                  : match.resultType == "loss"
                  ? AppColors.neonRed.withOpacity(0.1)
                  : AppColors.neonGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Text(match.resultLabel!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: match.resultType == "win"
                      ? AppColors.neonGreen
                      : match.resultType == "loss"
                      ? AppColors.neonRed
                      : AppColors.neonGold,
                )),
          ),
        ],

        if (!isCompleted && match.slots != null) ...[
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("👥 ${match.slots} players joined",
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ]),
        ],
      ]),
    );
  }
}
