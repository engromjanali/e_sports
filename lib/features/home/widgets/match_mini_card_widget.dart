import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';

class MatchMiniCard extends StatelessWidget {
  final MatchModel match;
  const MatchMiniCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final isLive = match.status == "live";
    return GlassCardWidget(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      borderColor: isLive ? AppColors.neonRed.withOpacity(0.3) : AppColors.glassBorder,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Text(match.i1, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(match.t1,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ]),
          Column(children: [
            Text(match.date, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
            Text(match.time,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            if (isLive)
              Row(children: [
                Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.neonRed)),
                const SizedBox(width: 3),
                const Text("LIVE",
                    style: TextStyle(
                        fontSize: 9,
                        color: AppColors.neonRed,
                        fontWeight: FontWeight.w800)),
              ]),
          ]),
          Row(children: [
            Text(match.t2,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(width: 8),
            Text(match.i2, style: const TextStyle(fontSize: 22)),
          ]),
        ],
      ),
    );
  }
}
