import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/widgets/neon_pregress_bar_widget.dart';
import 'package:e_sports/main.dart';
import 'package:flutter/material.dart';

class MyRankCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B4E), Color(0xFF1B4FD8)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.neonGold.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: AppColors.neonBlue.withOpacity(0.2), blurRadius: 18)],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.neonGold.withOpacity(0.15),
              border: Border.all(color: AppColors.neonGold, width: 2),
            ),
            alignment: Alignment.center,
            child: const Text("🏅", style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("YOUR RANK", style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.5))),
            const Text("#1", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, height: 1)),
            const Text("Elite Gamer", style: TextStyle(fontSize: 10, color: AppColors.neonGold)),
          ]),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Text("946", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
          Text("Points", style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5))),
          const SizedBox(height: 5),
          SizedBox(
            width: 80,
            child: NeonProgressBarWidget(value: 82, max: 100, color: AppColors.neonGold, height: 5),
          ),
        ]),
      ]),
    );
  }
}
