import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/main.dart';
import 'package:flutter/material.dart';

class PotBannerWidget extends StatelessWidget {
  final PlayerModel player; final String label, badge; final Gradient gradient;
  const PotBannerWidget({required this.player, required this.label, required this.gradient, required this.badge});

  @override
  Widget build(BuildContext context) {
    final c = playerColor(player.name);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: AppColors.neonBlue.withOpacity(0.2), blurRadius: 16)]),
      child: Row(children: [
        Stack(clipBehavior: Clip.none, children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(colors: [c, c.withOpacity(0.6)]),
              border: Border.all(color: AppColors.neonGold, width: 3),
            ),
            alignment: Alignment.center,
            child: Text(player.name[0],
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
          ),
          Positioned(top: -12, left: 0, right: 0,
              child: Text(badge, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20))),
        ]),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 8, color: Colors.white.withOpacity(0.5), letterSpacing: 1.5)),
          const SizedBox(height: 2),
          Text(player.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
          Text("${player.matches} matches",
              style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5))),
          const SizedBox(height: 8),
          Row(children: [
            StatMiniWidget(label: "Goals", value: "${player.goals}", color: AppColors.neonGold),
            const SizedBox(width: 16),
            StatMiniWidget(label: "Pts",   value: "${player.pts}",   color: Colors.white),
            const SizedBox(width: 16),
            StatMiniWidget(label: "FA",    value: "${player.fa}",    color: AppColors.neonGold),
          ]),
        ])),
      ]),
    );
  }
}

class StatMiniWidget extends StatelessWidget {
  final String label, value;
  final Color color;
  const StatMiniWidget({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color)),
    Text(label, style: TextStyle(fontSize: 7, color: Colors.white.withOpacity(0.4))),
  ]);
}
