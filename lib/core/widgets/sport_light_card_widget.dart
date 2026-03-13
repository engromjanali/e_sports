import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/glow_circle_widget.dart';
import 'package:flutter/material.dart';

class SpotlightCardWidget extends StatelessWidget {
  final PlayerModel player;
  final String label, badge;
  final Gradient gradient;
  const SpotlightCardWidget({required this.player, required this.label, required this.badge, required this.gradient});

  @override
  Widget build(BuildContext context) {
    final c = playerColor(player.name);
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 14, 13, 14),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.neonGold.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12)],
      ),
      child: Stack(children: [
        Positioned(top: -20, right: -20, child: GlowCircleWidget(size: 90, color: Colors.white.withOpacity(0.05))),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800,
              color: Colors.white.withOpacity(0.5), letterSpacing: 1.5)),
          const SizedBox(height: 10),
          Stack(clipBehavior: Clip.none, children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(colors: [c, c.withOpacity(0.6)]),
                border: Border.all(color: AppColors.neonGold.withOpacity(0.7), width: 2.5),
                boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.25), blurRadius: 12)],
              ),
              alignment: Alignment.center,
              child: Text(player.name[0],
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
            ),
            Positioned(top: -10, right: -6, child: Text(badge, style: const TextStyle(fontSize: 16))),
          ]),
          const SizedBox(height: 8),
          Text(player.short, style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2)),
          Text("${player.matches} matches",
              style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.5))),
          const SizedBox(height: 8),
          Row(children: [
            StatMiniWidget(label: "Goals", value: "${player.goals}", color: AppColors.neonGold),
            const SizedBox(width: 10),
            StatMiniWidget(label: "Pts",   value: "${player.pts}",   color: Colors.white),
            const SizedBox(width: 10),
            StatMiniWidget(label: "FA",    value: "${player.fa}",    color: AppColors.neonGold),
          ]),
        ]),
      ]),
    );
  }
}
